import 'package:malaz/features/rooms/domain/entities/enums.dart';

import '../../../../core/util/errors/domain_errors.dart';
import '../../../../core/util/result.dart';
import '../entities/room.dart';

abstract interface class RoomsRepository {
  Future<Result<List<Room>, DomainError>> getRooms(int page, int pageSize);
  Future<Result<Room, DomainError>> getRoom(String id);
  Future<Result<String, DomainError>> createRoom({
    required String name,
    required String type,
    required String color,
    required String? password,
  });
  Future<Result<void, DomainError>> joinRoom({
    required String roomId,
    String? password,
  });
  Future<Result<String, DomainError>> leaveRoom();
}
