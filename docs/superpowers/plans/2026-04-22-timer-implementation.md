# Timer State Management Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Implement `TimerCubit` with Supabase backend integration for pomodoro session management, replacing local state in `RoomScreen`.

**Architecture:** Domain-driven separation: repositories as interfaces in domain layer, implementations in data layer, cubit owns timer countdown logic and emits immutable state. RoomScreen becomes a stateless consumer via `BlocProvider`. All session actions sync with Supabase RPCs.

**Tech Stack:** Flutter Bloc (cubit), Supabase Flutter SDK, freezed for immutable state, injectable for DI.

---

## File Structure

**Domain Layer (Interfaces):**
- `lib/features/rooms/domain/repositories/session_repository.dart` — SessionRepository interface
- `lib/features/rooms/domain/repositories/presence_repository.dart` — PresenceRepository interface

**Data Layer (Implementations):**
- `lib/features/rooms/data/datasources/session_remote_datasource.dart` — Thin Supabase RPC wrapper
- `lib/features/rooms/data/datasources/presence_remote_datasource.dart` — Member status RPC wrapper
- `lib/features/rooms/data/repositories/session_repository_impl.dart` — SessionRepository impl
- `lib/features/rooms/data/repositories/presence_repository_impl.dart` — PresenceRepository impl

**Presentation Layer (Cubit & State):**
- `lib/features/rooms/presentation/cubit/timer_state.dart` — Freezed immutable state
- `lib/features/rooms/presentation/cubit/timer_cubit.dart` — TimerCubit logic

**UI Updates:**
- Modify: `lib/features/rooms/presentation/pages/room_screen.dart` — Refactor to use TimerCubit

---

## Tasks

### Task 1: Create Domain Repositories (Interfaces)

**Files:**
- Create: `lib/features/rooms/domain/repositories/session_repository.dart`
- Create: `lib/features/rooms/domain/repositories/presence_repository.dart`

- [ ] **Step 1: Create SessionRepository interface**

```dart
// lib/features/rooms/domain/repositories/session_repository.dart
import 'package:malaz/core/util/result.dart';
import 'package:malaz/core/util/errors/domain_errors.dart';

abstract interface class SessionRepository {
  /// Starts a new pomodoro session.
  /// Returns session UUID on success.
  /// [sessionType] must be 'focus' or 'breakTime'
  /// [plannedMinutes] is the intended duration in minutes
  Future<Result<String, DomainError>> startSession(
    String sessionType,
    int plannedMinutes,
  );

  /// Pauses an active session.
  /// Backend records pause_at timestamp.
  Future<Result<void, DomainError>> pauseSession(String sessionId);

  /// Resumes a paused session.
  /// Backend accumulates pause duration and clears pause_at.
  Future<Result<void, DomainError>> resumeSession(String sessionId);

  /// Ends a session with a reason.
  /// [reason] must be 'completed', 'interrupted', or 'abandoned'
  Future<Result<void, DomainError>> endSession(
    String sessionId,
    String reason,
  );
}
```

- [ ] **Step 2: Create PresenceRepository interface**

```dart
// lib/features/rooms/domain/repositories/presence_repository.dart
import 'package:malaz/core/util/result.dart';
import 'package:malaz/core/util/errors/domain_errors.dart';

abstract interface class PresenceRepository {
  /// Updates member status in room_members table.
  /// [status] must be one of: 'online', 'working', 'onBreak', 'idle', 'offline'
  /// Updates last_checkin_at to now().
  Future<Result<void, DomainError>> setStatus(String status);
}
```

- [ ] **Step 3: Commit**

```bash
git add lib/features/rooms/domain/repositories/
git commit -m "feat(rooms): add SessionRepository and PresenceRepository interfaces"
```

---

### Task 2: Create Remote Data Sources

**Files:**
- Create: `lib/features/rooms/data/datasources/session_remote_datasource.dart`
- Create: `lib/features/rooms/data/datasources/presence_remote_datasource.dart`

- [ ] **Step 1: Create SessionRemoteDataSource**

