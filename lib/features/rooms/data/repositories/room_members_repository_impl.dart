import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';
import 'package:malaz/features/rooms/data/datasources/room_members_data_source.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../domain/entities/room_member_with_session.dart';
import '../../domain/entities/leaderboard_entry.dart';
import '../../domain/repositories/room_members_repository.dart';
import '../../../../core/util/result.dart';
import '../../../../core/util/errors/domain_errors.dart';

@Injectable(as: RoomMembersRepository)
class RoomMembersRepositoryImpl implements RoomMembersRepository {
  final RoomMembersDataSource _datasource;

  RoomMembersRepositoryImpl({required RoomMembersDataSource datasource})
      : _datasource = datasource;

  @override
  Future<Result<List<RoomMemberWithSession>, DomainError>> getMembers(
    String roomId,
  ) async {
    try {
      final models = await _datasource.getMembersWithSession(roomId);
      return Success(models.map((m) => m.toEntity()).toList());
    } catch (e) {
      return Failure(
        UnknownError(message: 'Failed to fetch room members: $e'),
        null,
      );
    }
  }

  @override
  RealtimeChannel subscribeToRoomChanges(
    String roomId,
    VoidCallback onEvent,
  ) {
    return _datasource.subscribeToRoomChanges(roomId, onEvent);
  }

  @override
  Future<void> unsubscribeFromRoomChanges(RealtimeChannel channel) async {
    await _datasource.unsubscribeFromRoomChanges(channel);
  }

  @override
  Future<Result<List<LeaderboardEntry>, DomainError>> getTopLeaders(
    String roomId,
  ) async {
    try {
      final models = await _datasource.getTopLeaders(roomId);
      return Success(models.map((m) => m.toEntity()).toList());
    } catch (e) {
      return Failure(
        UnknownError(message: 'Failed to fetch leaderboard: $e'),
        null,
      );
    }
  }
}
