import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:malaz/features/rooms/domain/repositories/presence_repository.dart';
import 'package:malaz/features/rooms/domain/repositories/session_repository.dart';

import 'timer_state.dart';

@injectable
class TimerCubit extends Cubit<TimerState> {
  final String roomId;
  final SessionRepository _sessionRepository;
  final PresenceRepository _presenceRepository;

  Timer? _ticker;

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
        emit(
          state.copyWith(
            sessionId: null,
            status: TimerStatus.idle,
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
    _ticker?.cancel();

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

  /// Start the ticker that decrements the timer every second
  void _startTicker() {
    _ticker?.cancel();
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
