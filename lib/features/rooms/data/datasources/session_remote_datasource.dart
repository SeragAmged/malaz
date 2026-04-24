import 'dart:developer';

import 'package:injectable/injectable.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../models/active_session_model.dart';

@injectable
class SessionRemoteDataSource {
  const SessionRemoteDataSource({required this.supabase});
  final SupabaseClient supabase;

  /// Start a new session
  /// Returns the session UUID on success
  /// [sessionType] - type of session (e.g., 'work', 'break')
  /// [plannedMinutes] - duration in minutes
  Future<String> startSession(String sessionType, int plannedMinutes) async {
    final response = await supabase.rpc(
      'start_session',
      params: {
        'p_session_type': sessionType,
        'p_planned_minutes': plannedMinutes,
      },
    );
    return response as String;
  }

  /// Pause an ongoing session
  /// [sessionId] - ID of the session to pause
  Future<void> pauseSession(String sessionId) async {
    await supabase.rpc('pause_session', params: {'p_session_id': sessionId});
  }

  /// Resume a paused session
  /// [sessionId] - ID of the session to resume
  Future<void> resumeSession(String sessionId) async {
    await supabase.rpc('resume_session', params: {'p_session_id': sessionId});
  }

  /// End a session
  /// [sessionId] - ID of the session to end
  /// [reason] - reason for ending ('completed', 'interrupted', 'abandoned')
  Future<void> endSession(String sessionId, String reason) async {
    // return;
    await supabase.rpc(
      'end_session',
      params: {'p_session_id': sessionId, 'p_ended_reason': reason},
    );
    log('endSession response: Session $sessionId ended with reason: $reason');
  }

  /// Fetch the current user's active session from the view
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
