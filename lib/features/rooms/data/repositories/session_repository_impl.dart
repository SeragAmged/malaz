import 'package:injectable/injectable.dart';

import '../../../../core/util/errors/domain_errors.dart';
import '../../../../core/util/result.dart';
import '../../domain/repositories/session_repository.dart';
import '../datasources/session_remote_datasource.dart';

/// Implementation of SessionRepository
/// Wraps SessionRemoteDataSource with error handling
@Injectable(as: SessionRepository)
class SessionRepositoryImpl implements SessionRepository {
  final SessionRemoteDataSource _dataSource;

  SessionRepositoryImpl(this._dataSource);

  @override
  Future<Result<String, DomainError>> startSession(
    String sessionType,
    int plannedMinutes,
  ) async {
    try {
      final sessionId = await _dataSource.startSession(sessionType, plannedMinutes);
      return Success(sessionId);
    } on Exception catch (e) {
      return Failure(UnknownError(message: e.toString()), null);
    }
  }

  @override
  Future<Result<void, DomainError>> pauseSession(String sessionId) async {
    try {
      await _dataSource.pauseSession(sessionId);
      return Success(null);
    } on Exception catch (e) {
      return Failure(UnknownError(message: e.toString()), null);
    }
  }

  @override
  Future<Result<void, DomainError>> resumeSession(String sessionId) async {
    try {
      await _dataSource.resumeSession(sessionId);
      return Success(null);
    } on Exception catch (e) {
      return Failure(UnknownError(message: e.toString()), null);
    }
  }

  @override
  Future<Result<void, DomainError>> endSession(
    String sessionId,
    String reason,
  ) async {
    try {
      await _dataSource.endSession(sessionId, reason);
      return Success(null);
    } on Exception catch (e) {
      return Failure(UnknownError(message: e.toString()), null);
    }
  }
}
