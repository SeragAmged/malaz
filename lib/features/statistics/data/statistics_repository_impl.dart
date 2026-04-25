import 'dart:developer';

import 'package:injectable/injectable.dart';
import 'package:malaz/core/util/errors/domain_errors.dart';
import 'package:malaz/core/util/result.dart';
import 'package:malaz/features/statistics/domain/entities/focus_activity.dart';
import 'package:malaz/features/statistics/domain/entities/total_focus_time.dart';
import 'package:malaz/features/statistics/domain/repositories/statistics_repository.dart';

import 'statistics_remote_datasource.dart';

@Injectable(as: StatisticsRepository)
class StatisticsRepositoryImpl implements StatisticsRepository {
  const StatisticsRepositoryImpl({required this.remote});

  final StatisticsRemoteDataSource remote;

  @override
  Future<Result<TotalFocusTime, DomainError>> getTotalFocusTimeMinutes() async {
    try {
      final model = await remote.getTotalFocusTime();
      return Success(model?.toEntity()?? TotalFocusTime(totalFocusMinutes: 0, lastWeekPercentageDiff: 0));
    } catch (e) {
      return Failure(SupabaseError(message: 'get_total_focus_time failed: $e'));
    }
  }

  @override
  Future<Result<int, DomainError>> getTotalSessionsCount() async {
    try {
      final model = await remote.getTotalSessionsCount();
      return Success(model ?? 0);
    } catch (e) {
      return Failure(
        SupabaseError(message: 'get_total_sessions_count failed: $e'),
      );
    }
  }

  @override
  Future<Result<double, DomainError>> getSessionsAvgDurationMinutes() async {
    try {
      final res = await remote.getSessionsAvgDurationMinutes();
      return Success(res ?? 0.0);
    } catch (e) {
      return Failure(
        SupabaseError(message: 'get_avg_duration_stats failed: $e'),
      );
    }
  }

  @override
  Future<Result<List<FocusActivity>, DomainError>> getWeeklyActivity() async {
    try {
      final models = await remote.getWeeklyActivity();
      return Success(models?.map((m) => m.toEntity()).toList() ?? []);
    } catch (e) {
      log('Error in getWeeklyActivity: $e');
      return Failure(
        SupabaseError(message: 'get_weekly_focus_activity failed: $e'),
      );
    }
  }

  @override
  Future<Result<List<FocusActivity>, DomainError>> getMonthlyActivity() async {
    try {
      final models = await remote.getMonthlyActivity();
      return Success(models?.map((m) => m.toEntity()).toList() ?? []);
    } catch (e) {
      return Failure(
        SupabaseError(message: 'get_monthly_focus_activity failed: $e'),
      );
    }
  }
}
