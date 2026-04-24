import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../entities/room_member_with_session.dart';
import '../entities/leaderboard_entry.dart';
import '../../../../core/util/result.dart';
import '../../../../core/util/errors/domain_errors.dart';

abstract class RoomMembersRepository {
  Future<Result<List<RoomMemberWithSession>, DomainError>> getMembers(
    String roomId,
  );
  Future<Result<List<LeaderboardEntry>, DomainError>> getTopLeaders(
    String roomId,
  );
  RealtimeChannel subscribeToRoomChanges(
    String roomId,
    VoidCallback onEvent,
  );
  Future<void> unsubscribeFromRoomChanges(RealtimeChannel channel);
}