```dart
// lib/features/rooms/data/datasources/session_remote_datasource.dart
import 'package:injectable/injectable.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:malaz/core/util/errors/domain_errors.dart';

@injectable
class SessionRemoteDataSource {
  final SupabaseClient _supabase;

  SessionRemoteDataSource(this._supabase);

  /// Calls start_session RPC.
  /// Returns session UUID.
  Future<String> startSession(String sessionType, int plannedMinutes) async {
    final result = await _supabase.rpc(
      'start_session',
      params: {
        'p_session_type': sessionType,
        'p_planned_minutes': plannedMinutes,
      },
    );
    return result as String;
  }

  /// Calls pause_session RPC.
  Future<void> pauseSession(String sessionId) async {
    await _supabase.rpc(
      'pause_session',
      params: {'p_session_id': sessionId},
    );
  }

  /// Calls resume_session RPC.
  Future<void> resumeSession(String sessionId) async {
    await _supabase.rpc(
      'resume_session',
      params: {'p_session_id': sessionId},
    );
  }

  /// Calls end_session RPC.
  Future<void> endSession(String sessionId, String reason) async {
    await _supabase.rpc(
      'end_session',
      params: {
        'p_session_id': sessionId,
        'p_ended_reason': reason,
      },
    );
  }
}
```

- [ ] **Step 2: Create PresenceRemoteDataSource**

```dart
// lib/features/rooms/data/datasources/presence_remote_datasource.dart
import 'package:injectable/injectable.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

@injectable
class PresenceRemoteDataSource {
  final SupabaseClient _supabase;

  PresenceRemoteDataSource(this._supabase);

  /// Calls set_member_status RPC.
  /// [status] must be 'online', 'working', 'onBreak', 'idle', or 'offline'
  Future<void> setMemberStatus(String status) async {
    await _supabase.rpc(
      'set_member_status',
      params: {'p_status': status},
    );
  }
}
```

- [ ] **Step 3: Commit**

```bash
git add lib/features/rooms/data/datasources/
git commit -m "feat(rooms): add SessionRemoteDataSource and PresenceRemoteDataSource"
```

---

### Task 3: Create Repository Implementations

**Files:**
- Create: `lib/features/rooms/data/repositories/session_repository_impl.dart`
- Create: `lib/features/rooms/data/repositories/presence_repository_impl.dart`

- [ ] **Step 1: Create SessionRepositoryImpl**

```dart
// lib/features/rooms/data/repositories/session_repository_impl.dart
import 'package:injectable/injectable.dart';
import 'package:malaz/core/util/result.dart';
import 'package:malaz/core/util/errors/domain_errors.dart';
import 'package:malaz/features/rooms/data/datasources/session_remote_datasource.dart';
import 'package:malaz/features/rooms/domain/repositories/session_repository.dart';

@Injectable(as: SessionRepository)
class SessionRepositoryImpl implements SessionRepository {
  final SessionRemoteDataSource _dataSource;

  SessionRepositoryImpl(this._dataSource);

  @override
  Future<Result<String, DomainError>> startSession(
    String sessionType,
    int plannedMinutes,
  ) async {
    try {
      final sessionId = await _dataSource.startSession(sessionType, plannedMinutes);
      return Result.success(sessionId);
    } on Exception catch (e) {
      return Result.failure(
        DomainError(message: e.toString()),
        null,
      );
    }
  }

  @override
  Future<Result<void, DomainError>> pauseSession(String sessionId) async {
    try {
      await _dataSource.pauseSession(sessionId);
      return const Result.success(null);
    } on Exception catch (e) {
      return Result.failure(
        DomainError(message: e.toString()),
        null,
      );
    }
  }

  @override
  Future<Result<void, DomainError>> resumeSession(String sessionId) async {
    try {
      await _dataSource.resumeSession(sessionId);
      return const Result.success(null);
    } on Exception catch (e) {
      return Result.failure(
        DomainError(message: e.toString()),
        null,
      );
    }
  }

  @override
  Future<Result<void, DomainError>> endSession(
    String sessionId,
    String reason,
  ) async {
    try {
      await _dataSource.endSession(sessionId, reason);
      return const Result.success(null);
    } on Exception catch (e) {
      return Result.failure(
        DomainError(message: e.toString()),
        null,
      );
    }
  }
}
```

- [ ] **Step 2: Create PresenceRepositoryImpl**

```dart
// lib/features/rooms/data/repositories/presence_repository_impl.dart
import 'package:injectable/injectable.dart';
import 'package:malaz/core/util/result.dart';
import 'package:malaz/core/util/errors/domain_errors.dart';
import 'package:malaz/features/rooms/data/datasources/presence_remote_datasource.dart';
import 'package:malaz/features/rooms/domain/repositories/presence_repository.dart';

@Injectable(as: PresenceRepository)
class PresenceRepositoryImpl implements PresenceRepository {
  final PresenceRemoteDataSource _dataSource;

  PresenceRepositoryImpl(this._dataSource);

  @override
  Future<Result<void, DomainError>> setStatus(String status) async {
    try {
      await _dataSource.setMemberStatus(status);
      return const Result.success(null);
    } on Exception catch (e) {
      return Result.failure(
        DomainError(message: e.toString()),
        null,
      );
    }
  }
}
```

