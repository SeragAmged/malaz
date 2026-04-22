# Timer State Management & Session Backend Integration

**Date:** 2026-04-22  
**Scope:** Pomodoro timer UI → Cubit state management with Supabase backend sync  
**Task:** Convert `RoomScreen`'s local timer state to `TimerCubit`; all actions (start/pause/resume/end) report to backend via RPC calls; manage member status lifecycle.

---

## 1. Architecture Overview

### New Components

**Domain Layer:**
- `SessionRepository` interface — defines session RPC calls
- `PresenceRepository` interface — defines member status updates

**Data Layer:**
- `SessionRepositoryImpl` — calls `start_session`, `pause_session`, `resume_session`, `end_session` RPCs
- `PresenceRepositoryImpl` — calls `set_member_status` RPC (to be created backend)
- `SessionRemoteDataSource` — thin wrapper around Supabase RPCs

**Presentation Layer:**
- `TimerCubit` — owns timer countdown logic, session state, room presence
- `TimerState` — immutable state: status (idle/running/paused), mode (focus/breakTime), remaining seconds, session ID
- `RoomScreen` — refactored to use `BlocProvider<TimerCubit>`, `AppLifecycleListener` for offline tracking

---

## 2. State Definition

### `TimerStatus`
```
idle       → no session active; timer at initial minutes
running    → countdown in progress
paused     → ticker stopped, session preserved server-side
```

### `SessionMode`
```
focus      → deep work pomodoro
breakTime  → break cooldown
```

### `TimerState`
```dart
class TimerState {
  final TimerStatus status;           // idle / running / paused
  final SessionMode mode;             // focus / breakTime
  final int totalSeconds;             // planned duration (from settings or defaults)
  final int remainingSeconds;         // counts down; 0 means completed
  final String? sessionId;            // UUID from backend; null when idle
  final bool isLoading;               // true during RPC call
  final String? errorMessage;         // last error, if any
  
  // Computed
  String get timerDisplay => _formatTime(remainingSeconds);
  bool get isIdle => status == TimerStatus.idle;
  bool get isRunning => status == TimerStatus.running;
  bool get isPaused => status == TimerStatus.paused;
}
```

---

## 3. User Flows

### Flow A: Start → Pause → Resume → End
1. **User taps "Start Session"** (status: idle)
   - UI: `_TimerCard` has button label "Start Session"
   - Cubit: calls `TimerCubit.startSession()`
   - Backend: `start_session(p_session_type='focus', p_planned_minutes=25)` → returns session UUID
   - Cubit: stores `sessionId`, starts `dart:async Timer` ticking every 1 second, emits state: status=running, remainingSeconds decrements
   - UI: button now shows "Pause Session"

2. **User taps "Pause Session"** (status: running)
   - Cubit: cancels ticker, calls `pause_session(p_session_id)`
   - Backend: updates `paused_at=now()` in `pomodoro_sessions`, sets member status to `idle`
   - Cubit: emits state: status=paused
   - UI: button now shows "Resume Session"

3. **User taps "Resume Session"** (status: paused)
   - Cubit: calls `resume_session(p_session_id)` (same session ID)
   - Backend: accumulates pause duration, clears `paused_at`, updates member status to `working`
   - Cubit: restarts ticker from current `remainingSeconds`, emits status=running
   - UI: button shows "Pause Session" again

4. **User taps "Reset"** (status: running or paused)
   - Cubit: calls `end_session(p_session_id, p_ended_reason='interrupted')`
   - Backend: records end time, sets member status to `online`
   - Cubit: clears `sessionId`, resets `remainingSeconds` to initial, emits status=idle, keeps mode=focus
   - UI: button shows "Start Session"

### Flow B: Timer Completes
1. **Timer reaches 0** (status: running)
   - Cubit: `_onTick()` detects `remainingSeconds == 0`
   - Cubit: calls `end_session(p_session_id, p_ended_reason='completed')`
   - Backend: records end time, sets member status to `online`
   - Cubit: clears `sessionId`, emits status=idle, **flips mode** to breakTime, resets `remainingSeconds` to break duration (5 min default)
   - UI: button shows "Start Session"; title switches to "BREAK TIME"; user must manually tap Start to begin break

### Flow C: Toggle Mode (Take Break / End Break)
1. **User taps "Take Break" button** (mode: focus, any status)
   - If session is active: call `end_session(p_session_id, 'interrupted')`
   - Cubit: calls `flipMode()` → toggles mode to breakTime, resets timer to break minutes, emits status=idle
   - UI: title shows "BREAK TIME", button shows "Start Session"

2. **User taps "End Break" button** (mode: breakTime, any status)
   - If session is active: call `end_session(p_session_id, 'interrupted')`
   - Cubit: calls `flipMode()` → toggles mode to focus, resets timer to focus minutes, emits status=idle
   - UI: title shows "DEEP WORK", button shows "Start Session"

### Flow D: End Button (while running)
1. **User taps "End" button** (status: running, only visible when running)
   - Cubit: calls `end_session(p_session_id, 'interrupted')`
   - Backend: records end, flips member status to `online`
   - Cubit: clears `sessionId`, **flips mode** to breakTime, resets timer, emits status=idle
   - UI: mode switches to break, button shows "Start Session"

---

## 4. Cubit Methods

