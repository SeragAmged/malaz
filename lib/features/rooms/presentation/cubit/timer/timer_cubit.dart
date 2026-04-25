import 'dart:async';

import 'package:debouncing/debouncing.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:malaz/features/rooms/domain/entities/enums.dart';
import 'package:malaz/features/rooms/domain/entities/room_member_with_session.dart';
import 'package:malaz/features/rooms/domain/repositories/presence_repository.dart';
import 'package:malaz/features/rooms/domain/repositories/session_repository.dart';

import 'timer_state.dart';

class TimerCubit extends Cubit<TimerState> {
  TimerCubit({
    required this.roomId,
    required SessionRepository sessionRepository,
    required PresenceRepository presenceRepository,
  }) : _sessionRepository = sessionRepository,
       _presenceRepository = presenceRepository,
       super(const TimerState());

  final String roomId;
  final SessionRepository _sessionRepository;
  final PresenceRepository _presenceRepository;

  Timer? _ticker;
  DateTime? _backgroundedAt;

  @override
  Future<void> close() async {
    _ticker?.cancel();
    // if (state.sessionId != null) {
    //   await _sessionRepository.endSession(state.sessionId!, 'interrupted');
    // }
    return super.close();
  }

  Future<void> startSession() async {
    if (!state.isIdle) return;

    emit(state.copyWith(isLoading: true));

    final sessionType = state.mode.name;
    final plannedMinutes = state.isFocusMode
        ? state.focusDuration
        : state.breakDuration;

    final result = await _sessionRepository.startSession(
      sessionType,
      plannedMinutes,
    );

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

  Future<void> pauseSession() async {
    if (!state.isRunning || state.sessionId == null) return;

    emit(state.copyWith(isLoading: true));

    final result = await _sessionRepository.pauseSession(state.sessionId!);
    _ticker?.cancel();

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

  Future<void> endSession({
    SessionEndReason reason = SessionEndReason.interrupted,
    bool reset = false,
  }) async {
    if (state.sessionId == null) return;

    emit(state.copyWith(isLoading: true));

    final result = await _sessionRepository.endSession(
      state.sessionId!,
      reason,
    );
    _ticker?.cancel();

    if (isClosed) return;

    result.fold(
      onSuccess: (_) {
        if (!reset) _flipMode();
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

  void resetSession() {
    _ticker?.cancel();
    if (state.sessionId != null) {
      endSession(reason: SessionEndReason.interrupted, reset: true);
    } else {
      emit(state.copyWith(status: TimerStatus.idle));
    }
    _resetTimer();
  }

  Future<void> flipMode() async {
    if (state.sessionId != null) {
      await endSession(reason: SessionEndReason.interrupted);
    } else {
      _flipMode();
      _resetTimer();
      emit(state.copyWith(status: TimerStatus.idle));
    }
  }

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

  Future<void> setOffline() async {
    if (state.isRunning) _backgroundedAt = DateTime.now();

    if (!state.isRunning) {
      final result = await _presenceRepository.setStatus(UserStatus.offline);
      if (isClosed) return;
      result.fold(
        onSuccess: (_) {},
        onFailure: (error, _) {
          emit(
            state.copyWith(
              errorMessage: error.message ?? 'Failed to set offline status',
            ),
          );
        },
      );
    }
  }

  Future<void> setOnline() async {
    if (_backgroundedAt != null && state.isRunning) {
      final elapsed = DateTime.now().difference(_backgroundedAt!).inSeconds;
      _backgroundedAt = null;

      final newRemaining = state.remainingSeconds - elapsed;

      // Session expired while app was backgrounded
      if (newRemaining <= 0) {
        _ticker?.cancel();
        endSession(reason: SessionEndReason.completed);
        return;
      }

      emit(state.copyWith(remainingSeconds: newRemaining));
      _startTicker();
    } else {
      _backgroundedAt = null;
    }

    //update User Statues
    final status = state.isRunning
        ? state.isFocusMode
              ? UserStatus.working
              : UserStatus.onBreak
        : UserStatus.online;
    final result = await _presenceRepository.setStatus(status);

    if (isClosed) return;

    result.fold(
      onSuccess: (_) {},
      onFailure: (error, _) {
        emit(
          state.copyWith(
            errorMessage: error.message ?? 'Failed to set online status',
          ),
        );
      },
    );
  }

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

        emit(state.copyWith(sessionId: session.sessionId, isLoading: false));

        final plannedSeconds = session.plannedMinutes * 60;
        final int remaining;

        if (session.isPaused && session.pausedAt != null) {
          final totalElapsed = session.pausedAt!
              .difference(session.startedAt)
              .inSeconds;
          final activeElapsed = totalElapsed - session.totalPausedSeconds;
          remaining = (plannedSeconds - activeElapsed).clamp(0, plannedSeconds);
        } else {
          final totalElapsed = DateTime.now()
              .difference(session.startedAt)
              .inSeconds;
          final activeElapsed = totalElapsed - session.totalPausedSeconds;
          remaining = (plannedSeconds - activeElapsed).clamp(0, plannedSeconds);
        }

        if (remaining <= 0) {
          endSession(reason: SessionEndReason.completed);
          return;
        }

        final mode = session.sessionType;

        emit(
          state.copyWith(
            status: !session.isPaused
                ? TimerStatus.running
                : TimerStatus.paused,
            mode: mode,
            totalSeconds: plannedSeconds,
            remainingSeconds: remaining,
            sessionStartedAt: session.startedAt,
            errorMessage: null,
          ),
        );

        if (!session.isPaused) {
          _startTicker();
        }
      },
      onFailure: (_, _) => emit(state.copyWith(isLoading: false)),
    );
  }

  void _startTicker() {
    _ticker?.cancel();
    if (state.sessionStartedAt == null) {
      emit(state.copyWith(sessionStartedAt: DateTime.now()));
    }
    _ticker = Timer.periodic(const Duration(seconds: 1), (_) {
      _onTick();
    });
  }

  void _onTick() {
    final newRemainingSeconds = state.remainingSeconds - 1;

    if (newRemainingSeconds <= 0) {
      _ticker?.cancel();
      endSession(reason: SessionEndReason.completed);
    } else {
      emit(state.copyWith(remainingSeconds: newRemainingSeconds));
    }
  }

  void _flipMode() {
    final newMode = state.isFocusMode
        ? SessionType.breakTime
        : SessionType.focus;
    emit(state.copyWith(mode: newMode));
    _resetTimer();
  }

  void _resetTimer() {
    final durationMinutes = state.mode == SessionType.focus
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
