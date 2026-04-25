import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:malaz/core/di/providers.dart';
import 'package:malaz/core/theme/app_colors.dart';
import 'package:malaz/core/theme/app_text_styles.dart';
import 'package:malaz/features/statistics/domain/entities/focus_activity.dart';
import 'package:malaz/features/statistics/domain/entities/total_focus_time.dart';
import 'package:malaz/features/statistics/presentation/cubit/statistics_cubit.dart';
import 'package:malaz/features/statistics/presentation/cubit/statistics_state.dart';
import 'package:malaz/features/statistics/presentation/widgets/focus_chart.dart';
import 'package:malaz/features/statistics/presentation/widgets/period_selector.dart';
import 'package:malaz/features/statistics/presentation/widgets/stat_card.dart';

class StatisticsPage extends StatelessWidget {
  const StatisticsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<StatisticsCubit>(
      create: (_) => getIt<StatisticsCubit>()..fetchStats(),
      child: const _StatisticsView(),
    );
  }
}

class _StatisticsView extends StatelessWidget {
  const _StatisticsView();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: BlocConsumer<StatisticsCubit, StatisticsState>(
        listener: (context, state) {
          if (state.isFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text(
                  'Failed to load some statistics. Please try again.',
                ),
                backgroundColor: AppColors.errorColor,
              ),
            );
          }
        },
        builder: (context, state) {
          if (state.isLoading || state.isInitial) {
            return const Center(
              child: CircularProgressIndicator(color: AppColors.primaryColor),
            );
          }
          return RefreshIndicator(
            onRefresh: context.read<StatisticsCubit>().fetchStats,
            child: SingleChildScrollView(
              padding: EdgeInsets.fromLTRB(24.w, 96.h, 24.w, 134.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildHeader(),
                  SizedBox(height: 32.h),
                  // if (state.weeklyActivity.isNotEmpty ||
                  //     state.monthlyActivity.isNotEmpty)
                  _ChartSection(
                    weeklyActivity: state.weeklyActivity,
                    monthlyActivity: state.monthlyActivity,
                    selectedPeriod: state.selectedPeriod,
                    onPeriodChanged: context
                        .read<StatisticsCubit>()
                        .selectPeriod,
                  ),
                  SizedBox(height: 32.h),
                  _buildSummaryCards(
                    state.totalFocusTime,
                    state.sessionsStats ?? 0,
                    state.avgDurationStats ?? 0,
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Your Productivity',
          style: AppTextStyles.displaySmall,
        ),
        SizedBox(height: 8.h),
        Text(
          'Deep work insights for this week.',
          style: AppTextStyles.bodyLarge.copyWith(
            color: AppColors.textSecondaryColor,
          ),
        ),
      ],
    );
  }

  Widget _buildSummaryCards(
    TotalFocusTime? totalFocusTime,
    int sessions,
    double avgDuration,
  ) {
    final diff = totalFocusTime?.lastWeekPercentageDiff ?? 0;
    final sign = diff >= 0 ? '+' : '';

    return Column(
      children: [
        if (totalFocusTime != null)
          StatCard(
            label: 'Total Focus Time',
            value: '${(totalFocusTime.totalFocusMinutes / 60).toStringAsFixed(1)}h',
            subtitle: '$sign${diff.toStringAsFixed(0)}% from last week',
            icon: Icons.info_outline_rounded,
            subtitleColor: AppColors.primaryColor,
          ),
        SizedBox(height: 16.h),
        StatCard(
          label: 'Sessions',
          value: sessions.toString(),
          subtitle: 'Completed focus blocks',
          icon: Icons.bolt_rounded,
          backgroundColor: AppColors.surfaceColor,
        ),
        SizedBox(height: 16.h),
        StatCard(
          label: 'Avg. Duration',
          value: '${avgDuration}m',
          subtitle: 'Optimal flow state reach',
          icon: Icons.hourglass_bottom_rounded,
        ),
      ],
    );
  }
}

class _ChartSection extends StatelessWidget {
  const _ChartSection({
    required this.weeklyActivity,
    required this.monthlyActivity,
    required this.selectedPeriod,
    required this.onPeriodChanged,
  });

  final List<FocusActivity> weeklyActivity;
  final List<FocusActivity> monthlyActivity;
  final StatsPeriod selectedPeriod;
  final ValueChanged<StatsPeriod> onPeriodChanged;

  @override
  Widget build(BuildContext context) {
    final activities = selectedPeriod == StatsPeriod.week
        ? weeklyActivity
        : monthlyActivity;

    return Container(
      padding: EdgeInsets.all(32.r),
      decoration: BoxDecoration(
        color: AppColors.cardSurfaceColor,
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Focus Activity',
            style: AppTextStyles.headlineSmall,
          ),
          SizedBox(height: 2.h),
          Text(
            'Hours spent in deep work per day',
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.textSecondaryColor,
            ),
          ),
          SizedBox(height: 24.h),
          PeriodSelector(selected: selectedPeriod, onSelect: onPeriodChanged),
          SizedBox(height: 32.h),
          FocusChart(activities: activities, period: selectedPeriod),
        ],
      ),
    );
  }
}