```dart
class TimerCubit extends Cubit<TimerState> {
  final String roomId;
  final SessionRepository _sessionRepo;
  final PresenceRepository _presenceRepo;
  Timer? _ticker;

  // Lifecycle
  @override
  Future<void> close() async {
    _ticker?.cancel();
    if (!state.isIdle) {
      await _sessionRepo.endSession(state.sessionId!, 'interrupted');
    }
    if (state.status != TimerStatus.idle) {
      await _presenceRepo.setStatus('idle');
    }
    await super.close();
  }

  // Timer Controls
  Future<void> startSession() async {
    emit(state.copyWith(isLoading: true));
    final result = await _sessionRepo.startSession(
      sessionType: state.mode == SessionMode.focus ? 'focus' : 'breakTime',
      plannedMinutes: state.mode == SessionMode.focus 
        ? state.totalSeconds ~/ 60  // current focus duration
        : state.totalSeconds ~/ 60  // current break duration
    );
    
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
    result.fold(
      onSuccess: (_) {
        _startTicker();
        emit(state.copyWith(status: TimerStatus.running, isLoading: false));
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
      final newTotal = state.mode == SessionMode.focus ? focusSec : breakSec;
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
    await _presenceRepo.setStatus(
      state.sessionId != null
        ? (state.mode == SessionMode.focus ? 'working' : 'onBreak')
        : 'online'
    );
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

---

## 5. Repository Interfaces

### `SessionRepository`
```dart
abstract interface class SessionRepository {
  // Returns session UUID
  Future<Result<String, DomainError>> startSession(
    String sessionType,  // 'focus' or 'breakTime'
    int plannedMinutes,
  );

  Future<Result<void, DomainError>> pauseSession(String sessionId);
  Future<Result<void, DomainError>> resumeSession(String sessionId);
  
  // reason: 'completed' | 'interrupted' | 'abandoned'
  Future<Result<void, DomainError>> endSession(
    String sessionId,
    String reason,
  );
}
```

### `PresenceRepository`
```dart
abstract interface class PresenceRepository {
  // status: 'online' | 'working' | 'onBreak' | 'idle' | 'offline'
  Future<Result<void, DomainError>> setStatus(String status);
}
```

---

## 6. UI Refactoring (RoomScreen)

### Changes
- Remove local state: `_isRunning`, `_mode`, `_focusMinutes`, `_breakMinutes`, `_draftFocusMinutes`, `_draftBreakMinutes`
- Wrap body with: `BlocProvider<TimerCubit>(create: (_) => getIt<TimerCubit>(param1: roomId))`
- Add: `AppLifecycleListener` to track foreground/background

### Button Logic
```dart
String get _buttonLabel {
  if (state.isIdle) return 'Start Session';
  if (state.isRunning) return 'Pause Session';
  if (state.isPaused) return 'Resume Session';
  return 'Start Session';
}

VoidCallback get _onButtonPressed {
  if (state.isIdle) return () => context.read<TimerCubit>().startSession();
  if (state.isRunning) return () => context.read<TimerCubit>().pauseSession();
  if (state.isPaused) return () => context.read<TimerCubit>().resumeSession();
  return () {};
}
```

### End Button
- Only visible when `state.isRunning`
- Calls `context.read<TimerCubit>().endSession(reason: 'interrupted')` → flips to break

### Toggle Buttons (Take Break / End Break)
- Both call `context.read<TimerCubit>().flipMode()` → ends session if active, toggles mode, goes idle

### Reset Button
- Calls `context.read<TimerCubit>().resetSession()` → ends session if active, resets timer

### Settings (Edit Dialog)
- On "Update": `context.read<TimerCubit>().updateDurations(focusMinutes: x, breakMinutes: y)`

### Lifecycle (AppLifecycleListener)
```dart
AppLifecycleListener(
  onResume: () => context.read<TimerCubit>().setOnline(),
  onPause: () => context.read<TimerCubit>().setOffline(),
)
```

---

## 7. Backend Additions

### Required RPC: `set_member_status(p_status member_status)`
```sql
CREATE OR REPLACE FUNCTION set_member_status(p_status member_status)
RETURNS void
LANGUAGE plpgsql
SECURITY DEFINER
AS $function$
BEGIN
  UPDATE room_members
  SET status = p_status,
      last_checkin_at = now()
  WHERE user_id = auth.uid();
END;
$function$;
```

### Member Status Transitions
| Event | Status Set | By |
|-------|-----------|-----|
| User joins room | `online` | `join_room` RPC |
| Session starts (focus) | `working` | `start_session` RPC (existing) |
| Session starts (break) | `onBreak` | `start_session` RPC (existing) |
| Session paused | `idle` | `pause_session` RPC (existing) |
| Session resumed | `working`/`onBreak` | `resume_session` RPC (existing) |
| Session ended | `online` | `end_session` RPC (existing) |
| Leave screen (no session) | `idle` | `set_member_status('idle')` in `TimerCubit.close()` |
| App backgrounded | `offline` | `set_member_status('offline')` via `AppLifecycleListener` |
| App foregrounded | `online`/`working`/`onBreak` | `set_member_status(...)` via `AppLifecycleListener` |

---

## 8. Error Handling

- **RPC failures** → emit `errorMessage`, stay in current state, allow retry
- **Timer logic errors** → logged, state remains consistent
- **Presence failures** → logged but don't block session operations

---

## 9. Testing Strategy

- **Unit:** `TimerCubit` with mock `SessionRepository`, `PresenceRepository`
- **Integration:** real Supabase calls with test room + user
- **Widget:** `RoomScreen` with `MockBloc<TimerCubit>`
