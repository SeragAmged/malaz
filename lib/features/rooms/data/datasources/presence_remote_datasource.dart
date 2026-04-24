import 'package:injectable/injectable.dart';
import 'package:malaz/features/rooms/domain/entities/enums.dart';
import 'package:malaz/features/rooms/domain/entities/room_member_with_session.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

@injectable
class PresenceRemoteDataSource {
  const PresenceRemoteDataSource({required this.supabase});
  final SupabaseClient supabase;

  Future<void> setMemberStatus(MemberStatus status) async {
    return;
    await supabase.rpc('set_member_status', params: {'p_status': status});
  }
}
