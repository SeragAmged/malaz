import 'dart:developer' show log;

import 'package:injectable/injectable.dart';
import 'package:malaz/features/rooms/data/models/room_model.dart';
import 'package:malaz/features/rooms/domain/entities/enums.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../core/util/errors/domain_errors.dart';
import '../../../../core/util/result.dart';
import '../../domain/entities/room.dart';
import '../../domain/repositories/rooms_repository.dart';
import '../datasources/rooms_remote_datasource.dart';

@Injectable(as: RoomsRepository)
class RoomsRepositoryImpl implements RoomsRepository {
  const RoomsRepositoryImpl({required this.remote});

  final RoomsRemoteDataSource remote;

  @override
  Future<Result<List<Room>, DomainError>> getRooms(
    int page,
    int pageSize,
  ) async {
    try {
      final List<RoomModel> remoteRooms = await remote.getRooms(page, pageSize);

      final List<Room> res = remoteRooms
          .map((model) => model.toEntity())
          .toList();
      return Success(res);
    } catch (e) {
      return Failure(SupabaseError(message: 'Failed to fetch rooms: $e'));
    }
  }

  @override
  Future<Result<String, DomainError>> createRoom({
    required String name,
    required String type,
    required String color,
    required String? password,
  }) async {
    try {
      final String newRoomId = await remote.createRoom(
        name: name,
        type: type,
        color: color,
        password: password,
      );

      // final List<Room> res = remoteRooms
      //     .map((model) => model.toEntity())
      //     .toList();
      return Success(newRoomId);
    } catch (e) {
      return Failure(_mapError(e));
    }
  }

  @override
  Future<Result<Room, DomainError>> getRoom(String id) async {
    try {
      final RoomModel newRoom = await remote.getRoom(id);

      return Success(newRoom.toEntity());
    } catch (e) {
      return Failure(SupabaseError(message: 'Failed to get room $id: $e'));
    }
  }

  @override
  Future<Result<void, DomainError>> joinRoom({
    required String roomId,
    String? password,
  }) async {
    try {
      await remote.joinRoom(roomId, password);
      return Success(null);
    } catch (e) {
      return Failure(_mapError(e));
    }
  }

  @override
  Future<Result<String, DomainError>> leaveRoom() async {
    try {
      final roomId = await remote.leaveRoom();
      return Success(roomId);
    } catch (e) {
      return Failure(SupabaseError(message: 'Failed to leave room: $e'));
    }
  }

  DomainError _mapError(dynamic e) {
    final message = e is PostgrestException ? e.message : e.toString();
    log('Error in RoomsRepositoryImpl: $message');
    if (message.contains("already_in_room")) {
      return AlreadyInRoom(message: message);
    } else if (e is PostgrestException) {
      return SupabaseError(message: message);
    }
    return SupabaseError(message: message);
  }
}