- [ ] **Step 3: Commit**

```bash
git add lib/features/rooms/data/repositories/
git commit -m "feat(rooms): add SessionRepositoryImpl and PresenceRepositoryImpl"
```

---

### Task 4: Create Immutable Timer State

**Files:**
- Create: `lib/features/rooms/presentation/cubit/timer_state.dart`

- [ ] **Step 1: Create timer enums and freezed state**

```dart
// lib/features/rooms/presentation/cubit/timer_state.dart
import 'package:freezed_annotation/freezed_annotation.dart';

part 'timer_state.freezed.dart';

enum TimerStatus { idle, running, paused }

enum SessionMode { focus, breakTime }

@freezed
class TimerState with _$TimerState {
  const TimerState._();

  const factory TimerState({
    @Default(TimerStatus.idle) TimerStatus status,
    @Default(SessionMode.focus) SessionMode mode,
    @Default(1500) int totalSeconds, // 25 min in seconds
    @Default(1500) int remainingSeconds,
    String? sessionId,
    @Default(false) bool isLoading,
    String? errorMessage,
    @Default(25) int focusDuration, // minutes
    @Default(5) int breakDuration, // minutes
  }) = _TimerState;

  bool get isIdle => status == TimerStatus.idle;
  bool get isRunning => status == TimerStatus.running;
  bool get isPaused => status == TimerStatus.paused;

  String get timerDisplay {
    final minutes = (remainingSeconds ~/ 60).toString().padLeft(2, '0');
    final seconds = (remainingSeconds % 60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }
}
```

- [ ] **Step 2: Run build_runner to generate freezed code**

```bash
cd /home/serag/Code/Mobile/Flutter/Tasks/malaz
flutter pub run build_runner build --delete-conflicting-outputs
```

Expected: Generates `timer_state.freezed.dart`

- [ ] **Step 3: Commit**

```bash
git add lib/features/rooms/presentation/cubit/timer_state.dart lib/features/rooms/presentation/cubit/timer_state.freezed.dart
git commit -m "feat(rooms): add TimerState with freezed immutability"
```

---

### Task 5: Create TimerCubit

**Files:**
- Create: `lib/features/rooms/presentation/cubit/timer_cubit.dart`

- [ ] **Step 1: Create TimerCubit with initialization and lifecycle**

