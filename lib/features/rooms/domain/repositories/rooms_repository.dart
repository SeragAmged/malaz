import '../../../../core/errors/domain_errors.dart';
import '../../../../core/result.dart';
import '../entities/room.dart';

abstract interface class RoomsRepository {
  Future<Result<List<Room>, DomainError>> getRooms();
}
