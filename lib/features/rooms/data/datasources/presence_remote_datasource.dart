import 'package:injectable/injectable.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

@injectable
class PresenceRemoteDataSource {
  const PresenceRemoteDataSource({required this.supabase});
  final SupabaseClient supabase;

  /// Set the user's presence status
  /// [status] - presence status ('online', 'working', 'onBreak', 'idle', 'offline')
  Future<void> setMemberStatus(String status) async {
    await supabase.rpc(
      'set_member_status',
      params: {'p_status': status},
    );
  }
}
