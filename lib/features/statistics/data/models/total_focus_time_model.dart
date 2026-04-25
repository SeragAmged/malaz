import '../../domain/entities/total_focus_time.dart';

class TotalFocusTimeModel {
  const TotalFocusTimeModel({
    required this.totalFocusHours,
    required this.lastWeekPercentageDiff,
  });

  final double totalFocusHours;
  final double lastWeekPercentageDiff;

  factory TotalFocusTimeModel.fromJson(Map<String, dynamic> json) {
    return TotalFocusTimeModel(
      totalFocusHours: (json['this_week_minutes'] as num).toDouble(),
      lastWeekPercentageDiff: (json['percentage_change'] as num).toDouble(),
    );
  }

  TotalFocusTime toEntity() => TotalFocusTime(
    totalFocusMinutes: totalFocusHours, // Keep as minutes
    lastWeekPercentageDiff: lastWeekPercentageDiff,
  );
}