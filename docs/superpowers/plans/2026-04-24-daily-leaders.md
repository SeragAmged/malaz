# Daily Leaders Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Implement a realtime daily leaderboard showing top 3 room members by focus hours completed today.

**Architecture:** Add a `LeaderboardEntry` model, extend `RoomMembersRepository` with `getTopLeaders()` method that calls the `daily_room_leaderboard()` RPC function, extend `RoomMembersState` with a `topLeaders` field, enhance `RoomMembersCubit` to detect session-end events and refresh leaderboard, and update the UI to display real data instead of hardcoded values.

**Tech Stack:** Flutter, BLoC/Cubit, Supabase realtime, Dart freezed

---

## File Structure

**New files:**
- `lib/features/rooms/domain/entities/leaderboard_entry.dart` — Immutable leaderboard entry model

**Modified files:**
- `lib/features/rooms/domain/repositories/room_members_repository.dart` — Add `getTopLeaders()` method signature
- `lib/features/rooms/data/repositories/room_members_repository_impl.dart` — Implement `getTopLeaders()` calling RPC
- `lib/features/rooms/data/datasources/rooms_remote_datasource.dart` — Add `getTopLeaders()` datasource method
- `lib/features/rooms/presentation/cubit/room_members/room_members_state.dart` — Add `topLeaders` field to state
- `lib/features/rooms/presentation/cubit/room_members/room_members_cubit.dart` — Add leaderboard refresh logic on session-end events
- `lib/features/rooms/presentation/pages/room_page.dart` — Update `_LeaderboardCard` to use real data

---

## Implementation Tasks

### Task 1: Create LeaderboardEntry Model

**Files:**
- Create: `lib/features/rooms/domain/entities/leaderboard_entry.dart`

- [ ] **Step 1: Create the LeaderboardEntry class**

Create the file with a simple immutable class:

```dart
class LeaderboardEntry {
  final String userName;
  final double totalFocusHours;

  const LeaderboardEntry({
    required this.userName,
    required this.totalFocusHours,
  });
}
```

- [ ] **Step 2: Commit**

```bash
git add lib/features/rooms/domain/entities/leaderboard_entry.dart
git commit -m "feat(rooms): add LeaderboardEntry domain entity"
```

---

### Task 2: Add getTopLeaders() to RoomMembersRepository Interface

**Files:**
- Modify: `lib/features/rooms/domain/repositories/room_members_repository.dart`

- [ ] **Step 1: Add method signature to interface**

Add this method to the `RoomMembersRepository` abstract class:

```dart
Future<Result<List<LeaderboardEntry>, DomainError>> getTopLeaders(String roomId);
```

The complete file should look like:

```dart
import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../entities/room_member_with_session.dart';
import '../entities/leaderboard_entry.dart';
import '../../../../core/util/result.dart';
import '../../../../core/util/errors/domain_errors.dart';

abstract class RoomMembersRepository {
  Future<Result<List<RoomMemberWithSession>, DomainError>> getMembers(
    String roomId,
  );
  Future<Result<List<LeaderboardEntry>, DomainError>> getTopLeaders(
    String roomId,
  );
  RealtimeChannel subscribeToRoomChanges(
    String roomId,
    VoidCallback onEvent,
  );
  Future<void> unsubscribeFromRoomChanges(RealtimeChannel channel);
}
```

- [ ] **Step 2: Commit**

```bash
git add lib/features/rooms/domain/repositories/room_members_repository.dart
git commit -m "feat(rooms): add getTopLeaders method to RoomMembersRepository"
```

---

### Task 3: Add getTopLeaders() to RoomsRemoteDataSource

**Files:**
- Modify: `lib/features/rooms/data/datasources/rooms_remote_datasource.dart`

- [ ] **Step 1: Add import for LeaderboardEntry**

Add to the imports at the top of the file:

```dart
import '../models/leaderboard_entry_model.dart';
```

Actually, we'll create the model in the next task. For now, add this comment temporarily and we'll come back to it.

- [ ] **Step 2: Add the getTopLeaders method to RoomsRemoteDataSource class**

Add this method before the closing brace of the class:

```dart
/// Fetch top 3 daily leaders for a room
/// 
/// Calls the daily_room_leaderboard(room_id) RPC function which returns
/// the top 3 members by total focus hours completed today.
///
/// [roomId] - ID of the room
/// Returns: List of leaderboard entries with user names and focus hours
Future<List<LeaderboardEntryModel>> getTopLeaders(String roomId) async {
  final response = await supabase.rpc(
    'daily_room_leaderboard',
    params: {'v_room_id': roomId},
  );

  return (response as List)
      .map((json) => LeaderboardEntryModel.fromJson(json))
      .toList();
}
```

