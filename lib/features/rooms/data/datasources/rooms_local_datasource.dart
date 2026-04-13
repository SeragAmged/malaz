import '../../../../core/util/errors/domain_errors.dart';
import '../../../../core/util/result.dart';
import '../models/room_model.dart';

abstract interface class RoomsLocalDataSource {
  Future<void> cacheRooms(List<RoomModel> rooms);
  Future<Result<List<RoomModel>, DomainError>> getCachedRooms();
}

class InMemoryRoomsLocalDataSource implements RoomsLocalDataSource {
  List<RoomModel> _cache = const [];

  @override
  Future<void> cacheRooms(List<RoomModel> rooms) async {
    _cache = List<RoomModel>.unmodifiable(rooms);
  }

  @override
  Future<Result<List<RoomModel>, DomainError>> getCachedRooms() async {
    if (_cache.isEmpty) {
      return const Failure(CacheMissError(message: 'No cached rooms found.'));
    }

    return Success(List<RoomModel>.unmodifiable(_cache));
  }
}
