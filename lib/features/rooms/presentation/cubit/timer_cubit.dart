import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:malaz/features/rooms/domain/repositories/presence_repository.dart';
import 'package:malaz/features/rooms/domain/repositories/session_repository.dart';

import 'timer_state.dart';

class TimerCubit extends Cubit<TimerState> {
  final String roomId;
  final SessionRepository _sessionRepository;
  final PresenceRepository _presenceRepository;

  Timer? _ticker;
  DateTime? _backgroundedAt; // wall-clock time when app went to background

  TimerCubit({
    required this.roomId,
    required SessionRepository sessionRepository,
    required PresenceRepository presenceRepository,
  })  : _sessionRepository = sessionRepository,
        _presenceRepository = presenceRepository,
        super(const TimerState());

  @override
  Future<void> close() async {
    _ticker?.cancel();
    if (state.sessionId != null) {
      await _sessionRepository.endSession(state.sessionId!, 'interrupted');
    }
    return super.close();
  }

  /// Start a new session
  Future<void> startSession() async {
    if (!state.isIdle) return;

    emit(state.copyWith(isLoading: true));

    final sessionType = state.mode == SessionMode.focus ? 'focus' : 'breakTime';
    final plannedMinutes = state.mode == SessionMode.focus
        ? state.focusDuration
        : state.breakDuration;

    final result =
        await _sessionRepository.startSession(sessionType, plannedMinutes);

    if (isClosed) return;

    result.fold(
      onSuccess: (sessionId) {
        emit(
          state.copyWith(
            sessionId: sessionId,
            status: TimerStatus.running,
            sessionStartedAt: null,
            isLoading: false,
            errorMessage: null,
          ),
        );
        _startTicker();
      },
      onFailure: (error, _) {
        emit(
          state.copyWith(
            isLoading: false,
            errorMessage: error.message ?? 'Failed to start session',
          ),
        );
      },
    );
  }

  /// Pause the ongoing session
  Future<void> pauseSession() async {
    if (!state.isRunning || state.sessionId == null) return;

    _ticker?.cancel();
    emit(state.copyWith(isLoading: true));

    final result = await _sessionRepository.pauseSession(state.sessionId!);

    if (isClosed) return;

    result.fold(
      onSuccess: (_) {
        emit(
          state.copyWith(
            status: TimerStatus.paused,
            isLoading: false,
            errorMessage: null,
          ),
        );
      },
      onFailure: (error, _) {
        emit(
          state.copyWith(
            isLoading: false,
            errorMessage: error.message ?? 'Failed to pause session',
          ),
        );
      },
    );
  }

  /// Resume a paused session
  Future<void> resumeSession() async {
    if (!state.isPaused || state.sessionId == null) return;

    emit(state.copyWith(isLoading: true));

    final result = await _sessionRepository.resumeSession(state.sessionId!);

    if (isClosed) return;

    result.fold(
      onSuccess: (_) {
        emit(
          state.copyWith(
            status: TimerStatus.running,
            isLoading: false,
            errorMessage: null,
          ),
        );
        _startTicker();
      },
      onFailure: (error, _) {
        emit(
          state.copyWith(
            isLoading: false,
            errorMessage: error.message ?? 'Failed to resume session',
          ),
        );
      },
    );
  }

  /// End the current session
  Future<void> endSession({String reason = 'interrupted'}) async {
    if (state.sessionId == null) return;

    _ticker?.cancel();
    emit(state.copyWith(isLoading: true));

    final result = await _sessionRepository.endSession(state.sessionId!, reason);

    if (isClosed) return;

    result.fold(
      onSuccess: (_) {
        _flipMode();
        _backgroundedAt = null;
        emit(
          state.copyWith(
            sessionId: null,
            status: TimerStatus.idle,
            sessionStartedAt: null,
            isLoading: false,
            errorMessage: null,
          ),
        );
      },
      onFailure: (error, _) {
        emit(
          state.copyWith(
            isLoading: false,
            errorMessage: error.message ?? 'Failed to end session',
          ),
        );
      },
    );
  }

  /// Reset the timer to idle state
  void resetSession() {
    _ticker?.cancel();
    if (state.sessionId != null) {
      endSession(reason: 'reset');
    } else {
      _resetTimer();
      emit(state.copyWith(status: TimerStatus.idle));
    }
  }

  /// Toggle between focus and break modes
  Future<void> flipMode() async {
    if (state.sessionId != null) {
      await endSession(reason: 'interrupted');
    } else {
      _flipMode();
      _resetTimer();
      emit(state.copyWith(status: TimerStatus.idle));
    }
  }

  /// Update the durations for focus and break sessions
  void updateDurations({int? focusMinutes, int? breakMinutes}) {
    if (!state.isIdle) return;

    final newFocusDuration = focusMinutes ?? state.focusDuration;
    final newBreakDuration = breakMinutes ?? state.breakDuration;

    emit(
      state.copyWith(
        focusDuration: newFocusDuration,
        breakDuration: newBreakDuration,
      ),
    );

    _resetTimer();
  }