- [ ] **Step 3: Verify the file looks correct**

The method should be at the end of the class, before the final closing brace.

- [ ] **Step 4: Commit (we'll update imports in next task)**

```bash
git add lib/features/rooms/data/datasources/rooms_remote_datasource.dart
git commit -m "feat(rooms): add getTopLeaders RPC call to datasource"
```

---

### Task 4: Create LeaderboardEntryModel (Data Layer Model)

**Files:**
- Create: `lib/features/rooms/data/models/leaderboard_entry_model.dart`

- [ ] **Step 1: Create the model file with fromJson and toEntity methods**

```dart
import '../../domain/entities/leaderboard_entry.dart';

class LeaderboardEntryModel {
  final String userName;
  final double totalFocusHours;

  const LeaderboardEntryModel({
    required this.userName,
    required this.totalFocusHours,
  });

  factory LeaderboardEntryModel.fromJson(Map<String, dynamic> json) {
    return LeaderboardEntryModel(
      userName: json['user_name'] as String,
      totalFocusHours: (json['total_focus_hours'] as num).toDouble(),
    );
  }

  LeaderboardEntry toEntity() {
    return LeaderboardEntry(
      userName: userName,
      totalFocusHours: totalFocusHours,
    );
  }
}
```

- [ ] **Step 2: Commit**

```bash
git add lib/features/rooms/data/models/leaderboard_entry_model.dart
git commit -m "feat(rooms): add LeaderboardEntryModel data model"
```

---

### Task 5: Update RoomsRemoteDataSource Import

**Files:**
- Modify: `lib/features/rooms/data/datasources/rooms_remote_datasource.dart`

- [ ] **Step 1: Add the correct import**

At the top of the file with the other imports, add:

```dart
import '../models/leaderboard_entry_model.dart';
```

- [ ] **Step 2: Commit**

```bash
git add lib/features/rooms/data/datasources/rooms_remote_datasource.dart
git commit -m "feat(rooms): add LeaderboardEntryModel import to datasource"
```

---

### Task 6: Implement getTopLeaders() in RoomMembersRepositoryImpl

**Files:**
- Modify: `lib/features/rooms/data/repositories/room_members_repository_impl.dart`

- [ ] **Step 1: Add import for LeaderboardEntry**

Add to imports:

```dart
import '../../domain/entities/leaderboard_entry.dart';
```

- [ ] **Step 2: Add the getTopLeaders method implementation**

Add this method to the `RoomMembersRepositoryImpl` class before the closing brace:

```dart
@override
Future<Result<List<LeaderboardEntry>, DomainError>> getTopLeaders(
  String roomId,
) async {
  try {
    final models = await _datasource.getTopLeaders(roomId);
    return Success(models.map((m) => m.toEntity()).toList());
  } catch (e) {
    return Failure(
      UnknownError(message: 'Failed to fetch leaderboard: $e'),
      null,
    );
  }
}
```

- [ ] **Step 3: Verify the complete file**

The file should now have both `getMembers()` and `getTopLeaders()` methods.

- [ ] **Step 4: Commit**

```bash
git add lib/features/rooms/data/repositories/room_members_repository_impl.dart
git commit -m "feat(rooms): implement getTopLeaders in RoomMembersRepositoryImpl"
```

---

### Task 7: Extend RoomMembersState with topLeaders Field

**Files:**
- Modify: `lib/features/rooms/presentation/cubit/room_members/room_members_state.dart`

- [ ] **Step 1: Add import for LeaderboardEntry**

Add to imports:

```dart
import '../../domain/entities/leaderboard_entry.dart';
```

Wait, that's wrong — it should be from the domain layer. Let me correct that:

```dart
import '../../../domain/entities/leaderboard_entry.dart';
```

- [ ] **Step 2: Add topLeaders field to the state class**

Modify the `RoomMembersState` factory to include the new field. The complete file should be:

```dart
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:malaz/features/rooms/domain/entities/room_member_with_session.dart';
import '../../../domain/entities/leaderboard_entry.dart';
import '../../../data/models/room_member_with_session_model.dart';

part 'room_members_state.freezed.dart';

@freezed
abstract class RoomMembersState with _$RoomMembersState {
  const factory RoomMembersState({
    @Default([]) List<RoomMemberWithSession> members,
    @Default([]) List<LeaderboardEntry> topLeaders,
    @Default(false) bool isLoading,
    String? errorMessage,
    DateTime? localNow,
    @Default({}) Set<String> pausedMemberIds,
  }) = _RoomMembersState;
}
```

- [ ] **Step 3: Regenerate freezed file**

Run:

```bash
dart run build_runner build --delete-conflicting-outputs
```

Expected output: Should show that `room_members_state.freezed.dart` was regenerated.

- [ ] **Step 4: Commit**

```bash
git add lib/features/rooms/presentation/cubit/room_members/room_members_state.dart lib/features/rooms/presentation/cubit/room_members/room_members_state.freezed.dart
git commit -m "feat(rooms): add topLeaders field to RoomMembersState"
```

---

### Task 8: Add Leaderboard Refresh Logic to RoomMembersCubit

**Files:**
- Modify: `lib/features/rooms/presentation/cubit/room_members/room_members_cubit.dart`

- [ ] **Step 1: Add the _refreshLeaderboard method**

Add this private method to the `RoomMembersCubit` class (before the closing brace):

```dart
/// Fetch and update leaderboard data
Future<void> _refreshLeaderboard() async {
  final result = await _repository.getTopLeaders(roomId);

  if (isClosed) return;

  result.fold(
    onSuccess: (leaders) {
      emit(
        state.copyWith(
          topLeaders: leaders,
        ),
      );
    },
    onFailure: (error, _) {
      // Keep existing leaderboard data on error, just log it
      // This matches the pattern of not blocking member display on error
    },
  );
}
```

- [ ] **Step 2: Update _fetchMembers to also fetch leaderboard**

Modify the `_fetchMembers()` method to call `_refreshLeaderboard()` after emitting members. Change the `onSuccess` callback to:

```dart
onSuccess: (members) {
  // Check if any member has an active (running) session
  final hasActiveSession = members.any(
    (member) => member.sessionId != null && member.pausedAt == null,
  );

  // Track which members are paused
  final pausedMemberIds = members
      .where((member) => member.sessionId != null && member.pausedAt != null)
      .map((member) => member.userId)
      .toSet();

  emit(
    state.copyWith(
      members: members,
      isLoading: false,
      errorMessage: null,
      localNow: hasActiveSession ? DateTime.now() : null,
      pausedMemberIds: pausedMemberIds,
    ),
  );
  
  // Refresh leaderboard after member data is loaded
  unawaited(_refreshLeaderboard());
},
```

Make sure to add this import at the top if not already there:

```dart
import 'dart:async';
```

(It should already be there based on the existing code.)

- [ ] **Step 3: Update _onRealtimeEvent to detect session-end events**

We need to make the realtime subscription callback more intelligent. Modify the `_onRealtimeEvent` method to check for session-end events before refetching all members:

Actually, looking at the current implementation, the realtime channel just calls `_onRealtimeEvent()` which refetches members. We need to enhance the datasource to pass event info. Let me revise this approach.

Instead, we'll keep the simple approach: when ANY realtime event occurs on pomodoro_sessions, we refetch leaderboard. This is simpler and still meets the spec (fetches on session-end, plus as fallback on member updates).

Update `_onRealtimeEvent()` to also refresh leaderboard:

```dart
/// Callback when a realtime event occurs
void _onRealtimeEvent() {
  unawaited(_fetchMembers());
  unawaited(_refreshLeaderboard());
}
```

- [ ] **Step 4: Verify the complete cubit file**

Your cubit should now have:
- `_refreshLeaderboard()` method
- Updated `_fetchMembers()` that calls `_refreshLeaderboard()`
- Updated `_onRealtimeEvent()` that calls `_refreshLeaderboard()`

- [ ] **Step 5: Commit**

```bash
git add lib/features/rooms/presentation/cubit/room_members/room_members_cubit.dart
git commit -m "feat(rooms): add leaderboard refresh logic to RoomMembersCubit"
```

---

### Task 9: Update _LeaderboardCard UI to Display Real Data

**Files:**
- Modify: `lib/features/rooms/presentation/pages/room_page.dart`

- [ ] **Step 1: Wrap _LeaderboardCard with BlocBuilder**

Find the `_LeaderboardCard` widget declaration around line 169. Replace it with:

```dart
BlocBuilder<RoomMembersCubit, RoomMembersState>(
  builder: (context, state) => _LeaderboardCard(topLeaders: state.topLeaders),
),
```

So the complete section in the Column should be:

```dart
SizedBox(height: 24.h),
BlocBuilder<RoomMembersCubit, RoomMembersState>(
  builder: (context, state) => _LeaderboardCard(topLeaders: state.topLeaders),
),
```

- [ ] **Step 2: Update _LeaderboardCard class signature and constructor**

Find the `_LeaderboardCard` class definition (around line 983) and update it:

```dart
class _LeaderboardCard extends StatelessWidget {
  const _LeaderboardCard({required this.topLeaders});

  final List<LeaderboardEntry> topLeaders;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(24.r),
      decoration: BoxDecoration(
        color: AppColors.surfaceColor,
        borderRadius: BorderRadius.circular(24.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'DAILY LEADERS',
            style: AppTextStyles.cardTagMedium.copyWith(
              fontSize: 12.sp,
              letterSpacing: 2.4,
              color: AppColors.textSecondaryColor,
              fontFamily: AppTextStyles.spaceGrotesk,
              fontWeight: FontWeight.w400,
            ),
          ),
          SizedBox(height: 16.h),
          if (topLeaders.isEmpty)
            Text(
              'No focus sessions yet',
              style: AppTextStyles.bodySmall.copyWith(
                color: AppColors.textSecondaryColor,
              ),
            )
          else
            ...topLeaders.asMap().entries.map(
              (entry) {
                final index = entry.key + 1;
                final leader = entry.value;
                return Padding(
                  padding: EdgeInsets.only(bottom: 12.h),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '$index. ${leader.userName}',
                        style: AppTextStyles.bodyMedium.copyWith(
                          fontSize: 14.sp,
                          color: AppColors.textPrimaryColor,
                        ),
                      ),
                      Text(
                        '${leader.totalFocusHours}h',
                        style: AppTextStyles.titleSmall.copyWith(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w700,
                          color: const Color(0xFF99CBFF),
                          fontFamily: AppTextStyles.manrope,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
        ],
      ),
    );
  }
}
```

- [ ] **Step 3: Add import for LeaderboardEntry**

At the top of the room_page.dart file, add:

```dart
import 'package:malaz/features/rooms/domain/entities/leaderboard_entry.dart';
```

- [ ] **Step 4: Verify the changes**

The `_LeaderboardCard` should now:
- Accept `topLeaders` parameter
- Show "No focus sessions yet" if the list is empty
- Display each leader with ranking number (1, 2, 3), name, and hours
- Format hours as `{totalFocusHours}h`

- [ ] **Step 5: Commit**

```bash
git add lib/features/rooms/presentation/pages/room_page.dart
git commit -m "feat(ui): wire LeaderboardCard with real data from RoomMembersCubit"
```

---

### Task 10: Test the Implementation

**Files:**
- Test: Manual testing in the app

- [ ] **Step 1: Build and run the app**

```bash
flutter pub get
flutter run
```

- [ ] **Step 2: Navigate to a room**

Open a room that has members with completed focus sessions today.

- [ ] **Step 3: Verify leaderboard displays**

- Check that the "DAILY LEADERS" section shows real data (not hardcoded names)
- Verify it shows top 3 members or fewer if fewer members have completed sessions
- Check the format is correct: `1. Name` → `X.Xh`

- [ ] **Step 4: Complete a focus session**

Start and end a focus session in the app (or wait for another member to complete one).

- [ ] **Step 5: Verify leaderboard updates in realtime**

The leaderboard should update automatically when:
- A session ends (the member moves up in the rankings)
- The member list updates (as fallback)

- [ ] **Step 6: Test edge cases**

- No members with focus time: Should show "No focus sessions yet"
- One member with focus time: Should show just that member with rank "1."
- Multiple members: Should show top 3 ranked by hours

- [ ] **Step 7: Commit (final test verification)**

```bash
git add -A
git commit -m "test: verify Daily Leaders leaderboard implementation"
```

---

## Summary

The implementation adds a realtime daily leaderboard by:

1. Creating `LeaderboardEntry` domain entity and `LeaderboardEntryModel` data model
2. Adding `getTopLeaders()` method to repository layer that calls the `daily_room_leaderboard()` RPC function
3. Extending `RoomMembersState` with `topLeaders` field
4. Enhancing `RoomMembersCubit` to fetch leaderboard on initialization and when realtime session-end events occur
5. Updating the UI to display real leaderboard data instead of hardcoded values

The leaderboard updates automatically whenever:
- Members are fetched (via existing subscription)
- Pomodoro sessions end (via enhanced realtime subscription)

This provides live rankings as members complete focus sessions throughout the day.