```dart
// lib/features/rooms/presentation/cubit/timer_cubit.dart
import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:malaz/features/rooms/domain/repositories/session_repository.dart';
import 'package:malaz/features/rooms/domain/repositories/presence_repository.dart';
import 'timer_state.dart';

@injectable
class TimerCubit extends Cubit<TimerState> {
  final SessionRepository _sessionRepo;
  final PresenceRepository _presenceRepo;
  final String roomId;

  Timer? _ticker;

  TimerCubit({
    required this.roomId,
    required SessionRepository sessionRepository,
    required PresenceRepository presenceRepository,
  })  : _sessionRepo = sessionRepository,
        _presenceRepo = presenceRepository,
        super(const TimerState());

  @override
  Future<void> close() async {
    _ticker?.cancel();
    if (!state.isIdle && state.sessionId != null) {
      await _sessionRepo.endSession(state.sessionId!, 'interrupted');
    }
    if (state.status != TimerStatus.idle) {
      await _presenceRepo.setStatus('idle');
    }
    await super.close();
  }

  // Timer Controls

  Future<void> startSession() async {
    if (!state.isIdle) return;
    emit(state.copyWith(isLoading: true));

    final sessionType =
        state.mode == SessionMode.focus ? 'focus' : 'breakTime';
    final plannedMinutes = state.mode == SessionMode.focus
        ? state.focusDuration
        : state.breakDuration;

    final result =
        await _sessionRepo.startSession(sessionType, plannedMinutes);

    if (isClosed) return;

    result.fold(
      onSuccess: (sessionId) {
        _startTicker();
        emit(state.copyWith(
          sessionId: sessionId,
          status: TimerStatus.running,
          isLoading: false,
        ));
      },
      onFailure: (error, _) => emit(state.copyWith(
        isLoading: false,
        errorMessage: error.message,
      )),
    );
  }

  Future<void> pauseSession() async {
    if (!state.isRunning || state.sessionId == null) return;
    _ticker?.cancel();
    emit(state.copyWith(status: TimerStatus.paused, isLoading: true));

    final result = await _sessionRepo.pauseSession(state.sessionId!);

    if (isClosed) return;

    result.fold(
      onSuccess: (_) => emit(state.copyWith(isLoading: false)),
      onFailure: (error, _) => emit(state.copyWith(
        isLoading: false,
        errorMessage: error.message,
      )),
    );
  }

  Future<void> resumeSession() async {
    if (!state.isPaused || state.sessionId == null) return;
    emit(state.copyWith(isLoading: true));

    final result = await _sessionRepo.resumeSession(state.sessionId!);

    if (isClosed) return;

    result.fold(
      onSuccess: (_) {
        _startTicker();
        emit(state.copyWith(
          status: TimerStatus.running,
          isLoading: false,
        ));
      },
      onFailure: (error, _) => emit(state.copyWith(
        isLoading: false,
        errorMessage: error.message,
      )),
    );
  }

  Future<void> endSession({String reason = 'interrupted'}) async {
    if (state.sessionId == null) return;
    _ticker?.cancel();
    emit(state.copyWith(isLoading: true));

    final result = await _sessionRepo.endSession(state.sessionId!, reason);

    if (isClosed) return;

    result.fold(
      onSuccess: (_) {
        _flipMode();
        emit(state.copyWith(
          sessionId: null,
          status: TimerStatus.idle,
          isLoading: false,
        ));
      },
      onFailure: (error, _) => emit(state.copyWith(
        isLoading: false,
        errorMessage: error.message,
      )),
    );
  }

  Future<void> resetSession() async {
    if (state.sessionId != null) {
      await endSession(reason: 'interrupted');
    } else {
      _resetTimer();
      emit(state.copyWith(status: TimerStatus.idle));
    }
  }

  Future<void> flipMode() async {
    if (state.sessionId != null) {
      await endSession(reason: 'interrupted');
    }
    _flipMode();
    _resetTimer();
    emit(state.copyWith(status: TimerStatus.idle));
  }

  // Settings

  void updateDurations({int? focusMinutes, int? breakMinutes}) {
    final focusSec = (focusMinutes ?? state.focusDuration) * 60;
    final breakSec = (breakMinutes ?? state.breakDuration) * 60;

    if (state.isIdle) {
      final newTotal =
          state.mode == SessionMode.focus ? focusSec : breakSec;
      emit(state.copyWith(
        totalSeconds: newTotal,
        remainingSeconds: newTotal,
        focusDuration: focusMinutes ?? state.focusDuration,
        breakDuration: breakMinutes ?? state.breakDuration,
      ));
    }
  }

  // Presence

  Future<void> setOffline() async {
    _ticker?.cancel();
    await _presenceRepo.setStatus('offline');
  }

  Future<void> setOnline() async {
    final status = state.sessionId != null
        ? (state.mode == SessionMode.focus ? 'working' : 'onBreak')
        : 'online';
    await _presenceRepo.setStatus(status);
  }

  // Private

  void _startTicker() {
    _ticker = Timer.periodic(Duration(seconds: 1), (_) => _onTick());
  }

  void _onTick() {
    final newRemaining = state.remainingSeconds - 1;
    if (newRemaining <= 0) {
      _ticker?.cancel();
      endSession(reason: 'completed');
    } else {
      emit(state.copyWith(remainingSeconds: newRemaining));
    }
  }

  void _flipMode() {
    final newMode = state.mode == SessionMode.focus
        ? SessionMode.breakTime
        : SessionMode.focus;
    emit(state.copyWith(mode: newMode));
  }

  void _resetTimer() {
    final initial = state.mode == SessionMode.focus
        ? state.focusDuration * 60
        : state.breakDuration * 60;
    emit(state.copyWith(remainingSeconds: initial, totalSeconds: initial));
  }
}
```

- [ ] **Step 2: Commit**

```bash
git add lib/features/rooms/presentation/cubit/timer_cubit.dart
git commit -m "feat(rooms): add TimerCubit with session lifecycle and ticker logic"
```

---

### Task 6: Register TimerCubit in DI

**Files:**
- Modify: `lib/core/di/register_module.dart`

- [ ] **Step 1: Update register_module to provide TimerCubit factory**

Read the current file first, then add the TimerCubit provider:

```dart
// lib/core/di/register_module.dart
import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:malaz/features/rooms/presentation/cubit/timer_cubit.dart';

@module
abstract class RegisterModule {
  @preResolve
  Future<SharedPreferences> get sharedPreferences =>
      SharedPreferences.getInstance();

  @lazySingleton
  SupabaseClient get supabaseClient => Supabase.instance.client;

  @injectable
  TimerCubit timerCubit(
    String roomId,
  ) =>
      TimerCubit(
        roomId: roomId,
        sessionRepository: getIt(),
        presenceRepository: getIt(),
      );
}
```

- [ ] **Step 2: Regenerate providers with build_runner**

