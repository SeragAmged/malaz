import '../../../../core/errors/domain_errors.dart';
import '../../../../core/result.dart';
import '../models/room_model.dart';

abstract interface class RoomsRemoteDataSource {
  Future<Result<List<RoomModel>, DomainError>> fetchRooms();
}
