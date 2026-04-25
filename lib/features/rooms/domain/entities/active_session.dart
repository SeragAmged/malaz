import 'package:malaz/features/rooms/domain/entities/enums.dart';

class ActiveSession {
  const ActiveSession({
    required this.sessionId,
    required this.sessionType,
    required this.startedAt,
    required this.plannedMinutes,
    required this.totalPausedSeconds,
    this.pausedAt,
  });

  final String sessionId;
  final SessionType sessionType;
  final DateTime startedAt;
  final int plannedMinutes;
  final int totalPausedSeconds;
  final DateTime? pausedAt;

  bool get isPaused => pausedAt != null;
}