```bash
cd /home/serag/Code/Mobile/Flutter/Tasks/malaz
flutter pub run build_runner build --delete-conflicting-outputs
```

Expected: Updates `providers.config.dart` with TimerCubit factory

- [ ] **Step 3: Commit**

```bash
git add lib/core/di/register_module.dart lib/core/di/providers.config.dart
git commit -m "feat(di): register TimerCubit factory with parameterized roomId"
```

---

### Task 7: Refactor RoomScreen to Use TimerCubit

**Files:**
- Modify: `lib/features/rooms/presentation/pages/room_screen.dart`

- [ ] **Step 1: Read the full RoomScreen to understand structure**

```bash
wc -l /home/serag/Code/Mobile/Flutter/Tasks/malaz/lib/features/rooms/presentation/pages/room_screen.dart
```

Expected: ~200+ lines. Read in chunks.

- [ ] **Step 2: Replace RoomScreen with TimerCubit-based version**

Full refactored RoomScreen:

```dart
// lib/features/rooms/presentation/pages/room_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:malaz/core/di/providers.dart';
import 'package:malaz/core/theme/app_colors.dart';
import 'package:malaz/core/theme/app_text_styles.dart';
import 'package:malaz/core/widgets/app_loading_button.dart';
import 'package:malaz/core/widgets/blurred_circle_decoration.dart';
import 'package:malaz/features/rooms/presentation/cubit/timer_cubit.dart';
import 'package:malaz/features/rooms/presentation/cubit/timer_state.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class RoomScreen extends StatefulWidget {
  const RoomScreen({super.key, required this.roomId});

  final String roomId;

  @override
  State<RoomScreen> createState() => _RoomScreenState();
}

class _RoomScreenState extends State<RoomScreen>
    with WidgetsBindingObserver {
  late TimerCubit _timerCubit;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _timerCubit = getIt<TimerCubit>(param1: widget.roomId);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _timerCubit.close();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.resumed:
        _timerCubit.setOnline();
        break;
      case AppLifecycleState.paused:
        _timerCubit.setOffline();
        break;
      default:
        break;
    }
  }

  void _openEdit(TimerState timerState) {
    showDialog(
      context: context,
      builder: (context) => _EditDurationsDialog(
        focusMinutes: timerState.focusDuration,
        breakMinutes: timerState.breakDuration,
        onApply: (focus, breakTime) {
          _timerCubit.updateDurations(
            focusMinutes: focus,
            breakMinutes: breakTime,
          );
          Navigator.pop(context);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<TimerCubit>(
      create: (_) => _timerCubit,
      child: Scaffold(
        appBar: AppBar(
          title: Column(
            children: [Text('ZENGARDEN', style: AppTextStyles.appBarTitle20)],
          ),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: AppColors.primaryColor),
            onPressed: () => context.pop(),
          ),
        ),
        body: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
          child: BlocBuilder<TimerCubit, TimerState>(
            builder: (context, timerState) {
              return Column(
                children: [
                  _CardShell(
                    color: timerState.mode == SessionMode.focus
                        ? AppColors.primaryColor
                        : AppColors.warningColor,
                    isEditing: false,
                    timerContent: _TimerCard(
                      mode: timerState.mode,
                      timerDisplay: timerState.timerDisplay,
                      isRunning: timerState.isRunning,
                      onStartStop: () {
                        if (timerState.isIdle) {
                          context.read<TimerCubit>().startSession();
                        } else if (timerState.isRunning) {
                          context.read<TimerCubit>().pauseSession();
                        } else if (timerState.isPaused) {
                          context.read<TimerCubit>().resumeSession();
                        }
                      },
                      onBreak: () => context.read<TimerCubit>().flipMode(),
                      onReset: () =>
                          context.read<TimerCubit>().resetSession(),
                      onEdit: () => _openEdit(timerState),
                      onEnd: timerState.isRunning
                          ? () => context
                              .read<TimerCubit>()
                              .endSession(reason: 'interrupted')
                          : null,
                      isLoading: timerState.isLoading,
                    ),
                  ),
                  if (timerState.errorMessage != null) ...[
                    SizedBox(height: 16.h),
                    Container(
                      padding: EdgeInsets.all(12.w),
                      decoration: BoxDecoration(
                        color: AppColors.warningColor.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                      child: Text(
                        timerState.errorMessage!,
                        style: AppTextStyles.bodySmall.copyWith(
                          color: AppColors.warningColor,
                        ),
                      ),
                    ),
                  ],
                ];
              });
            },
          ),
        ),
      ),
    );
  }
}

// UI Components (unchanged from original, but props updated)

class _CardShell extends StatelessWidget {
  final Color color;
  final bool isEditing;
  final Widget timerContent;

  const _CardShell({
    required this.color,
    required this.isEditing,
    required this.timerContent,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(24.r),
        border: Border.all(color: color, width: 2),
      ),
      padding: EdgeInsets.all(24.w),
      child: timerContent,
    );
  }
}

class _TimerCard extends StatelessWidget {
  final SessionMode mode;
  final String timerDisplay;
  final bool isRunning;
  final VoidCallback onStartStop;
  final VoidCallback onBreak;
  final VoidCallback onReset;
  final VoidCallback onEdit;
  final VoidCallback? onEnd;
  final bool isLoading;

  const _TimerCard({
    required this.mode,
    required this.timerDisplay,
    required this.isRunning,
    required this.onStartStop,
    required this.onBreak,
    required this.onReset,
    required this.onEdit,
    this.onEnd,
    required this.isLoading,
  });

  String get _modeTitle =>
      mode == SessionMode.focus ? 'DEEP WORK' : 'BREAK TIME';

  String get _buttonLabel => isRunning ? 'Pause Session' : 'Start Session';

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(_modeTitle, style: AppTextStyles.headline),
        SizedBox(height: 24.h),
        Text(timerDisplay, style: AppTextStyles.timerDisplay),
        SizedBox(height: 48.h),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            AppLoadingButton(
              onPressed: isLoading ? null : onStartStop,
              label: _buttonLabel,
              isLoading: isLoading,
            ),
            if (isRunning)
              OutlinedButton(
                onPressed: isLoading ? null : onEnd,
                child: const Text('End'),
              ),
          ],
        ),
        SizedBox(height: 16.h),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            OutlinedButton(
              onPressed: isLoading ? null : onBreak,
              child: Text(mode == SessionMode.focus
                  ? 'Take Break'
                  : 'End Break'),
            ),
            OutlinedButton(
              onPressed: isLoading ? null : onReset,
              child: const Text('Reset'),
            ),
            OutlinedButton(
              onPressed: isLoading ? null : onEdit,
              child: const Text('Settings'),
            ),
          ],
        ),
      ],
    );
  }
}

class _EditDurationsDialog extends StatefulWidget {
  final int focusMinutes;
  final int breakMinutes;
  final Function(int, int) onApply;

  const _EditDurationsDialog({
    required this.focusMinutes,
    required this.breakMinutes,
    required this.onApply,
  });

  @override
  State<_EditDurationsDialog> createState() => _EditDurationsDialogState();
}

class _EditDurationsDialogState extends State<_EditDurationsDialog> {
  late int _draftFocusMinutes;
  late int _draftBreakMinutes;

  @override
  void initState() {
    super.initState();
    _draftFocusMinutes = widget.focusMinutes;
    _draftBreakMinutes = widget.breakMinutes;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Edit Session Durations'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text('Focus Duration: $_draftFocusMinutes minutes'),
          Slider(
            value: _draftFocusMinutes.toDouble(),
            min: 1,
            max: 60,
            divisions: 59,
            label: '$_draftFocusMinutes min',
            onChanged: (value) =>
                setState(() => _draftFocusMinutes = value.toInt()),
          ),
          SizedBox(height: 16.h),
          Text('Break Duration: $_draftBreakMinutes minutes'),
          Slider(
            value: _draftBreakMinutes.toDouble(),
            min: 1,
            max: 30,
            divisions: 29,
            label: '$_draftBreakMinutes min',
            onChanged: (value) =>
                setState(() => _draftBreakMinutes = value.toInt()),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () =>
              widget.onApply(_draftFocusMinutes, _draftBreakMinutes),
          child: const Text('Apply'),
        ),
      ],
    );
  }
}
```

