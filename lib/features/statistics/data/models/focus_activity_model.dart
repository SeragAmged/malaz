import '../../domain/entities/focus_activity.dart';

class FocusActivityModel {
  const FocusActivityModel({
    required this.date,
    required this.totalFocusMinutes,
  });

  final DateTime date;
  final double totalFocusMinutes;

  factory FocusActivityModel.fromJson(Map<String, dynamic> json) {
    return FocusActivityModel(
      date: DateTime.parse(json['date'] as String),
      totalFocusMinutes: (json['total_minutes'] as num).toDouble(),
    );
  }

  FocusActivity toEntity() => FocusActivity(
    date: date,
    totalFocusMinutes: totalFocusMinutes, // Store as minutes in entity
  );
}
