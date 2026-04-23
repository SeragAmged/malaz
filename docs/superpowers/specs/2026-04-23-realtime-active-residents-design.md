# Realtime Active Residents Design

**Date:** 2026-04-23  
**Feature:** Live member list with per-user session countdowns/countups in the Room page

---

## Overview

Replace the hardcoded `_ActiveResidentsCard` mock data with a realtime member list. Each member row shows:
- A live **focus total** (HH:MM:SS counting up) during focus sessions
- A live **break countdown** (MM:SS counting down) during break sessions  
- Frozen focus total while on break or paused
- Status label (Online / Idle / Offline) when no active session

Realtime is driven by Supabase Postgres Change subscriptions on `room_members` and `pomodoro_sessions`, filtered to the current room. A local 1s ticker drives the countdown/countup display between DB events.

---

## 1. Database

### Update `room_members_with_session` view

Add a `completed_focus_seconds` column — the sum of all ended focus sessions for each member since their `last_checkin_at` in the current room.

```sql
CREATE OR REPLACE VIEW room_members_with_session AS
SELECT 
  rm.id,
  rm.room_id,
  rm.user_id,
  rm.status,
  rm.joined_at,
  rm.last_checkin_at,
  p.full_name,
  p.avatar_url,
  ps.id AS session_id,
  ps.session_type,
  ps.started_at,
  ps.planned_minutes,
  ps.paused_at,
  ps.total_paused_seconds,
  COALESCE((
    SELECT SUM(
      EXTRACT(EPOCH FROM (s.ended_at - s.started_at))::int 
      - s.total_paused_seconds
    )
    FROM pomodoro_sessions s
    WHERE s.user_id = rm.user_id
      AND s.room_id = rm.room_id
      AND s.session_type = 'focus'
      AND s.ended_at IS NOT NULL
      AND s.started_at >= rm.last_checkin_at
  ), 0) AS completed_focus_seconds
FROM room_members rm
JOIN profiles p ON p.id = rm.user_id
LEFT JOIN pomodoro_sessions ps 
  ON ps.user_id = rm.user_id 
  AND ps.room_id = rm.room_id 
  AND ps.ended_at IS NULL;
```

---

## 2. Data Layer

### New model: `RoomMemberWithSession`

Fields:
- `userId: String`
- `fullName: String`
- `avatarUrl: String?`
- `status: String` — `online | working | onBreak | idle | offline`
- `lastCheckinAt: DateTime`
- `completedFocusSeconds: int` — sum of ended focus sessions since last_checkin_at
- Active session fields (all nullable — member may have no active session):
  - `sessionId: String?`
  - `sessionType: String?` — `focus | breakTime`
  - `startedAt: DateTime?`
  - `plannedMinutes: int?`
  - `pausedAt: DateTime?`
  - `totalPausedSeconds: int?`

### New datasource methods on `RoomsRemoteDataSource`

```dart
Future<List<RoomMemberWithSession>> getMembersWithSession(String roomId)
```
Queries `room_members_with_session` with `.eq('room_id', roomId)`.

```dart
RealtimeChannel subscribeToRoomChanges(String roomId, VoidCallback onEvent)
```
Creates and subscribes a single `RealtimeChannel` that listens to Postgres changes on both `room_members` and `pomodoro_sessions`, filtered to `room_id=eq.<roomId>`. Calls `onEvent` on any INSERT/UPDATE/DELETE from either table. Returns the channel so the caller can unsubscribe later.

```dart
Future<void> unsubscribeFromRoomChanges(RealtimeChannel channel)
```
Removes the channel from the Supabase client.

### New repository interface: `RoomMembersRepository`

```dart
abstract class RoomMembersRepository {
  Future<Result<List<RoomMemberWithSession>>> getMembers(String roomId);
  RealtimeChannel subscribeToRoomChanges(String roomId, VoidCallback onEvent);
  Future<void> unsubscribeFromRoomChanges(RealtimeChannel channel);
}
```

### New repository impl: `RoomMembersRepositoryImpl`

Delegates all three methods to `RoomsRemoteDataSource`.

---

## 3. Presentation Layer

### New state: `RoomMembersState` (freezed)

