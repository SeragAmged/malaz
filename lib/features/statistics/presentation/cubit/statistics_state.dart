import 'package:malaz/features/statistics/domain/entities/focus_activity.dart';
import 'package:malaz/features/statistics/domain/entities/total_focus_time.dart';

enum UiStatus { initial, loading, success, failure }

enum StatsPeriod { week, month }

enum RequestStatus { idle, success, failure }

class StatisticsState {
  const StatisticsState({
    this.status = UiStatus.initial,
    this.selectedPeriod = StatsPeriod.week,
    this.totalFocusTime,
    this.totalFocusTimeStatus = RequestStatus.idle,
    this.sessionsStats,
    this.sessionsStatsStatus = RequestStatus.idle,
    this.avgDurationStats,
    this.avgDurationStatsStatus = RequestStatus.idle,
    this.weeklyActivity = const [],
    this.weeklyActivityStatus = RequestStatus.idle,
    this.monthlyActivity = const [],
    this.monthlyActivityStatus = RequestStatus.idle,
    this.errorMessage,
  });

  final UiStatus status;
  final StatsPeriod selectedPeriod;
  final TotalFocusTime? totalFocusTime;
  final RequestStatus totalFocusTimeStatus;
  final int? sessionsStats;
  final RequestStatus sessionsStatsStatus;
  final double? avgDurationStats;
  final RequestStatus avgDurationStatsStatus;
  final List<FocusActivity> weeklyActivity;
  final RequestStatus weeklyActivityStatus;
  final List<FocusActivity> monthlyActivity;
  final RequestStatus monthlyActivityStatus;
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
    RequestStatus? totalFocusTimeStatus,
    int? sessionsStats,
    RequestStatus? sessionsStatsStatus,
    double? avgDurationStats,
    RequestStatus? avgDurationStatsStatus,
    List<FocusActivity>? weeklyActivity,
    RequestStatus? weeklyActivityStatus,
    List<FocusActivity>? monthlyActivity,
    RequestStatus? monthlyActivityStatus,
    String? errorMessage,
  }) {
    return StatisticsState(
      status: status ?? this.status,
      selectedPeriod: selectedPeriod ?? this.selectedPeriod,
      totalFocusTime: totalFocusTime ?? this.totalFocusTime,
      totalFocusTimeStatus: totalFocusTimeStatus ?? this.totalFocusTimeStatus,
      sessionsStats: sessionsStats ?? this.sessionsStats,
      sessionsStatsStatus: sessionsStatsStatus ?? this.sessionsStatsStatus,
      avgDurationStats: avgDurationStats ?? this.avgDurationStats,
      avgDurationStatsStatus: avgDurationStatsStatus ?? this.avgDurationStatsStatus,
      weeklyActivity: weeklyActivity ?? this.weeklyActivity,
      weeklyActivityStatus: weeklyActivityStatus ?? this.weeklyActivityStatus,
      monthlyActivity: monthlyActivity ?? this.monthlyActivity,
      monthlyActivityStatus: monthlyActivityStatus ?? this.monthlyActivityStatus,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}
