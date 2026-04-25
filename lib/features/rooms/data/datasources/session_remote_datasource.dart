import 'dart:developer';

import 'package:injectable/injectable.dart';
import 'package:malaz/features/rooms/domain/entities/enums.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../models/active_session_model.dart';

@injectable
class SessionRemoteDataSource {
  const SessionRemoteDataSource({required this.supabase});
  final SupabaseClient supabase;

  Future<String> startSession(String sessionType, int plannedMinutes) async {
    final response = await supabase.rpc(
      'start_session',
      params: {
        'p_session_type': sessionType,
        'p_planned_minutes': plannedMinutes,
      },
    );
    log('startSession response: $response');
    return response as String;
  }

  Future<void> pauseSession(String sessionId) async {
    await supabase.rpc('pause_session', params: {'p_session_id': sessionId});
    log('pauseSession response: Session $sessionId paused');
  }

  Future<void> resumeSession(String sessionId) async {
    await supabase.rpc('resume_session', params: {'p_session_id': sessionId});
    log('resumeSession response: Session $sessionId resumed');
  }

  Future<void> endSession(String sessionId, SessionEndReason reason) async {
    await supabase.rpc(
      'end_session',
      params: {'p_session_id': sessionId, 'p_ended_reason': reason.name},
    );
    log('endSession response: Session $sessionId ended with reason: $reason');
  }

  Future<ActiveSessionModel?> getActiveSession() async {
    final response = await supabase
        .from('active_session_view')
        .select()
        .maybeSingle();
    log('getActiveSession response: $response');
    if (response == null) return null;
    return ActiveSessionModel.fromJson(response);
  }
}
