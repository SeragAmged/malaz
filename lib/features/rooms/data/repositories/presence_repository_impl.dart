import 'package:injectable/injectable.dart';

import '../../../../core/util/errors/domain_errors.dart';
import '../../../../core/util/result.dart';
import '../../domain/repositories/presence_repository.dart';
import '../datasources/presence_remote_datasource.dart';

/// Implementation of PresenceRepository
/// Wraps PresenceRemoteDataSource with error handling
@Injectable(as: PresenceRepository)
class PresenceRepositoryImpl implements PresenceRepository {
  final PresenceRemoteDataSource _dataSource;

  PresenceRepositoryImpl(this._dataSource);

  @override
  Future<Result<void, DomainError>> setStatus(String status) async {
    try {
      await _dataSource.setMemberStatus(status);
      return Success(null);
    } on Exception catch (e) {
      return Failure(UnknownError(message: e.toString()), null);
    }
  }
}
