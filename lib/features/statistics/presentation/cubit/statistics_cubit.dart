import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:malaz/features/statistics/domain/repositories/statistics_repository.dart';

import 'statistics_state.dart';

@injectable
class StatisticsCubit extends Cubit<StatisticsState> {
  StatisticsCubit(this._repository) : super(const StatisticsState());

  final StatisticsRepository _repository;

  Future<void> fetchStats({bool forceRefresh = false}) async {
    if (state.isLoading) return;
    emit(
      state.copyWith(
        status: UiStatus.loading,
        weeklyActivity: [],
        monthlyActivity: [],
      ),
    );

    final (
      totalResult,
      sessionsResult,
      avgResult,
      weeklyResult,
      monthlyResult,
    ) = await (
      _repository.getTotalFocusTimeMinutes(),
      _repository.getTotalSessionsCount(),
      _repository.getSessionsAvgDurationMinutes(),
      _repository.getWeeklyActivity(),
      _repository.getMonthlyActivity(),
    ).wait;

    if (isClosed) return;

    emit(
      state.copyWith(
        status: UiStatus.success,
        sessionsStats: sessionsResult.dataOrNull ?? 0,
        avgDurationStats: avgResult.dataOrNull ?? 0,
        totalFocusTime: totalResult.dataOrNull,
        weeklyActivity: weeklyResult.dataOrNull ?? [],
        monthlyActivity: monthlyResult.dataOrNull ?? [],
      ),
    );
  }

  void selectPeriod(StatsPeriod period) {
    emit(state.copyWith(selectedPeriod: period));
  }
}
