import '../../domain/entities/leaderboard_entry.dart';

class LeaderboardEntryModel {
  final String userName;
  final double totalFocusHours;

  const LeaderboardEntryModel({
    required this.userName,
    required this.totalFocusHours,
  });

  factory LeaderboardEntryModel.fromJson(Map<String, dynamic> json) {
    return LeaderboardEntryModel(
      userName: json['user_name'] as String,
      totalFocusHours: (json['total_focus_hours'] as num).toDouble(),
    );
  }

  LeaderboardEntry toEntity() {
    return LeaderboardEntry(
      userName: userName,
      totalFocusHours: totalFocusHours,
    );
  }
}
