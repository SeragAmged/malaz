# Realtime Active Residents Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Replace the hardcoded `_ActiveResidentsCard` with a live member list showing each user's focus time and break countdown, updated via Supabase Realtime.

**Architecture:** A new `RoomMembersCubit` fetches `room_members_with_session` on mount, subscribes to Postgres changes on `room_members` and `pomodoro_sessions` (filtered to current room), re-fetches on any event, and ticks every 1s locally to drive countdown/countup display.

**Tech Stack:** BLoC (cubit), Supabase Realtime, freezed state, injectable DI

---

## Task 1: Create Entity & Model

**Files:**
- Create: `lib/features/rooms/domain/entities/room_member_with_session.dart`
- Create: `lib/features/rooms/data/models/room_member_with_session_model.dart`

- [ ] **Step 1: Create the entity**

```dart
// lib/features/rooms/domain/entities/room_member_with_session.dart

class RoomMemberWithSession {
  const RoomMemberWithSession({
    required this.userId,
    required this.fullName,
    required this.avatarUrl,
    required this.status,
    required this.lastCheckinAt,
    required this.completedFocusSeconds,
    this.sessionId,
    this.sessionType,
    this.startedAt,
    this.plannedMinutes,
    this.pausedAt,
    this.totalPausedSeconds,
  });

  final String userId;
  final String fullName;
  final String? avatarUrl;
  final String status; // 'online' | 'working' | 'onBreak' | 'idle' | 'offline'
  final DateTime lastCheckinAt;
  final int completedFocusSeconds;
  
  // Active session fields (nullable)
  final String? sessionId;
  final String? sessionType; // 'focus' | 'breakTime'
  final DateTime? startedAt;
  final int? plannedMinutes;
  final DateTime? pausedAt;
  final int? totalPausedSeconds;
}
```

- [ ] **Step 2: Create the model with fromJson**

```dart
// lib/features/rooms/data/models/room_member_with_session_model.dart

import '../../domain/entities/room_member_with_session.dart';

class RoomMemberWithSessionModel {
  const RoomMemberWithSessionModel({
    required this.userId,
    required this.fullName,
    required this.avatarUrl,
    required this.status,
    required this.lastCheckinAt,
    required this.completedFocusSeconds,
    this.sessionId,
    this.sessionType,
    this.startedAt,
    this.plannedMinutes,
    this.pausedAt,
    this.totalPausedSeconds,
  });

  final String userId;
  final String fullName;
  final String? avatarUrl;
  final String status;
  final DateTime lastCheckinAt;
  final int completedFocusSeconds;
  final String? sessionId;
  final String? sessionType;
  final DateTime? startedAt;
  final int? plannedMinutes;
  final DateTime? pausedAt;
  final int? totalPausedSeconds;

  factory RoomMemberWithSessionModel.fromJson(Map<String, dynamic> json) {
    return RoomMemberWithSessionModel(
      userId: json['user_id'] as String,
      fullName: json['full_name'] as String,
      avatarUrl: json['avatar_url'] as String?,
      status: json['status'] as String,
      lastCheckinAt: DateTime.parse(json['last_checkin_at'] as String),
      completedFocusSeconds: json['completed_focus_seconds'] as int,
      sessionId: json['session_id'] as String?,
      sessionType: json['session_type'] as String?,
      startedAt: json['started_at'] != null
          ? DateTime.parse(json['started_at'] as String)
          : null,
      plannedMinutes: json['planned_minutes'] as int?,
      pausedAt: json['paused_at'] != null
          ? DateTime.parse(json['paused_at'] as String)
          : null,
      totalPausedSeconds: json['total_paused_seconds'] as int?,
    );
  }

  RoomMemberWithSession toEntity() => RoomMemberWithSession(
    userId: userId,
    fullName: fullName,
    avatarUrl: avatarUrl,
    status: status,
    lastCheckinAt: lastCheckinAt,
    completedFocusSeconds: completedFocusSeconds,
    sessionId: sessionId,
    sessionType: sessionType,
    startedAt: startedAt,
    plannedMinutes: plannedMinutes,
    pausedAt: pausedAt,
    totalPausedSeconds: totalPausedSeconds,
  );
}
```

- [ ] **Step 3: Commit**

```bash
git add lib/features/rooms/domain/entities/room_member_with_session.dart \
        lib/features/rooms/data/models/room_member_with_session_model.dart
git commit -m "feat(rooms): add RoomMemberWithSession entity and model"
```

