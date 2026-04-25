import 'dart:developer';
import 'package:injectable/injectable.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:flutter/foundation.dart';
import '../models/leaderboard_entry_model.dart';
import '../models/room_member_with_session_model.dart';
@injectable
class RoomMembersDataSource {
  const RoomMembersDataSource({required this.supabase});
  final SupabaseClient supabase;

  /// Fetch members with session data for a specific room
  /// [roomId] - ID of the room to fetch members from
  /// Returns: List of room members with their current session information
  Future<List<RoomMemberWithSessionModel>> getMembersWithSession(
    String roomId,
  ) async {
    final data = await supabase
        .from('room_members_with_session')
        .select()
        .eq('room_id', roomId);

    return (data as List)
        .map((json) => RoomMemberWithSessionModel.fromJson(json))
        .toList();
  }

 
  RealtimeChannel subscribeToRoomChanges(String roomId, VoidCallback onEvent) {
    final channel = supabase.channel('room_changes_$roomId');

    channel
        .onPostgresChanges(
          event: PostgresChangeEvent.all,
          schema: 'public',
          table: 'room_members',
          filter: PostgresChangeFilter(
            type: PostgresChangeFilterType.eq,
            column: 'room_id',
            value: roomId,
          ),
          callback: (payload) {
            onEvent();
          },
        )
        .onPostgresChanges(
          event: PostgresChangeEvent.all,
          schema: 'public',
          table: 'pomodoro_sessions',
          filter: PostgresChangeFilter(
            type: PostgresChangeFilterType.eq,
            column: 'room_id',
            value: roomId,
          ),
          callback: (payload) {
            onEvent();
          },
        )
        .subscribe();

    return channel;
  }

  
  Future<void> unsubscribeFromRoomChanges(RealtimeChannel channel) async {
    await channel.unsubscribe();
    await supabase.removeChannel(channel);
  }


  Future<List<LeaderboardEntryModel>> getTopLeaders(String roomId) async {
    final response = await supabase.rpc(
      'daily_room_leaderboard',
      params: {'v_room_id': roomId},
    );

    log('Fetched leaderboard JSON: $response');

    return (response as List)
        .map((json) => LeaderboardEntryModel.fromJson(json))
        .toList();
  }
}