- [ ] **Step 3: Verify RoomScreen compiles**

```bash
cd /home/serag/Code/Mobile/Flutter/Tasks/malaz
flutter analyze lib/features/rooms/presentation/pages/room_screen.dart
```

Expected: No errors

- [ ] **Step 4: Commit**

```bash
git add lib/features/rooms/presentation/pages/room_screen.dart
git commit -m "refactor(rooms): migrate RoomScreen to use TimerCubit with BlocProvider"
```

---

### Task 8: Add AppTextStyles for Timer Display

**Files:**
- Modify: `lib/core/theme/app_text_styles.dart`

- [ ] **Step 1: Check existing text styles and add timerDisplay**

```bash
grep -n "headline\|bodySmall" /home/serag/Code/Mobile/Flutter/Tasks/malaz/lib/core/theme/app_text_styles.dart | head -10
```

- [ ] **Step 2: Add timerDisplay style if not present**

Read the file to understand the existing patterns, then add:

```dart
static const TextStyle timerDisplay = TextStyle(
  fontSize: 72,
  fontWeight: FontWeight.w600,
  height: 1.2,
);
```

- [ ] **Step 3: Commit**

```bash
git add lib/core/theme/app_text_styles.dart
git commit -m "style: add timerDisplay text style for large timer numbers"
```

