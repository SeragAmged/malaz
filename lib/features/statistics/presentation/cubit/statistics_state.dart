import 'package:malaz/features/statistics/domain/entities/focus_activity.dart';
import 'package:malaz/features/statistics/domain/entities/total_focus_time.dart';

enum UiStatus { initial, loading, success, failure }

enum StatsPeriod { week, month }

class StatisticsState {
  const StatisticsState({
    this.status = UiStatus.initial,
    this.selectedPeriod = StatsPeriod.week,
    this.totalFocusTime,
    this.sessionsStats,
    this.avgDurationStats,
    this.weeklyActivity = const [],
    this.monthlyActivity = const [],
    this.errorMessage,
  });

  final UiStatus status;
  final StatsPeriod selectedPeriod;
  final TotalFocusTime? totalFocusTime;
  final int? sessionsStats;
  final double? avgDurationStats;
  final List<FocusActivity> weeklyActivity;
  final List<FocusActivity> monthlyActivity;
  final String? errorMessage;

  bool get isInitial => status == UiStatus.initial;
  bool get isLoading => status == UiStatus.loading;
  bool get isSuccess => status == UiStatus.success;
  bool get isFailure => status == UiStatus.failure;

  List<FocusActivity> get currentActivity =>
      selectedPeriod == StatsPeriod.week ? weeklyActivity : monthlyActivity;

  StatisticsState copyWith({
    UiStatus? status,
    StatsPeriod? selectedPeriod,
    TotalFocusTime? totalFocusTime,
    int? sessionsStats,
    double? avgDurationStats,
    List<FocusActivity>? weeklyActivity,
    List<FocusActivity>? monthlyActivity,
    String? errorMessage,
  }) {
    return StatisticsState(
      status: status ?? this.status,
      selectedPeriod: selectedPeriod ?? this.selectedPeriod,
      totalFocusTime: totalFocusTime ?? this.totalFocusTime,
      sessionsStats: sessionsStats ?? this.sessionsStats,
      avgDurationStats: avgDurationStats ?? this.avgDurationStats,
      weeklyActivity: weeklyActivity ?? this.weeklyActivity,
      monthlyActivity: monthlyActivity ?? this.monthlyActivity,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}
