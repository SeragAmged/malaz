import 'dart:developer';
import 'package:injectable/injectable.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

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
}
