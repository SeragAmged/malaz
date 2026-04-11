import '../../../../core/errors/domain_errors.dart';
import '../../../../core/result.dart';
import '../../domain/entities/room.dart';
import '../../domain/repositories/rooms_repository.dart';
import '../datasources/rooms_local_datasource.dart';
import '../datasources/rooms_remote_datasource.dart';

class RoomsRepositoryImpl implements RoomsRepository {
  const RoomsRepositoryImpl({required this.remote, required this.local});

  final RoomsRemoteDataSource remote;
  final RoomsLocalDataSource local;

  @override
  Future<Result<List<Room>, DomainError>> getRooms() async {
    throw UnimplementedError(
      'TODO: implement remote-first room fetching with local fallback.',
    );
  }
}
