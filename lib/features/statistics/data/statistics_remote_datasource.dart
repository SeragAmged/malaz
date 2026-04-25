import 'dart:developer';

import 'package:injectable/injectable.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'models/focus_activity_model.dart';
import 'models/total_focus_time_model.dart';

@injectable
class StatisticsRemoteDataSource {
  const StatisticsRemoteDataSource({required this.client});

  final SupabaseClient client;

  Future<List<FocusActivityModel>> getWeeklyActivity() async {
    final response = await client.rpc('get_daily_focus_this_week');
    log('Raw response from get_daily_focus_this_week: $response');
    return (response as List)
        .map((e) => FocusActivityModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<List<FocusActivityModel>> getMonthlyActivity() async {
    final response = await client.rpc('get_daily_focus_this_month');
    log('Raw response from get_monthly_focus_activity: $response');
    return (response as List)
        .map((e) => FocusActivityModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<TotalFocusTimeModel> getTotalFocusTime() async {
    final response = await client
        .from('focus_week_stats')
        .select('*')
        .limit(1)
        .single();
    log('Raw response from total_focus_minutes_this_week: $response');
    return TotalFocusTimeModel.fromJson(response);
  }

  Future<int> getTotalSessionsCount() async {
    final response = await client.rpc('get_total_focus_sessions_this_week');
    return response as int;
  }

  Future<double> getSessionsAvgDurationMinutes() async {
    final response = await client.rpc('get_avg_focus_duration_this_week');
    return response as double;
  }
}