---

### Task 9: Test Timer Flows Manually

**Files:**
- None (manual testing)

- [ ] **Step 1: Run the app on a device or emulator**

```bash
cd /home/serag/Code/Mobile/Flutter/Tasks/malaz
flutter run
```

- [ ] **Step 2: Navigate to a room and test Flow A (Start → Pause → Resume → End)**

1. Tap "Start Session" → timer should countdown
2. Tap "Pause Session" → timer should stop, button changes to "Resume"
3. Tap "Resume Session" → timer resumes counting down
4. Tap "Reset" → timer should go back to 25:00 and status idle

Verify in Supabase dashboard:
- `pomodoro_sessions` table has entries with `started_at`, `paused_at`, `ended_at` populated correctly
- `room_members` table shows status changes: `working` → `idle` → `working` → `online`

- [ ] **Step 3: Test Flow B (Timer Completes)**

1. Tap "Start Session"
2. Wait for timer to reach 0:00
3. Verify session ends automatically, mode flips to breakTime, status goes idle

Check `pomodoro_sessions` for `ended_reason='completed'`

- [ ] **Step 4: Test Flow C (Flip Mode)**

1. From focus mode, tap "Take Break"
2. Verify mode switches to breakTime, timer resets to 5:00
3. Tap "End Break"
4. Verify mode switches back to focus, timer resets to 25:00

Check `room_members.status` transitions: `online` → `online`

- [ ] **Step 5: Test app lifecycle (foreground/background)**

1. Start a session (timer running)
2. Send app to background (swipe up)
3. Open app again
4. Verify member status is `working` again
5. Stop timer (pause or let it complete)
6. Send app to background
7. Open app
8. Verify member status is `online`

- [ ] **Step 6: Verify error handling**

1. Disconnect network
2. Try to start session
3. Verify error message displays in UI
4. Reconnect network
5. Try again → should work

- [ ] **Step 7: Commit test notes (optional)**

```bash
git commit --allow-empty -m "test(timer): manual flow testing complete - all flows verified"
```

---

### Task 10: Write Unit Tests for TimerCubit

**Files:**
- Create: `test/features/rooms/presentation/cubit/timer_cubit_test.dart`

- [ ] **Step 1: Create test file with mock repositories**

