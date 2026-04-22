import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:malaz/core/util/errors/domain_errors.dart';
import 'package:malaz/core/util/result.dart';
import 'package:malaz/features/rooms/domain/repositories/presence_repository.dart';
import 'package:malaz/features/rooms/domain/repositories/session_repository.dart';
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

      // Setup default mock return values to avoid null issues
      when(() => mockSessionRepository.endSession(any(), any()))
          .thenAnswer((_) async => const Success(null));

      timerCubit = TimerCubit(
        roomId: 'test-room-id',
        sessionRepository: mockSessionRepository,
        presenceRepository: mockPresenceRepository,
      );
    });

    tearDown(() async {
      await timerCubit.close();
    });

    group('Initialization', () {
      test('initial state is idle with focus mode, 25 min, no session', () {
        expect(timerCubit.state.status, TimerStatus.idle);
        expect(timerCubit.state.mode, SessionMode.focus);
        expect(timerCubit.state.focusDuration, 25);
        expect(timerCubit.state.breakDuration, 5);
        expect(timerCubit.state.sessionId, isNull);
        expect(timerCubit.state.totalSeconds, 1500); // 25 minutes
        expect(timerCubit.state.remainingSeconds, 1500);
        expect(timerCubit.state.isLoading, false);
        expect(timerCubit.state.errorMessage, isNull);
      });
    });

    group('startSession()', () {
      test('emits loading state then running state on success', () async {
        // Arrange
        when(() => mockSessionRepository.startSession('focus', 25))
            .thenAnswer((_) async => const Success('session-123'));

        // Act
        unawaited(timerCubit.startSession());
        await Future.delayed(const Duration(milliseconds: 100));

        // Assert
        expect(timerCubit.state.status, TimerStatus.running);
        expect(timerCubit.state.isLoading, false);
      });

      test('sets sessionId from repository response', () async {
        // Arrange
        const testSessionId = 'session-test-123';
        when(() => mockSessionRepository.startSession('focus', 25))
            .thenAnswer((_) async => const Success(testSessionId));

        // Act
        await timerCubit.startSession();

        // Assert
        expect(timerCubit.state.sessionId, testSessionId);
      });

      test('calls repository startSession with correct parameters', () async {
        // Arrange
        when(() => mockSessionRepository.startSession('focus', 25))
            .thenAnswer((_) async => const Success('session-123'));

        // Act
        await timerCubit.startSession();

        // Assert
        verify(() => mockSessionRepository.startSession('focus', 25))
            .called(1);
      });

      test('sets error message on failure', () async {
        // Arrange
        const errorMessage = 'Failed to start session';
        when(() => mockSessionRepository.startSession('focus', 25))
            .thenAnswer((_) async => Failure(
              NetworkError(message: errorMessage),
            ));

        // Act
        await timerCubit.startSession();

        // Assert
        expect(timerCubit.state.errorMessage, errorMessage);
        expect(timerCubit.state.status, TimerStatus.idle);
      });

      test('does not start session if not idle', () async {
        // Arrange: Set cubit to running state
        when(() => mockSessionRepository.startSession('focus', 25))
            .thenAnswer((_) async => const Success('session-123'));
        await timerCubit.startSession();

        // Act: Try to start again (should be ignored)
        await timerCubit.startSession();

        // Assert
        verify(() => mockSessionRepository.startSession('focus', 25))
            .called(1); // Only called once
      });
    });

    group('pauseSession()', () {
      test('cancels ticker and emits paused state', () async {
        // Arrange
        when(() => mockSessionRepository.startSession('focus', 25))
            .thenAnswer((_) async => const Success('session-123'));
        when(() => mockSessionRepository.pauseSession('session-123'))
            .thenAnswer((_) async => const Success(null));

        // Act
        await timerCubit.startSession();
        await timerCubit.pauseSession();

        // Assert
        expect(timerCubit.state.status, TimerStatus.paused);
        expect(timerCubit.state.isLoading, false);
      });

      test('calls repository pauseSession with sessionId', () async {
        // Arrange
        when(() => mockSessionRepository.startSession('focus', 25))
            .thenAnswer((_) async => const Success('session-123'));
        when(() => mockSessionRepository.pauseSession('session-123'))
            .thenAnswer((_) async => const Success(null));

        // Act
        await timerCubit.startSession();
        await timerCubit.pauseSession();

        // Assert
        verify(() => mockSessionRepository.pauseSession('session-123'))
            .called(1);
      });

      test('sets error message on failure', () async {
        // Arrange
        const errorMessage = 'Failed to pause session';
        when(() => mockSessionRepository.startSession('focus', 25))
            .thenAnswer((_) async => const Success('session-123'));
        when(() => mockSessionRepository.pauseSession('session-123'))
            .thenAnswer((_) async => Failure(
              NetworkError(message: errorMessage),
            ));

        // Act
        await timerCubit.startSession();
        await timerCubit.pauseSession();

        // Assert
        expect(timerCubit.state.errorMessage, errorMessage);
        expect(timerCubit.state.status, TimerStatus.running);
      });

      test('does not pause if not running', () async {
        // Act: Try to pause while idle (should be ignored)
        await timerCubit.pauseSession();

        // Assert
        expect(timerCubit.state.status, TimerStatus.idle);
        verifyNever(() => mockSessionRepository.pauseSession(any()));
      });
    });

    group('resumeSession()', () {
      test('emits running state on resume', () async {
        // Arrange
        when(() => mockSessionRepository.startSession('focus', 25))
            .thenAnswer((_) async => const Success('session-123'));
        when(() => mockSessionRepository.pauseSession('session-123'))
            .thenAnswer((_) async => const Success(null));
        when(() => mockSessionRepository.resumeSession('session-123'))
            .thenAnswer((_) async => const Success(null));

        // Act
        await timerCubit.startSession();
        await timerCubit.pauseSession();
        await timerCubit.resumeSession();

        // Assert
        expect(timerCubit.state.status, TimerStatus.running);
        expect(timerCubit.state.isLoading, false);
      });

      test('calls repository resumeSession with sessionId', () async {
        // Arrange
        when(() => mockSessionRepository.startSession('focus', 25))
            .thenAnswer((_) async => const Success('session-123'));
        when(() => mockSessionRepository.pauseSession('session-123'))
            .thenAnswer((_) async => const Success(null));
        when(() => mockSessionRepository.resumeSession('session-123'))
            .thenAnswer((_) async => const Success(null));

        // Act
        await timerCubit.startSession();
        await timerCubit.pauseSession();
        await timerCubit.resumeSession();

        // Assert
        verify(() => mockSessionRepository.resumeSession('session-123'))
            .called(1);
      });

      test('sets error message on failure', () async {
        // Arrange
        const errorMessage = 'Failed to resume session';
        when(() => mockSessionRepository.startSession('focus', 25))
            .thenAnswer((_) async => const Success('session-123'));
        when(() => mockSessionRepository.pauseSession('session-123'))
            .thenAnswer((_) async => const Success(null));
        when(() => mockSessionRepository.resumeSession('session-123'))
            .thenAnswer((_) async => Failure(
              NetworkError(message: errorMessage),
            ));

        // Act
        await timerCubit.startSession();
        await timerCubit.pauseSession();
        await timerCubit.resumeSession();

        // Assert
        expect(timerCubit.state.errorMessage, errorMessage);
        expect(timerCubit.state.status, TimerStatus.paused);
      });

      test('does not resume if not paused', () async {
        // Act: Try to resume while idle (should be ignored)
        await timerCubit.resumeSession();

        // Assert
        expect(timerCubit.state.status, TimerStatus.idle);
        verifyNever(() => mockSessionRepository.resumeSession(any()));
      });
    });

    group('flipMode()', () {
      test('toggles mode from focus to breakTime when idle', () async {
        // Arrange
        expect(timerCubit.state.mode, SessionMode.focus);

        // Act
        await timerCubit.flipMode();

        // Assert
        expect(timerCubit.state.mode, SessionMode.breakTime);
      });

      test('toggles mode from breakTime to focus when idle', () async {
        // Arrange
        await timerCubit.flipMode();
        expect(timerCubit.state.mode, SessionMode.breakTime);

        // Act
        await timerCubit.flipMode();

        // Assert
        expect(timerCubit.state.mode, SessionMode.focus);
      });

      test('resets timer to 5:00 for break mode', () async {
        // Arrange
        await timerCubit.flipMode(); // Switch to breakTime

        // Assert
        expect(timerCubit.state.mode, SessionMode.breakTime);
        expect(timerCubit.state.totalSeconds, 300); // 5 minutes
        expect(timerCubit.state.remainingSeconds, 300);
      });

      test('resets timer to 25:00 for focus mode', () async {
        // Arrange
        await timerCubit.flipMode(); // Switch to breakTime
        await timerCubit.flipMode(); // Switch back to focus

        // Assert
        expect(timerCubit.state.mode, SessionMode.focus);
        expect(timerCubit.state.totalSeconds, 1500); // 25 minutes
        expect(timerCubit.state.remainingSeconds, 1500);
      });

      test('ends active session if running', () async {
        // Arrange
        when(() => mockSessionRepository.startSession('focus', 25))
            .thenAnswer((_) async => const Success('session-123'));
        when(() => mockSessionRepository.endSession('session-123', 'interrupted'))
            .thenAnswer((_) async => const Success(null));

        await timerCubit.startSession();
        expect(timerCubit.state.status, TimerStatus.running);

        // Act
        await timerCubit.flipMode();

        // Assert
        verify(() => mockSessionRepository.endSession('session-123', 'interrupted'))
            .called(1);
        expect(timerCubit.state.status, TimerStatus.idle);
        expect(timerCubit.state.sessionId, isNull);
      });
    });

    group('updateDurations()', () {
      test('updates focusDuration when idle', () async {
        // Act
        timerCubit.updateDurations(focusMinutes: 30);

        // Assert
        expect(timerCubit.state.focusDuration, 30);
        expect(timerCubit.state.totalSeconds, 1800); // 30 minutes
        expect(timerCubit.state.remainingSeconds, 1800);
      });

      test('updates breakDuration when idle', () async {
        // Act
        timerCubit.updateDurations(breakMinutes: 10);

        // Assert
        expect(timerCubit.state.breakDuration, 10);
      });

      test('updates both durations when idle', () async {
        // Act
        timerCubit.updateDurations(focusMinutes: 30, breakMinutes: 10);

        // Assert
        expect(timerCubit.state.focusDuration, 30);
        expect(timerCubit.state.breakDuration, 10);
        expect(timerCubit.state.totalSeconds, 1800); // 30 minutes (focus mode)
        expect(timerCubit.state.remainingSeconds, 1800);
      });

      test('does not update durations if running', () async {
        // Arrange
        when(() => mockSessionRepository.startSession('focus', 25))
            .thenAnswer((_) async => const Success('session-123'));
        await timerCubit.startSession();

        // Act
        timerCubit.updateDurations(focusMinutes: 30);

        // Assert
        expect(timerCubit.state.focusDuration, 25); // Unchanged
      });

      test('does not update durations if paused', () async {
        // Arrange
        when(() => mockSessionRepository.startSession('focus', 25))
            .thenAnswer((_) async => const Success('session-123'));
        when(() => mockSessionRepository.pauseSession('session-123'))
            .thenAnswer((_) async => const Success(null));
        await timerCubit.startSession();
        await timerCubit.pauseSession();

        // Act
        timerCubit.updateDurations(focusMinutes: 30);

        // Assert
        expect(timerCubit.state.focusDuration, 25); // Unchanged
      });
    });

    group('timerDisplay computed getter', () {
      test('formats 1500 seconds (25 min) as "25:00"', () {
        // Assert
        expect(timerCubit.state.timerDisplay, '25:00');
      });

      test('formats 0 seconds as "00:00"', () {
        // Act
        timerCubit.emit(timerCubit.state.copyWith(remainingSeconds: 0));

        // Assert
        expect(timerCubit.state.timerDisplay, '00:00');
      });

      test('formats 125 seconds as "02:05"', () {
        // Act
        timerCubit.emit(timerCubit.state.copyWith(remainingSeconds: 125));

        // Assert
        expect(timerCubit.state.timerDisplay, '02:05');
      });

      test('formats 3661 seconds as "61:01"', () {
        // Act
        timerCubit.emit(timerCubit.state.copyWith(remainingSeconds: 3661));

        // Assert
        expect(timerCubit.state.timerDisplay, '61:01');
      });

      test('formats 59 seconds as "00:59"', () {
        // Act
        timerCubit.emit(timerCubit.state.copyWith(remainingSeconds: 59));

        // Assert
        expect(timerCubit.state.timerDisplay, '00:59');
      });

      test('formats 60 seconds as "01:00"', () {
        // Act
        timerCubit.emit(timerCubit.state.copyWith(remainingSeconds: 60));

        // Assert
        expect(timerCubit.state.timerDisplay, '01:00');
      });
    });

    group('setOffline()', () {
      test('calls presence repository setStatus with offline', () async {
        // Arrange
        when(() => mockPresenceRepository.setStatus('offline'))
            .thenAnswer((_) async => const Success(null));

        // Act
        await timerCubit.setOffline();

        // Assert
        verify(() => mockPresenceRepository.setStatus('offline')).called(1);
      });

      test('sets error message on failure', () async {
        // Arrange
        const errorMessage = 'Failed to set offline status';
        when(() => mockPresenceRepository.setStatus('offline'))
            .thenAnswer((_) async => Failure(
              NetworkError(message: errorMessage),
            ));

        // Act
        await timerCubit.setOffline();

        // Assert
        expect(timerCubit.state.errorMessage, errorMessage);
      });
    });

    group('setOnline()', () {
      test('calls presence repository setStatus with online when idle', () async {
        // Arrange
        when(() => mockPresenceRepository.setStatus('online'))
            .thenAnswer((_) async => const Success(null));

        // Act
        await timerCubit.setOnline();

        // Assert
        verify(() => mockPresenceRepository.setStatus('online')).called(1);
      });

      test('calls presence repository setStatus with working when running', () async {
        // Arrange
        when(() => mockSessionRepository.startSession('focus', 25))
            .thenAnswer((_) async => const Success('session-123'));
        when(() => mockPresenceRepository.setStatus('working'))
            .thenAnswer((_) async => const Success(null));

        await timerCubit.startSession();

        // Act
        await timerCubit.setOnline();

        // Assert
        verify(() => mockPresenceRepository.setStatus('working')).called(1);
      });

      test('sets error message on failure', () async {
        // Arrange
        const errorMessage = 'Failed to set online status';
        when(() => mockPresenceRepository.setStatus('online'))
            .thenAnswer((_) async => Failure(
              NetworkError(message: errorMessage),
            ));

        // Act
        await timerCubit.setOnline();

        // Assert
        expect(timerCubit.state.errorMessage, errorMessage);
      });
    });

    group('endSession()', () {
      test('emits idle state and clears sessionId on success', () async {
        // Arrange
        when(() => mockSessionRepository.startSession('focus', 25))
            .thenAnswer((_) async => const Success('session-123'));
        when(() => mockSessionRepository.endSession('session-123', 'completed'))
            .thenAnswer((_) async => const Success(null));

        await timerCubit.startSession();
        expect(timerCubit.state.sessionId, 'session-123');

        // Act
        await timerCubit.endSession(reason: 'completed');

        // Assert
        expect(timerCubit.state.status, TimerStatus.idle);
        expect(timerCubit.state.sessionId, isNull);
        expect(timerCubit.state.isLoading, false);
      });

      test('calls repository endSession with correct reason', () async {
        // Arrange
        when(() => mockSessionRepository.startSession('focus', 25))
            .thenAnswer((_) async => const Success('session-123'));
        when(() => mockSessionRepository.endSession('session-123', 'interrupted'))
            .thenAnswer((_) async => const Success(null));

        await timerCubit.startSession();

        // Act
        await timerCubit.endSession(reason: 'interrupted');

        // Assert
        verify(() => mockSessionRepository.endSession('session-123', 'interrupted'))
            .called(1);
      });

      test('toggles mode to breakTime after focus session', () async {
        // Arrange
        when(() => mockSessionRepository.startSession('focus', 25))
            .thenAnswer((_) async => const Success('session-123'));
        when(() => mockSessionRepository.endSession('session-123', 'completed'))
            .thenAnswer((_) async => const Success(null));

        expect(timerCubit.state.mode, SessionMode.focus);
        await timerCubit.startSession();

        // Act
        await timerCubit.endSession(reason: 'completed');

        // Assert
        expect(timerCubit.state.mode, SessionMode.breakTime);
      });

      test('does nothing if sessionId is null', () async {
        // Act
        await timerCubit.endSession(reason: 'completed');

        // Assert
        verifyNever(() => mockSessionRepository.endSession(any(), any()));
        expect(timerCubit.state.status, TimerStatus.idle);
      });
    });

    group('resetSession()', () {
      test('resets to idle state when no session is running', () async {
        // Act
        timerCubit.resetSession();

        // Assert
        expect(timerCubit.state.status, TimerStatus.idle);
        expect(timerCubit.state.remainingSeconds,
            timerCubit.state.focusDuration * 60);
      });

      test('ends session and resets when session is running', () async {
        // Arrange
        when(() => mockSessionRepository.startSession('focus', 25))
            .thenAnswer((_) async => const Success('session-123'));
        when(() => mockSessionRepository.endSession('session-123', 'reset'))
            .thenAnswer((_) async => const Success(null));

        await timerCubit.startSession();

        // Act
        timerCubit.resetSession();

        // Wait for async operation to complete
        await Future.delayed(const Duration(milliseconds: 100));

        // Assert
        expect(timerCubit.state.status, TimerStatus.idle);
      });
    });

    group('Stream behavior', () {
      test('emits state changes as stream', () async {
        // Arrange
        when(() => mockSessionRepository.startSession('focus', 25))
            .thenAnswer((_) async => const Success('session-123'));

        // Act & Assert
        expect(
          timerCubit.stream,
          emitsInOrder([
            predicate<TimerState>((state) => state.isLoading),
            predicate<TimerState>((state) => state.isRunning),
          ]),
        );

        await timerCubit.startSession();
      });
    });

    group('State helpers', () {
      test('isIdle returns true when status is idle', () {
        expect(timerCubit.state.isIdle, true);
      });

      test('isRunning returns false when status is idle', () {
        expect(timerCubit.state.isRunning, false);
      });

      test('isPaused returns false when status is idle', () {
        expect(timerCubit.state.isPaused, false);
      });

      test('state properties update correctly after startSession', () async {
        // Arrange
        when(() => mockSessionRepository.startSession('focus', 25))
            .thenAnswer((_) async => const Success('session-123'));

        // Act
        await timerCubit.startSession();

        // Assert
        expect(timerCubit.state.isRunning, true);
        expect(timerCubit.state.isIdle, false);
        expect(timerCubit.state.isPaused, false);
      });
    });

    group('Mode switching', () {
      test('break mode has correct duration', () async {
        // Act
        await timerCubit.flipMode();

        // Assert
        expect(timerCubit.state.mode, SessionMode.breakTime);
        expect(timerCubit.state.totalSeconds, 300); // 5 minutes
      });

      test('focus mode has correct duration', () {
        // Assert
        expect(timerCubit.state.mode, SessionMode.focus);
        expect(timerCubit.state.totalSeconds, 1500); // 25 minutes
      });

      test('starting session in break mode uses correct duration', () async {
        // Arrange
        await timerCubit.flipMode(); // Switch to break mode
        when(() => mockSessionRepository.startSession('breakTime', 5))
            .thenAnswer((_) async => const Success('session-456'));

        // Act
        await timerCubit.startSession();

        // Assert
        verify(() => mockSessionRepository.startSession('breakTime', 5))
            .called(1);
      });
    });

    group('Close behavior', () {
      test('ends active session on close', () async {
        // Arrange
        when(() => mockSessionRepository.startSession('focus', 25))
            .thenAnswer((_) async => const Success('session-123'));
        when(() => mockSessionRepository.endSession('session-123', 'interrupted'))
            .thenAnswer((_) async => const Success(null));

        await timerCubit.startSession();

        // Act
        await timerCubit.close();

        // Assert
        verify(() => mockSessionRepository.endSession('session-123', 'interrupted'))
            .called(1);
      });

      test('does not end session if no sessionId on close', () async {
        // Act
        await timerCubit.close();

        // Assert
        verifyNever(() => mockSessionRepository.endSession(any(), any()));
      });
    });
  });
}
