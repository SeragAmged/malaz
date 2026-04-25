import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:malaz/features/statistics/domain/repositories/statistics_repository.dart';

import 'statistics_state.dart';

@injectable
class StatisticsCubit extends Cubit<StatisticsState> {
  StatisticsCubit(this._repository) : super(const StatisticsState());

  final StatisticsRepository _repository;

  Future<void> fetchStats({bool forceRefresh = false}) async {
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

    var newState = state;

    totalResult.fold(
      onSuccess: (data) {
        newState = newState.copyWith(
          totalFocusTime: data,
          totalFocusTimeStatus: RequestStatus.success,
        );
      },
      onFailure: (error, data) {
        newState = newState.copyWith(
          totalFocusTimeStatus: RequestStatus.failure,
          errorMessage: error.message,
        );
      },
    );

    sessionsResult.fold(
      onSuccess: (data) {
        newState = newState.copyWith(
          sessionsStats: data,
          sessionsStatsStatus: RequestStatus.success,
        );
      },
      onFailure: (error, data) {
        newState = newState.copyWith(
          sessionsStatsStatus: RequestStatus.failure,
          errorMessage: error.message,
        );
      },
    );

    avgResult.fold(
      onSuccess: (data) {
        newState = newState.copyWith(
          avgDurationStats: data,
          avgDurationStatsStatus: RequestStatus.success,
        );
      },
      onFailure: (error, data) {
        newState = newState.copyWith(
          avgDurationStatsStatus: RequestStatus.failure,
          errorMessage: error.message,
        );
      },
    );

    weeklyResult.fold(
      onSuccess: (data) {
        newState = newState.copyWith(
          weeklyActivity: data,
          weeklyActivityStatus: RequestStatus.success,
        );
      },
      onFailure: (error, data) {
        newState = newState.copyWith(
          weeklyActivityStatus: RequestStatus.failure,
          errorMessage: error.message,
        );
      },
    );

    monthlyResult.fold(
      onSuccess: (data) {
        newState = newState.copyWith(
          monthlyActivity: data,
          monthlyActivityStatus: RequestStatus.success,
        );
      },
      onFailure: (error, data) {
        newState = newState.copyWith(
          monthlyActivityStatus: RequestStatus.failure,
          errorMessage: error.message,
        );
      },
    );

    emit(newState.copyWith(status: UiStatus.success));
  }

  void selectPeriod(StatsPeriod period) {
    emit(state.copyWith(selectedPeriod: period));
  }
}
