import '../../domain/entities/active_session.dart';

class ActiveSessionModel {
  const ActiveSessionModel({
    required this.sessionId,
    required this.sessionType,
    required this.startedAt,
    required this.plannedMinutes,
    required this.status,
    required this.totalPausedSeconds,
    this.pausedAt,
  });

  final String sessionId;
  final String sessionType;
  final DateTime startedAt;
  final int plannedMinutes;
  final String status;
  final int totalPausedSeconds;
  final DateTime? pausedAt;

  factory ActiveSessionModel.fromJson(Map<String, dynamic> json) {
    return ActiveSessionModel(
      sessionId: json['session_id'] as String,
      sessionType: json['session_type'] as String,
      startedAt: DateTime.parse(json['started_at'] as String),
      plannedMinutes: json['planned_minutes'] as int,
      status: json['status'] as String,
      totalPausedSeconds: json['total_paused_seconds'] as int? ?? 0,
      pausedAt: json['paused_at'] != null
          ? DateTime.parse(json['paused_at'] as String)
          : null,
    );
  }

  ActiveSession toEntity() => ActiveSession(
    sessionId: sessionId,
    sessionType: sessionType,
    startedAt: startedAt,
    plannedMinutes: plannedMinutes,
    status: status,
    totalPausedSeconds: totalPausedSeconds,
    pausedAt: pausedAt,
  );
}
