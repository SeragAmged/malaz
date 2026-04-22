import '../../../../core/util/errors/domain_errors.dart';
import '../../../../core/util/result.dart';

abstract interface class SessionRepository {
  /// Start a new session
  /// Returns the session UUID on success
  /// [sessionType] - type of session (e.g., 'work', 'break')
  /// [plannedMinutes] - duration in minutes
  Future<Result<String, DomainError>> startSession(
    String sessionType,
    int plannedMinutes,
  );

  /// Pause an ongoing session
  /// [sessionId] - ID of the session to pause
  Future<Result<void, DomainError>> pauseSession(String sessionId);

  /// Resume a paused session
  /// [sessionId] - ID of the session to resume
  Future<Result<void, DomainError>> resumeSession(String sessionId);

  /// End a session
  /// [sessionId] - ID of the session to end
  /// [reason] - reason for ending ('completed', 'interrupted', 'abandoned')
  Future<Result<void, DomainError>> endSession(
    String sessionId,
    String reason,
  );
}
