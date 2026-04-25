import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:malaz/core/theme/app_colors.dart';
import 'package:malaz/core/theme/app_text_styles.dart';
import 'package:malaz/features/statistics/domain/entities/focus_activity.dart';
import 'package:malaz/features/statistics/presentation/cubit/statistics_state.dart';

class FocusChart extends StatelessWidget {
  const FocusChart({super.key, required this.activities, required this.period});

  final List<FocusActivity> activities;
  final StatsPeriod period;

  String _label(FocusActivity a, int index) {
    if (period == StatsPeriod.week) {
      const days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
      return days[a.date.weekday - 1];
    } else {
      return '${a.date.day}/${a.date.month}';
    }
  }

  @override
  Widget build(BuildContext context) {
    final yMax =
        (activities.isEmpty
                ? 100.0
                : activities
                          .map((e) => e.totalFocusMinutes)
                          .reduce((a, b) => a > b ? a : b) *
                      1.3)
            .ceilToDouble();

    return SizedBox(
      height: 220.h,
      child: LineChart(
        LineChartData(
          minX: 0,
          maxX: (activities.length - 1).toDouble().clamp(0, double.infinity),
          minY: 0,
          maxY: yMax,
          gridData: FlGridData(
            show: true,
            drawVerticalLine: false,
            horizontalInterval: yMax / 4,
            getDrawingHorizontalLine: (_) => FlLine(
              color: AppColors.borderColor.withAlpha(80),
              strokeWidth: 1,
            ),
          ),
          borderData: FlBorderData(show: false),
          titlesData: FlTitlesData(
            topTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            rightTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 28.w,
                interval: yMax / 4,
                getTitlesWidget: (value, meta) {
                  if (value == 0) return const SizedBox.shrink();
                  return Text(
                    '${value.toInt()}',
                    style: AppTextStyles.labelSmall.copyWith(
                      color: AppColors.textSecondaryColor,
                    ),
                  );
                },
              ),
            ),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 22.h,
                getTitlesWidget: (value, meta) {
                  final index = value.toInt();
                  if (index < 0 || index >= activities.length) {
                    return const SizedBox.shrink();
                  }
                  return Text(
                    _label(activities[index], index).toUpperCase(),
                    style: AppTextStyles.cardTagMedium.copyWith(
                      color: AppColors.textSecondaryColor,
                    ),
                  );
                },
              ),
            ),
          ),
          lineTouchData: LineTouchData(
            touchTooltipData: LineTouchTooltipData(
              getTooltipColor: (_) => AppColors.surfaceColor,
              getTooltipItems: (spots) => spots
                  .map(
                    (s) => LineTooltipItem(
                      '${s.y.toStringAsFixed(0)}m',
                      AppTextStyles.labelLarge.copyWith(
                        color: AppColors.primaryColor,
                      ),
                    ),
                  )
                  .toList(),
            ),
          ),
          lineBarsData: [
            LineChartBarData(
              spots: List.generate(
                activities.length,
                (i) => FlSpot(i.toDouble(), activities[i].totalFocusMinutes),
              ),
              isCurved: true,
              curveSmoothness: 0.35,
              color: AppColors.primaryColor,
              barWidth: 2,
              dotData: FlDotData(
                show: true,
                getDotPainter: (spot, percent, bar, index) =>
                    FlDotCirclePainter(
                      radius: 4,
                      color: AppColors.primaryColor,
                      strokeWidth: 2,
                      strokeColor: AppColors.cardSurfaceColor,
                    ),
              ),
              belowBarData: BarAreaData(
                show: true,
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    AppColors.primaryColor.withAlpha(60),
                    AppColors.primaryColor.withAlpha(0),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
