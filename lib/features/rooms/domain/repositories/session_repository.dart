import '../../../../core/util/errors/domain_errors.dart';
import '../../../../core/util/result.dart';
import '../entities/active_session.dart';

abstract interface class SessionRepository {
  Future<Result<String, DomainError>> startSession(
    String sessionType,
    int plannedMinutes,
  );

  Future<Result<void, DomainError>> pauseSession(String sessionId);

  Future<Result<void, DomainError>> resumeSession(String sessionId);

  Future<Result<void, DomainError>> endSession(String sessionId, String reason);

  Future<Result<ActiveSession?, DomainError>> getActiveSession();
}
