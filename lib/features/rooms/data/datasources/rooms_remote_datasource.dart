import 'dart:developer';
import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../models/room_member_with_session_model.dart';
import '../models/room_model.dart';

@injectable
class RoomsRemoteDataSource {
  const RoomsRemoteDataSource({required this.supabase});
  final SupabaseClient supabase;

  Future<List<RoomModel>> getRooms(int page, int pageSize) async {
    final from = (page - 1) * pageSize;
    final to = from + pageSize - 1;

    final roomsJson = await supabase
        .from('rooms_list_view')
        .select()
        .range(from, to);
    // log('Fetched rooms JSON: $roomsJson');
    final rooms = roomsJson.map((json) => RoomModel.fromJson(json)).toList();

    return rooms;
  }

  Future<String> createRoom({
    required String name,
    required String type,
    required String color,
    required String? password,
  }) async {
    final response = await supabase.rpc(
      'create_room',
      params: {
        "p_name": name,
        "p_type": type,
        "p_color": color,
        "p_password": password,
      },
    );
    // log('Fetched new room JSON: $response');
    // final rooms = response.map((json) => RoomModel.fromJson(json)).toList();

    return response;
  }

  Future<RoomModel> getRoom(String id) async {
    final response = await supabase
        .from('rooms_list_view')
        .select()
        .eq('id', id)
        .single();
    return RoomModel.fromJson(response);
  }

  Future<String> leaveRoom() async {
    final roomId = await supabase.rpc('leave_room');
    log('leave Room JSON: $roomId');
    return roomId;
  }

  Future<void> joinRoom(String roomId, String? password) async {
    final response = await supabase.rpc(
      'join_room',
      params: {"p_room_id": roomId, "p_password": password},
    );
    log('join Room JSON: $response');
    return response;
  }

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

  /// Subscribe to realtime changes on room_members and pomodoro_sessions
  ///
  /// Monitors both tables filtered by room_id, calling [onEvent] whenever
  /// a member joins/leaves or a session starts/pauses/ends.
  ///
  /// [roomId] - ID of the room to monitor
  /// [onEvent] - Callback fired on any change (INSERT, UPDATE, DELETE)
  /// Returns: RealtimeChannel that can be unsubscribed later
  RealtimeChannel subscribeToRoomChanges(String roomId, VoidCallback onEvent) {
    final channel = supabase.channel('room_changes_$roomId');

    // Subscribe to room_members changes
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
        // Subscribe to pomodoro_sessions changes
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

  /// Unsubscribe from a realtime room changes channel
  ///
  /// Removes the channel from the Supabase realtime client.
  /// Call this when disposing the cubit or leaving the room.
  ///
  /// [channel] - RealtimeChannel returned from subscribeToRoomChanges()
  Future<void> unsubscribeFromRoomChanges(RealtimeChannel channel) async {
    await channel.unsubscribe();
    await supabase.removeChannel(channel);
  }

  /// Fetch top 3 daily leaders for a room
  ///
  /// Calls the daily_room_leaderboard(room_id) RPC function which returns
  /// the top 3 members by total focus hours completed today.
  ///
  /// [roomId] - ID of the room
  /// Returns: List of leaderboard entries with user names and focus hours
  Future<List<LeaderboardEntryModel>> getTopLeaders(String roomId) async {
    final response = await supabase.rpc(
      'daily_room_leaderboard',
      params: {'v_room_id': roomId},
    );

    return (response as List)
        .map((json) => LeaderboardEntryModel.fromJson(json))
        .toList();
  }
}