  /// Set user as offline
  Future<void> setOffline() async {
    if (state.isRunning) _backgroundedAt = DateTime.now();
    // do NOT cancel ticker - it may be paused by OS but we reconcile on resume

    final result = await _presenceRepository.setStatus('offline');

    if (isClosed) return;

    result.fold(
      onSuccess: (_) {
        // Status updated successfully
      },
      onFailure: (error, _) {
        emit(
          state.copyWith(
            errorMessage: error.message ?? 'Failed to set offline status',
          ),
        );
      },
    );
  }

  /// Set user as online
  Future<void> setOnline() async {
    // Reconcile timer if we were running when we went to background
    if (_backgroundedAt != null && state.isRunning) {
      final elapsed = DateTime.now().difference(_backgroundedAt!).inSeconds;
      _backgroundedAt = null;

      final newRemaining = state.remainingSeconds - elapsed;

      if (newRemaining <= 0) {
        // Session expired while app was backgrounded
        _ticker?.cancel();
        endSession(reason: 'completed');
        return;
      }

      // Update remaining and restart ticker to re-sync 1s interval
      emit(state.copyWith(remainingSeconds: newRemaining));
      _startTicker();
    } else {
      _backgroundedAt = null;
    }

    final status = state.isRunning ? 'working' : 'online';
    final result = await _presenceRepository.setStatus(status);

    if (isClosed) return;

    result.fold(
      onSuccess: (_) {
        // Status updated successfully
      },
      onFailure: (error, _) {
        emit(
          state.copyWith(
            errorMessage: error.message ?? 'Failed to set online status',
          ),
        );
      },
    );
  }

  /// Attempt to recover an active session from the server
  Future<void> tryRecoverSession() async {
    emit(state.copyWith(isLoading: true));

    final result = await _sessionRepository.getActiveSession();

    if (isClosed) return;

    result.fold(
      onSuccess: (session) {
        if (session == null) {
          emit(state.copyWith(isLoading: false));
          return;
        }

        // Set sessionId first so endSession can call RPC if expired
        emit(state.copyWith(sessionId: session.sessionId, isLoading: false));

        final plannedSeconds = session.plannedMinutes * 60;
        final int remaining;

        if (session.status == 'paused' && session.pausedAt != null) {
          // elapsed active time = (paused_at - started_at) - total_paused_seconds_before
          // total_paused_seconds already includes all previous pauses but NOT the current one
          final totalElapsed =
              session.pausedAt!.difference(session.startedAt).inSeconds;
          final activeElapsed = totalElapsed - session.totalPausedSeconds;
          remaining = (plannedSeconds - activeElapsed).clamp(0, plannedSeconds);
        } else {
          // elapsed active time = (now - started_at) - total_paused_seconds
          final totalElapsed =
              DateTime.now().difference(session.startedAt).inSeconds;
          final activeElapsed = totalElapsed - session.totalPausedSeconds;
          remaining = (plannedSeconds - activeElapsed).clamp(0, plannedSeconds);
        }

        if (remaining <= 0) {
          endSession(reason: 'completed');
          return;
        }

        final mode = session.sessionType == 'focus'
            ? SessionMode.focus
            : SessionMode.breakTime;

        emit(state.copyWith(
          status: session.status == 'running'
              ? TimerStatus.running
              : TimerStatus.paused,
          mode: mode,
          totalSeconds: plannedSeconds,
          remainingSeconds: remaining,
          sessionStartedAt: session.startedAt,
          errorMessage: null,
        ));

        if (session.status == 'running') {
          _startTicker();
        }
      },
      onFailure: (_, _) =>
          emit(state.copyWith(isLoading: false)), // silently fail
    );
  }

  /// Start the ticker that decrements the timer every second
  void _startTicker() {
    _ticker?.cancel();
    // Record the wall-clock start time if not already set
    // (preserves it on resume so elapsed math stays correct)
    if (state.sessionStartedAt == null) {
      emit(state.copyWith(sessionStartedAt: DateTime.now()));
    }
    _ticker = Timer.periodic(const Duration(seconds: 1), (_) {
      _onTick();
    });
  }

  /// Handle each tick of the timer
  void _onTick() {
    final newRemainingSeconds = state.remainingSeconds - 1;

    if (newRemainingSeconds <= 0) {
      _ticker?.cancel();
      endSession(reason: 'completed');
    } else {
      emit(state.copyWith(remainingSeconds: newRemainingSeconds));
    }
  }

  /// Toggle the session mode between focus and break
  void _flipMode() {
    final newMode =
        state.mode == SessionMode.focus ? SessionMode.breakTime : SessionMode.focus;
    emit(state.copyWith(mode: newMode));
    _resetTimer();
  }

  /// Reset the timer to the initial duration based on current mode
  void _resetTimer() {
    final durationMinutes = state.mode == SessionMode.focus
        ? state.focusDuration
        : state.breakDuration;
    final durationSeconds = durationMinutes * 60;

    emit(
      state.copyWith(
        totalSeconds: durationSeconds,
        remainingSeconds: durationSeconds,
      ),
    );
  }
}
