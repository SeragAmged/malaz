import 'package:freezed_annotation/freezed_annotation.dart';

part 'timer_state.freezed.dart';

enum TimerStatus { idle, running, paused }

enum SessionMode { focus, breakTime }

@freezed
abstract class TimerState with _$TimerState {
  const TimerState._();

  const factory TimerState({
    @Default(TimerStatus.idle) TimerStatus status,
    @Default(SessionMode.focus) SessionMode mode,
    @Default(1500) int totalSeconds,
    @Default(1500) int remainingSeconds,
    String? sessionId,
    @Default(false) bool isLoading,
    String? errorMessage,
    @Default(25) int focusDuration,
    @Default(5) int breakDuration,
    DateTime? sessionStartedAt,
  }) = _TimerState;

  // Computed getters
  bool get isIdle => status == TimerStatus.idle;
  bool get isRunning => status == TimerStatus.running;
  bool get isPaused => status == TimerStatus.paused;

  String get timerDisplay {
    final minutes = (remainingSeconds ~/ 60).toString().padLeft(2, '0');
    final seconds = (remainingSeconds % 60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }
}
