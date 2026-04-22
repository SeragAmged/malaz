import '../../../../core/util/errors/domain_errors.dart';
import '../../../../core/util/result.dart';

abstract interface class PresenceRepository {
  /// Set the user's presence status
  /// [status] - presence status ('online', 'working', 'onBreak', 'idle', 'offline')
  Future<Result<void, DomainError>> setStatus(String status);
}
