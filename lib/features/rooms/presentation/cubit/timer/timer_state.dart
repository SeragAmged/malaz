import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:malaz/features/rooms/domain/entities/enums.dart';

part 'timer_state.freezed.dart';

enum TimerStatus { idle, running, paused }

// enum SessionMode { focus, breakTime }

@freezed
abstract class TimerState with _$TimerState {
  const TimerState._();

  const factory TimerState({
    String? sessionId,
    String? errorMessage,
    @Default(false) bool isLoading,
    @Default(TimerStatus.idle) TimerStatus status,
    @Default(SessionType.focus) SessionType mode,
    @Default(1500) int totalSeconds,
    @Default(1500) int remainingSeconds,
    @Default(25) int focusDuration,
    @Default(5) int breakDuration,
    DateTime? sessionStartedAt,
  }) = _TimerState;

  bool get isIdle => status == TimerStatus.idle;
  bool get isRunning => status == TimerStatus.running;
  bool get isPaused => status == TimerStatus.paused;
  bool get isFocusMode => mode == SessionType.focus;

  String get timerDisplay {
    final minutes = (remainingSeconds ~/ 60).toString().padLeft(2, '0');
    final seconds = (remainingSeconds % 60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }
}