```dart
// test/features/rooms/presentation/cubit/timer_cubit_test.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:malaz/core/util/errors/domain_errors.dart';
import 'package:malaz/core/util/result.dart';
import 'package:malaz/features/rooms/domain/repositories/session_repository.dart';
import 'package:malaz/features/rooms/domain/repositories/presence_repository.dart';
import 'package:malaz/features/rooms/presentation/cubit/timer_cubit.dart';
import 'package:malaz/features/rooms/presentation/cubit/timer_state.dart';

class MockSessionRepository extends Mock implements SessionRepository {}

class MockPresenceRepository extends Mock implements PresenceRepository {}

void main() {
  group('TimerCubit', () {
    late MockSessionRepository mockSessionRepository;
    late MockPresenceRepository mockPresenceRepository;
    late TimerCubit timerCubit;

    setUp(() {
      mockSessionRepository = MockSessionRepository();
      mockPresenceRepository = MockPresenceRepository();
      timerCubit = TimerCubit(
        roomId: 'test-room',
        sessionRepository: mockSessionRepository,
        presenceRepository: mockPresenceRepository,
      );
    });

    tearDown(() async {
      await timerCubit.close();
    });

    test('initial state is idle with focus mode', () {
      expect(
        timerCubit.state,
        const TimerState(
          status: TimerStatus.idle,
          mode: SessionMode.focus,
          totalSeconds: 1500,
          remainingSeconds: 1500,
        ),
      );
    });

    test('startSession calls repository and emits running state', () async {
      when(() => mockSessionRepository.startSession('focus', 25))
          .thenAnswer((_) async => const Result.success('session-123'));

      expect(
        timerCubit.stream,
        emitsInOrder([
          predicate<TimerState>(
              (state) => state.isLoading && state.isIdle), // Loading state
          predicate<TimerState>((state) =>
              state.isRunning &&
              state.sessionId == 'session-123' &&
              !state.isLoading), // Running state
        ]),
      );

      await timerCubit.startSession();
      await Future.delayed(const Duration(milliseconds: 100));
      timerCubit.close();
    });

    test('pauseSession cancels ticker and updates status', () async {
      when(() => mockSessionRepository.startSession('focus', 25))
          .thenAnswer((_) async => const Result.success('session-123'));
      when(() => mockSessionRepository.pauseSession('session-123'))
          .thenAnswer((_) async => const Result.success(null));

      await timerCubit.startSession();
      await Future.delayed(const Duration(milliseconds: 50));

      expect(
        timerCubit.stream,
        emitsInOrder([
          predicate<TimerState>(
              (state) => state.isLoading && state.isIdle), // startSession loading
          predicate<TimerState>((state) => state.isRunning), // startSession running
          predicate<TimerState>((state) =>
              state.isLoading && state.isPaused), // pauseSession loading
          predicate<TimerState>((state) => state.isPaused && !state.isLoading),
        ]),
      );

      await timerCubit.pauseSession();
      await Future.delayed(const Duration(milliseconds: 100));
    });

    test('flipMode ends active session and toggles mode', () async {
      when(() => mockSessionRepository.startSession('focus', 25))
          .thenAnswer((_) async => const Result.success('session-123'));
      when(() => mockSessionRepository.endSession('session-123', 'interrupted'))
          .thenAnswer((_) async => const Result.success(null));

      await timerCubit.startSession();
      await Future.delayed(const Duration(milliseconds: 50));

      expect(
        timerCubit.stream,
        emitsInOrder([
          predicate<TimerState>((state) => state.mode == SessionMode.focus),
          predicate<TimerState>((state) =>
              state.mode == SessionMode.breakTime &&
              state.isIdle &&
              state.remainingSeconds == 300), // 5 min
        ]),
      );

      await timerCubit.flipMode();
      await Future.delayed(const Duration(milliseconds: 100));
    });

    test('updateDurations changes totalSeconds and remainingSeconds when idle',
        () {
      expect(timerCubit.state.focusDuration, 25);

      timerCubit.updateDurations(focusMinutes: 30);

      expect(timerCubit.state.focusDuration, 30);
      expect(timerCubit.state.totalSeconds, 1800);
      expect(timerCubit.state.remainingSeconds, 1800);
    });

    test('timerDisplay formats seconds correctly', () {
      expect(timerCubit.state.timerDisplay, '25:00');

      timerCubit.updateDurations(focusMinutes: 5);
      expect(timerCubit.state.timerDisplay, '05:00');
    });
  });
}
```

- [ ] **Step 2: Run tests to verify they pass**

```bash
cd /home/serag/Code/Mobile/Flutter/Tasks/malaz
flutter test test/features/rooms/presentation/cubit/timer_cubit_test.dart -v
```

Expected: All tests pass

- [ ] **Step 3: Commit**

```bash
git add test/features/rooms/presentation/cubit/timer_cubit_test.dart
git commit -m "test(timer): add unit tests for TimerCubit lifecycle and state transitions"
```

---

### Task 11: Final Integration Check

**Files:**
- None (verification only)

- [ ] **Step 1: Run all tests**

```bash
cd /home/serag/Code/Mobile/Flutter/Tasks/malaz
flutter test
```

Expected: No failures

- [ ] **Step 2: Analyze code for issues**

```bash
cd /home/serag/Code/Mobile/Flutter/Tasks/malaz
flutter analyze
```

Expected: No errors (warnings OK)

- [ ] **Step 3: Verify app builds without errors**

```bash
cd /home/serag/Code/Mobile/Flutter/Tasks/malaz
flutter build apk --debug 2>&1 | tail -20
```

Or for iOS:

```bash
flutter build ios --debug 2>&1 | tail -20
```

Expected: Build succeeds

- [ ] **Step 4: Final commit with summary**

```bash
git log --oneline -10
```

Review all commits look correct, then:

```bash
git commit --allow-empty -m "feat(timer): complete TimerCubit implementation with Supabase integration

- Created SessionRepository and PresenceRepository interfaces
- Implemented SessionRepositoryImpl and PresenceRepositoryImpl with RPC calls
- Built TimerCubit with complete session lifecycle (start/pause/resume/end)
- Integrated with app lifecycle for presence tracking
- Refactored RoomScreen to use BlocProvider<TimerCubit>
- Added unit tests for core timer logic
- All manual flow tests verified (A, B, C, D)"
```

---

## Execution Handoff

Plan complete and saved to `docs/superpowers/plans/2026-04-22-timer-implementation.md`. Two execution options:

**1. Subagent-Driven (recommended)** - I dispatch a fresh subagent per task, review between tasks, fast iteration

**2. Inline Execution** - Execute tasks in this session using executing-plans, batch execution with checkpoints

**Which approach?**
