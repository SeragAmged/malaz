# Daily Leaders Feature Design

**Date:** 2026-04-24  
**Status:** Approved  
**Scope:** Add realtime daily leaderboard showing top 3 room members by focus time

## Overview

The Daily Leaders feature displays a leaderboard on the room page showing the top 3 members ranked by total focus hours completed today. The leaderboard updates in realtime when members complete focus sessions.

## Architecture

### Database Layer

**Function:** `daily_room_leaderboard(v_room_id uuid)`

Already created by user. Returns:
- `user_name` (text): Member's full name
- `total_focus_hours` (numeric): Total focus time in hours, rounded to 2 decimals

Filters:
- Only completed sessions (`ended_at IS NOT NULL`)
- Only focus sessions (`session_type = 'focus'`)
- Only today's sessions (between midnight and midnight UTC)
- Limits to top 3 results
- Ordered by `total_focus_hours DESC`

### Data Models

**LeaderboardEntry** (new model)
```dart
class LeaderboardEntry {
  final String userName;
  final double totalFocusHours;
}
```

### Repository Layer

**RoomMembersRepository** (extend existing)

Add method:
```dart
Future<Result<List<LeaderboardEntry>, DomainError>> getTopLeaders(String roomId);
```

Implementation calls the `daily_room_leaderboard(roomId)` RPC function via Supabase and maps results to `LeaderboardEntry` entities.

### State Management

**RoomMembersState** (extend existing)

Add field:
```dart
@Default([]) List<LeaderboardEntry> topLeaders;
```

This keeps leaderboard data in the same state as active residents, maintaining single source of truth.

### Cubit Logic

**RoomMembersCubit** (enhance existing)

Current behavior:
- Subscribes to `room_members` realtime changes
- Subscribes to `pomodoro_sessions` for the room

Enhancement:
1. Detect `ended_at` field changes in the `pomodoro_sessions` subscription
2. When a session's `ended_at` is updated (session completion), trigger `_refreshLeaderboard()`
3. `_refreshLeaderboard()` calls `repository.getTopLeaders(roomId)` and updates state

This ensures leaderboard only refetches when sessions actually complete, avoiding unnecessary queries.

### UI Layer

**_LeaderboardCard** (update existing)

Changes:
- Remove hardcoded `leaders` list
- Wrap with `BlocBuilder<RoomMembersCubit, RoomMembersState>`
- Read `state.topLeaders` instead of hardcoded data
- Show loading state if `state.isLoading && state.topLeaders.isEmpty`
- Show error if `state.errorMessage != null && state.topLeaders.isEmpty`
- Display each entry as: rank number + name, hours value

Display format:
- `1. {userName}` → `{totalFocusHours}h`
- Shows exactly 3 entries (or fewer if fewer members have completed focus sessions today)

## Data Flow

1. User opens room page
2. RoomPage initializes RoomMembersCubit
3. Cubit subscribes to `pomodoro_sessions` realtime
4. Initial leaderboard fetch happens (via existing init flow)
5. User(s) complete focus sessions → `ended_at` field updates in Supabase
6. Realtime event fires with updated session data
7. RoomMembersCubit detects `ended_at` change → calls `_refreshLeaderboard()`
8. Leaderboard data fetches and state updates
9. UI rebuilds with new rankings

## Error Handling

- If leaderboard fetch fails, show error message in card (same pattern as ActiveResidentsCard)
- Error doesn't block member data display
- Retry happens on next session completion event

## Testing Considerations

- Unit test leaderboard fetch in RoomMembersRepositoryImpl
- Unit test leaderboard update logic in RoomMembersCubit
- Integration test: verify leaderboard updates when session ends
- UI test: verify display with 0, 1, 2, 3+ members with focus time

## Future Extensions

- Filter by room instead of global daily
- Weekly/monthly leaderboards
- Streak tracking
- Achievement badges