```dart
@freezed
class RoomMembersState with _$RoomMembersState {
  const factory RoomMembersState({
    @Default([]) List<RoomMemberWithSession> members,
    @Default(false) bool isLoading,
    String? errorMessage,
    DateTime? localNow,  // updated every second by ticker
  }) = _RoomMembersState;
}
```

### New cubit: `RoomMembersCubit`

**Dependencies:** `RoomMembersRepository`

**Lifecycle:**

1. `init(roomId)` — fetch members, call `_repository.subscribeToRoomChanges(roomId, _onRoomEvent)`, start 1s ticker
2. `_onRoomEvent()` — re-fetch `getMembers(roomId)` and emit updated members
3. `Timer.periodic(1s)` — `emit(state.copyWith(localNow: DateTime.now()))`
4. `onPause()` — cancel ticker; call `_repository.unsubscribeFromRoomChanges(_channel)`
5. `onResume()` — re-fetch, re-subscribe via `_repository.subscribeToRoomChanges`, restart ticker
6. `close()` — cancel ticker, unsubscribe channel

**The cubit never touches `SupabaseClient` directly** — all Realtime and DB access goes through the repository.

### Display logic (computed in widget, not stored in state)

Given `member` and `localNow`:

**Focus running:**
```
totalFocusSeconds = member.completedFocusSeconds 
  + (localNow - member.startedAt).inSeconds 
  - member.totalPausedSeconds
display: HH:MM:SS counting up
```

**Focus paused:**
```
totalFocusSeconds = member.completedFocusSeconds 
  + (member.pausedAt - member.startedAt).inSeconds 
  - member.totalPausedSeconds
display: HH:MM:SS frozen + "⏸ Paused" sublabel
```

**Break running:**
```
// The active session slot is the break session; all focus work is in completedFocusSeconds
focusTotal = member.completedFocusSeconds   // frozen, no active focus session
breakRemaining = member.plannedMinutes * 60 
  - (localNow - member.startedAt).inSeconds 
  + member.totalPausedSeconds
display: HH:MM:SS frozen + "☕ break ends in MM:SS" counting down
```

**No active session:**
```
display: status label (Online / Idle / Offline)
```

---

## 4. UI

### `_ActiveResidentsCard` becomes a `BlocBuilder<RoomMembersCubit, RoomMembersState>`

Each `_UserRow` renders based on the computed display state above.

| Member state | Line 1 | Line 2 | Line 3 |
|---|---|---|---|
| focus running | name | `⏱️ HH:MM:SS` ticking up | — |
| focus paused | name | `⏱️ HH:MM:SS` frozen | `⏸ Paused` |
| break running | name | `⏱️ HH:MM:SS` frozen | `☕ break ends in MM:SS` |
| online / idle | name | `Online` / `Idle` | — |
| offline | name | `Offline` | — |

### `RoomPage` changes

- Instantiate `RoomMembersCubit` alongside `TimerCubit` (both get `roomId`)
- Provide it via `BlocProvider` at page level
- `didChangeAppLifecycleState` calls both:
  - `resumed` → `_timerCubit.setOnline()` + `_roomMembersCubit.onResume()`
  - `paused` → `_timerCubit.setOffline()` + `_roomMembersCubit.onPause()`

---

## 5. DI

Register `RoomMembersCubit` as `@injectable` with `roomId` as a factory param (same pattern as `TimerCubit`). Register `RoomMembersRepository` and its impl.

---

## 6. Files to Create / Modify

### New files
- `lib/features/rooms/data/models/room_member_with_session_model.dart`
- `lib/features/rooms/domain/entities/room_member_with_session.dart`
- `lib/features/rooms/domain/repositories/room_members_repository.dart`
- `lib/features/rooms/data/repositories/room_members_repository_impl.dart`
- `lib/features/rooms/presentation/cubit/room_members_cubit.dart`
- `lib/features/rooms/presentation/cubit/room_members_state.dart`

### Modified files
- `lib/features/rooms/data/datasources/rooms_remote_datasource.dart` — add `getMembersWithSession`
- `lib/features/rooms/presentation/pages/room_page.dart` — wire cubit, update `_ActiveResidentsCard`
- `lib/core/di/providers.config.dart` — register new types
- Supabase: update `room_members_with_session` view migration
