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

  /// Group activities by date (weekly) or return as-is (monthly)
  List<FocusActivity> _processActivities() {
    if (activities.isEmpty) return [];

    // For monthly, don't group - show each date as-is
    if (period == StatsPeriod.month) {
      final sorted = [...activities]..sort((a, b) => a.date.compareTo(b.date));
      return sorted;
    }

    // For weekly, group by date and sum minutes
    final Map<DateTime, double> grouped = {};
    for (final a in activities) {
      final dateOnly = DateTime(a.date.year, a.date.month, a.date.day);
      grouped[dateOnly] = (grouped[dateOnly] ?? 0) + a.totalFocusMinutes;
    }

    final sorted = grouped.entries.toList()
      ..sort((a, b) => a.key.compareTo(b.key));

    return sorted
        .map((e) => FocusActivity(date: e.key, totalFocusMinutes: e.value))
        .toList();
  }

  String _label(FocusActivity a, int index) {
    if (period == StatsPeriod.week) {
      const days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
      return days[a.date.weekday - 1];
    } else {
      return '${a.date.day}';
    }
  }

  @override
  Widget build(BuildContext context) {
    final grouped = _processActivities();
    final maxY = grouped.isEmpty
        ? 100.0
        : grouped
              .map((e) => e.totalFocusMinutes)
              .reduce((a, b) => a > b ? a : b);
    final yMax = (maxY * 1.3).ceilToDouble();

    return SizedBox(
      height: 220.h,
      child: LineChart(
        LineChartData(
          minX: 0,
          maxX: (grouped.length - 1).toDouble().clamp(0, double.infinity),
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
                    style: TextStyle(
                      fontFamily: AppTextStyles.manrope,
                      fontSize: 10.sp,
                      fontWeight: FontWeight.w700,
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
                  if (index < 0 || index >= grouped.length) {
                    return const SizedBox.shrink();
                  }
                  return Text(
                    _label(grouped[index], index).toUpperCase(),
                    style: TextStyle(
                      fontFamily: AppTextStyles.manrope,
                      fontSize: 10.sp,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 1,
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
                      TextStyle(
                        fontFamily: AppTextStyles.manrope,
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w700,
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
                grouped.length,
                (i) => FlSpot(i.toDouble(), grouped[i].totalFocusMinutes),
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
