import 'package:malaz/core/util/errors/domain_errors.dart';
import 'package:malaz/core/util/result.dart';

import '../entities/focus_activity.dart';
import '../entities/total_focus_time.dart';

abstract interface class StatisticsRepository {
  Future<Result<TotalFocusTime, DomainError>> getTotalFocusTimeMinutes();
  Future<Result<int, DomainError>> getTotalSessionsCount();
  Future<Result<double, DomainError>> getSessionsAvgDurationMinutes();
  Future<Result<List<FocusActivity>, DomainError>> getWeeklyActivity();
  Future<Result<List<FocusActivity>, DomainError>> getMonthlyActivity();
}
