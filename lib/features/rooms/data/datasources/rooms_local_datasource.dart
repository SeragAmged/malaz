import '../../../../core/errors/domain_errors.dart';
import '../../../../core/result.dart';
import '../models/room_model.dart';

abstract interface class RoomsLocalDataSource {
  Future<void> cacheRooms(List<RoomModel> rooms);
  Future<Result<List<RoomModel>, DomainError>> getCachedRooms();
}