---

## Task 2: Update Supabase View

**Files:**
- Modify: Supabase `room_members_with_session` view

- [ ] **Step 1: Create migration**

Create file `supabase/migrations/20260423_update_room_members_with_session_view.sql`:

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

- [ ] **Step 2: Apply migration to Supabase**

Run from project root:
```bash
supabase migration up
```

Or use the Supabase CLI tool if available.

- [ ] **Step 3: Verify in Supabase dashboard**

Navigate to Supabase > SQL Editor > `room_members_with_session` and check that it has the new `completed_focus_seconds` column.

- [ ] **Step 4: Commit migration**

```bash
git add supabase/migrations/20260423_update_room_members_with_session_view.sql
git commit -m "db: add completed_focus_seconds to room_members_with_session view"
```

---

## Task 3: Add Datasource Methods

**Files:**
- Modify: `lib/features/rooms/data/datasources/rooms_remote_datasource.dart`

- [ ] **Step 1: Add import for RealtimeChannel**

At the top of `rooms_remote_datasource.dart`, add:

```dart
import 'package:supabase_flutter/supabase_flutter.dart';
```

(It's likely already imported, but verify.)

- [ ] **Step 2: Add getMembersWithSession method**

Add to `RoomsRemoteDataSource` class:

```dart
Future<List<RoomMemberWithSessionModel>> getMembersWithSession(
  String roomId,
) async {
  final data = await supabase
      .from('room_members_with_session')
      .select()
      .eq('room_id', roomId);
  
  return (data as List)
      .map((json) => RoomMemberWithSessionModel.fromJson(
            Map<String, dynamic>.from(json as Map),
          ))
      .toList();
}
```

- [ ] **Step 3: Add subscribeToRoomChanges method**

Add to `RoomsRemoteDataSource` class:

```dart
RealtimeChannel subscribeToRoomChanges(
  String roomId,
  VoidCallback onEvent,
) {
  final channel = supabase.realtime.channel(
    'room_changes_$roomId',
    opts: const RealtimeChannelConfig(
      filter: 'room_id=eq.$roomId',
    ),
  );

  // Subscribe to room_members changes
  channel.on(
    RealtimeListenTypes.postgresChanges,
    ChannelFilter(
      event: '*',
      schema: 'public',
      table: 'room_members',
      filter: 'room_id=eq.$roomId',
    ),
    (payload, [_]) {
      onEvent();
    },
  );

  // Subscribe to pomodoro_sessions changes
  channel.on(
    RealtimeListenTypes.postgresChanges,
    ChannelFilter(
      event: '*',
      schema: 'public',
      table: 'pomodoro_sessions',
      filter: 'room_id=eq.$roomId',
    ),
    (payload, [_]) {
      onEvent();
    },
  );

  channel.subscribe();
  return channel;
}
```

- [ ] **Step 4: Add unsubscribeFromRoomChanges method**

Add to `RoomsRemoteDataSource` class:

```dart
Future<void> unsubscribeFromRoomChanges(RealtimeChannel channel) async {
  await supabase.realtime.removeChannel(channel);
}
```

- [ ] **Step 5: Commit**

```bash
git add lib/features/rooms/data/datasources/rooms_remote_datasource.dart
git commit -m "feat(datasource): add member list and realtime subscription methods"
```

---

## Task 4: Create Repository Interface & Implementation

**Files:**
- Create: `lib/features/rooms/domain/repositories/room_members_repository.dart`
- Create: `lib/features/rooms/data/repositories/room_members_repository_impl.dart`

- [ ] **Step 1: Create repository interface**

```dart
// lib/features/rooms/domain/repositories/room_members_repository.dart

import 'package:supabase_flutter/supabase_flutter.dart';
import '../entities/room_member_with_session.dart';
import '../../../core/network/result.dart';

abstract class RoomMembersRepository {
  Future<Result<List<RoomMemberWithSession>>> getMembers(String roomId);
  RealtimeChannel subscribeToRoomChanges(String roomId, VoidCallback onEvent);
  Future<void> unsubscribeFromRoomChanges(RealtimeChannel channel);
}
```

- [ ] **Step 2: Create repository implementation**

```dart
// lib/features/rooms/data/repositories/room_members_repository_impl.dart

import 'package:injectable/injectable.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../domain/entities/room_member_with_session.dart';
import '../../domain/repositories/room_members_repository.dart';
import '../../../core/network/result.dart';
import '../datasources/rooms_remote_datasource.dart';

@Injectable(as: RoomMembersRepository)
class RoomMembersRepositoryImpl implements RoomMembersRepository {
  final RoomsRemoteDataSource _datasource;

  RoomMembersRepositoryImpl({required RoomsRemoteDataSource datasource})
      : _datasource = datasource;

  @override
  Future<Result<List<RoomMemberWithSession>>> getMembers(String roomId) async {
    try {
      final models = await _datasource.getMembersWithSession(roomId);
      return Result.success(models.map((m) => m.toEntity()).toList());
    } catch (e) {
      return Result.failure(
        Exception('Failed to fetch room members: $e'),
        StackTrace.current,
      );
    }
  }

  @override
  RealtimeChannel subscribeToRoomChanges(
    String roomId,
    VoidCallback onEvent,
  ) {
    return _datasource.subscribeToRoomChanges(roomId, onEvent);
  }

  @override
  Future<void> unsubscribeFromRoomChanges(RealtimeChannel channel) async {
    await _datasource.unsubscribeFromRoomChanges(channel);
  }
}
```

- [ ] **Step 3: Commit**

```bash
git add lib/features/rooms/domain/repositories/room_members_repository.dart \
        lib/features/rooms/data/repositories/room_members_repository_impl.dart
git commit -m "feat(rooms): add RoomMembersRepository interface and impl"
```

---

## Task 5: Create RoomMembersState

**Files:**
- Create: `lib/features/rooms/presentation/cubit/room_members_state.dart`

- [ ] **Step 1: Create freezed state**

```dart
// lib/features/rooms/presentation/cubit/room_members_state.dart

import 'package:freezed_annotation/freezed_annotation.dart';
import '../../data/models/room_member_with_session_model.dart';

part 'room_members_state.freezed.dart';

@freezed
abstract class RoomMembersState with _$RoomMembersState {
  const factory RoomMembersState({
    @Default([]) List<RoomMemberWithSessionModel> members,
    @Default(false) bool isLoading,
    String? errorMessage,
    DateTime? localNow,
  }) = _RoomMembersState;
}
```

- [ ] **Step 2: Run build_runner to generate freezed code**

```bash
dart run build_runner build
```

- [ ] **Step 3: Commit**

```bash
git add lib/features/rooms/presentation/cubit/room_members_state.dart \
        lib/features/rooms/presentation/cubit/room_members_state.freezed.dart
git commit -m "feat(cubit): add RoomMembersState freezed class"
```

---

## Task 6: Create RoomMembersCubit

**Files:**
- Create: `lib/features/rooms/presentation/cubit/room_members_cubit.dart`

- [ ] **Step 1: Create the cubit class**

```dart
// lib/features/rooms/presentation/cubit/room_members_cubit.dart

import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../domain/repositories/room_members_repository.dart';
import 'room_members_state.dart';

@injectable
class RoomMembersCubit extends Cubit<RoomMembersState> {
  final String roomId;
  final RoomMembersRepository _repository;

  Timer? _ticker;
  RealtimeChannel? _realtimeChannel;

  RoomMembersCubit({
    required this.roomId,
    required RoomMembersRepository repository,
  })  : _repository = repository,
        super(const RoomMembersState());

  @override
  Future<void> close() async {
    _ticker?.cancel();
    if (_realtimeChannel != null) {
      await _repository.unsubscribeFromRoomChanges(_realtimeChannel!);
    }
    return super.close();
  }

  /// Initialize: fetch members and start realtime subscription
  Future<void> init() async {
    await _fetchMembers();
    _startRealtimeSubscription();
    _startTicker();
  }

  /// Fetch members with session data
  Future<void> _fetchMembers() async {
    if (!isClosed) {
      emit(state.copyWith(isLoading: true));
    }

    final result = await _repository.getMembers(roomId);

    if (isClosed) return;

    result.fold(
      onSuccess: (members) {
        emit(
          state.copyWith(
            members: members
                .map((e) => RoomMemberWithSessionModel(
                      userId: e.userId,
                      fullName: e.fullName,
                      avatarUrl: e.avatarUrl,
                      status: e.status,
                      lastCheckinAt: e.lastCheckinAt,
                      completedFocusSeconds: e.completedFocusSeconds,
                      sessionId: e.sessionId,
                      sessionType: e.sessionType,
                      startedAt: e.startedAt,
                      plannedMinutes: e.plannedMinutes,
                      pausedAt: e.pausedAt,
                      totalPausedSeconds: e.totalPausedSeconds,
                    ))
                .toList(),
            isLoading: false,
            errorMessage: null,
          ),
        );
      },
      onFailure: (error, _) {
        emit(
          state.copyWith(
            isLoading: false,
            errorMessage: error.message ?? 'Failed to fetch members',
          ),
        );
      },
    );
  }

  /// Start realtime subscription to room_members and pomodoro_sessions
  void _startRealtimeSubscription() {
    _realtimeChannel = _repository.subscribeToRoomChanges(
      roomId,
      _onRealtimeEvent,
    );
  }

  /// Callback when a realtime event occurs
  void _onRealtimeEvent() {
    _fetchMembers();
  }

  /// Start 1-second ticker to update localNow
  void _startTicker() {
    _ticker?.cancel();
    _ticker = Timer.periodic(const Duration(seconds: 1), (_) {
      if (!isClosed) {
        emit(state.copyWith(localNow: DateTime.now()));
      }
    });
  }

  /// Called when app goes to background
  Future<void> onPause() async {
    _ticker?.cancel();
    if (_realtimeChannel != null) {
      await _repository.unsubscribeFromRoomChanges(_realtimeChannel!);
      _realtimeChannel = null;
    }
  }

  /// Called when app resumes
  Future<void> onResume() async {
    await _fetchMembers();
    _startRealtimeSubscription();
    _startTicker();
  }
}
```

- [ ] **Step 2: Commit**

```bash
git add lib/features/rooms/presentation/cubit/room_members_cubit.dart
git commit -m "feat(cubit): add RoomMembersCubit with realtime and ticker"
```

---

## Task 7: Register DI

**Files:**
- Modify: `lib/core/di/providers.config.dart`

- [ ] **Step 1: Run build_runner to regenerate DI**

```bash
dart run build_runner build
```

This will auto-register `RoomMembersCubit` and `RoomMembersRepository` based on the `@injectable` annotations.

- [ ] **Step 2: Verify DI**

Check `providers.config.dart` contains:
- Registration for `RoomMembersRepository` → `RoomMembersRepositoryImpl`
- Factory for `RoomMembersCubit(roomId, repository)`

- [ ] **Step 3: Commit**

```bash
git add lib/core/di/providers.config.dart
git commit -m "di: regenerate with RoomMembers types"
```

---

## Task 8: Update RoomPage UI

**Files:**
- Modify: `lib/features/rooms/presentation/pages/room_page.dart`

- [ ] **Step 1: Add RoomMembersCubit import and initialization in RoomPage**

In `_RoomPageState`, add a new field:

```dart
late RoomMembersCubit _roomMembersCubit;
```

In `initState()`, after `_timerCubit` initialization, add:

```dart
_roomMembersCubit = getIt<RoomMembersCubit>(param1: widget.roomId);
_roomMembersCubit.init();
```

In `dispose()`, add before `_timerCubit.close()`:

```dart
_roomMembersCubit.close();
```

- [ ] **Step 2: Update didChangeAppLifecycleState**

Replace the entire `didChangeAppLifecycleState` method with:

```dart
@override
void didChangeAppLifecycleState(AppLifecycleState state) {
  switch (state) {
    case AppLifecycleState.resumed:
      _timerCubit.setOnline();
      _roomMembersCubit.onResume();
      break;
    case AppLifecycleState.paused:
      _timerCubit.setOffline();
      _roomMembersCubit.onPause();
      break;
    case AppLifecycleState.detached:
    case AppLifecycleState.hidden:
    case AppLifecycleState.inactive:
      break;
  }
}
```

- [ ] **Step 3: Replace _ActiveResidentsCard with BlocBuilder**

Find the `_ActiveResidentsCard()` instantiation (around line 152) and replace the entire `_ActiveResidentsCard` widget class (lines ~703-879) with:

```dart
class _ActiveResidentsCard extends StatelessWidget {
  const _ActiveResidentsCard();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RoomMembersCubit, RoomMembersState>(
      builder: (context, state) {
        if (state.isLoading && state.members.isEmpty) {
          return Container(
            padding: EdgeInsets.all(24.r),
            decoration: BoxDecoration(
              color: AppColors.cardSurfaceColor,
              borderRadius: BorderRadius.circular(24.r),
            ),
            child: const Center(
              child: CircularProgressIndicator(),
            ),
          );
        }

        if (state.errorMessage != null && state.members.isEmpty) {
          return Container(
            padding: EdgeInsets.all(24.r),
            decoration: BoxDecoration(
              color: AppColors.cardSurfaceColor,
              borderRadius: BorderRadius.circular(24.r),
            ),
            child: Text(
              'Error: ${state.errorMessage}',
              style: AppTextStyles.bodySmall.copyWith(
                color: AppColors.errorColor,
              ),
            ),
          );
        }

        return Container(
          padding: EdgeInsets.all(24.r),
          decoration: BoxDecoration(
            color: AppColors.cardSurfaceColor,
            borderRadius: BorderRadius.circular(24.r),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'ACTIVE RESIDENTS',
                style: AppTextStyles.cardTagMedium.copyWith(
                  fontSize: 12.sp,
                  letterSpacing: 2.4,
                  color: AppColors.textSecondaryColor,
                  fontFamily: AppTextStyles.spaceGrotesk,
                  fontWeight: FontWeight.w400,
                ),
              ),
              SizedBox(height: 24.h),
              if (state.members.isEmpty)
                Text(
                  'No active members',
                  style: AppTextStyles.bodySmall.copyWith(
                    color: AppColors.textSecondaryColor,
                  ),
                )
              else
                ...state.members.map(
                  (member) => Padding(
                    padding: EdgeInsets.only(bottom: 16.h),
                    child: _UserRow(
                      member: member,
                      localNow: state.localNow ?? DateTime.now(),
                    ),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}
```

- [ ] **Step 4: Update _UserRow to accept member data and compute display**

Replace the entire `_UserRow` and `_UserData` classes with:

```dart
class _UserRow extends StatelessWidget {
  const _UserRow({
    required this.member,
    required this.localNow,
  });

  final RoomMemberWithSessionModel member;
  final DateTime localNow;

  /// Compute display strings based on member state
  ({String? focusDisplay, String? subLabel}) _computeDisplay() {
    // No active session — show status
    if (member.sessionId == null) {
      return (
        focusDisplay: null,
        subLabel: member.status == 'online'
            ? 'Online'
            : member.status == 'idle'
            ? 'Idle'
            : 'Offline',
      );
    }

    // Focus session running
    if (member.sessionType == 'focus' && member.startedAt != null) {
      final elapsed =
          localNow.difference(member.startedAt!).inSeconds -
          (member.totalPausedSeconds ?? 0);
      final totalSeconds = member.completedFocusSeconds + elapsed;
      final display = _formatSeconds(totalSeconds);
      return (
        focusDisplay: '⏱️ $display',
        subLabel: null,
      );
    }

    // Focus session paused
    if (member.sessionType == 'focus' &&
        member.pausedAt != null &&
        member.startedAt != null) {
      final elapsed =
          member.pausedAt!.difference(member.startedAt!).inSeconds -
          (member.totalPausedSeconds ?? 0);
      final totalSeconds = member.completedFocusSeconds + elapsed;
      final display = _formatSeconds(totalSeconds);
      return (
        focusDisplay: '⏱️ $display',
        subLabel: '⏸ Paused',
      );
    }

    // Break session running
    if (member.sessionType == 'breakTime' &&
        member.startedAt != null &&
        member.plannedMinutes != null) {
      final focusDisplay = _formatSeconds(member.completedFocusSeconds);
      final breakRemaining = (member.plannedMinutes! * 60) -
          (localNow.difference(member.startedAt!).inSeconds -
              (member.totalPausedSeconds ?? 0));
      final breakDisplay =
          breakRemaining > 0 ? _formatSeconds(breakRemaining) : '00:00';
      return (
        focusDisplay: '⏱️ $focusDisplay',
        subLabel: '☕ break ends in $breakDisplay',
      );
    }

    return (focusDisplay: null, subLabel: null);
  }

  String _formatSeconds(int seconds) {
    final hours = seconds ~/ 3600;
    final mins = (seconds % 3600) ~/ 60;
    final secs = seconds % 60;
    return '${hours.toString().padLeft(2, '0')}:${mins.toString().padLeft(2, '0')}:${secs.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    final display = _computeDisplay();
    final opacity = member.status == 'offline' ? 0.5 : 1.0;

    return Opacity(
      opacity: opacity,
      child: Row(
        children: [
          _AvatarWithStatus(statusColor: _statusColor(member.status)),
          SizedBox(width: 12.w),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                member.fullName,
                style: AppTextStyles.titleSmall.copyWith(
                  fontSize: 14.sp,
                  color: AppColors.textPrimaryColor,
                ),
              ),
              if (display.focusDisplay != null)
                Text(
                  display.focusDisplay!,
                  style: AppTextStyles.bodySmall.copyWith(
                    fontSize: 12.sp,
                    color: AppColors.primaryColor,
                    fontFamily: AppTextStyles.spaceGrotesk,
                  ),
                ),
              if (display.subLabel != null)
                Text(
                  display.subLabel!,
                  style: AppTextStyles.bodySmall.copyWith(
                    fontSize: 12.sp,
                    color: AppColors.textSecondaryColor,
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }

  Color _statusColor(String status) {
    switch (status) {
      case 'online':
        return AppColors.primaryColor;
      case 'working':
        return const Color(0xFF18BB4B);
      case 'onBreak':
        return const Color(0xFFDC9624);
      case 'idle':
        return const Color(0xFF2C96E5);
      case 'offline':
        return AppColors.textTertiaryColor;
      default:
        return AppColors.textTertiaryColor;
    }
  }
}

// Keep _AvatarWithStatus as is (no changes needed)
class _AvatarWithStatus extends StatelessWidget {
  const _AvatarWithStatus({required this.statusColor});

  final Color statusColor;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 44.r,
      height: 44.r,
      child: Stack(
        children: [
          Container(
            width: 40.r,
            height: 40.r,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.surfaceColor,
            ),
            child: Icon(
              Icons.person,
              size: 20.r,
              color: AppColors.textTertiaryColor,
            ),
          ),
          Positioned(
            right: 0,
            bottom: 0,
            child: Container(
              width: 12.r,
              height: 12.r,
              decoration: BoxDecoration(
                color: statusColor,
                shape: BoxShape.circle,
                border: Border.all(color: AppColors.cardSurfaceColor, width: 2),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
```

- [ ] **Step 5: Add RoomMemberWithSessionModel import at top**

Add to imports in `room_page.dart`:

```dart
import 'package:malaz/features/rooms/data/models/room_member_with_session_model.dart';
```

- [ ] **Step 6: Run the app and test**

```bash
flutter run
```

Navigate to a room and verify:
- Members list shows with names and statuses
- Live timers update every second
- Opening/closing the app doesn't break it

- [ ] **Step 7: Commit**

```bash
git add lib/features/rooms/presentation/pages/room_page.dart
git commit -m "feat(ui): wire RoomMembersCubit and update ActiveResidentsCard with realtime members"
```

---

## Task 9: Final Cleanup & Testing

**Files:**
- Review all files

- [ ] **Step 1: Run static analysis**

```bash
dart analyze
```

Fix any analysis issues.

- [ ] **Step 2: Run tests**

```bash
flutter test
```

Ensure no regressions.

- [ ] **Step 3: Manual testing checklist**

- [ ] Members list loads on room entry
- [ ] Live focus timer ticks up every second during focus session
- [ ] Live break timer ticks down every second during break
- [ ] Switching to another app and back doesn't crash or duplicate subscriptions
- [ ] Paused timer stays frozen
- [ ] Offline member appears faded

- [ ] **Step 4: Final commit**

```bash
git status
```

Ensure everything is clean. If any stragglers, add and commit:

```bash
git add .
git commit -m "test(rooms): verify realtime members feature"
```

---

## Summary

✅ Database: Updated `room_members_with_session` view with `completed_focus_seconds`  
✅ Data layer: Entity, model, datasource methods, repository  
✅ Presentation: State, cubit with realtime subscription and 1s ticker  
✅ UI: `_ActiveResidentsCard` now renders live member data with display logic  
✅ DI: Auto-registered via `@injectable`  
✅ Lifecycle: Pauses/resumes subscription on app background/foreground  

---

Plan complete and saved to `docs/superpowers/plans/2026-04-23-realtime-active-residents.md`.

**Two execution options:**

**1. Subagent-Driven (recommended)** — I dispatch a fresh subagent per task, review between tasks, fast iteration

**2. Inline Execution** — Execute tasks in this session using executing-plans, batch execution with checkpoints

**Which approach?**
