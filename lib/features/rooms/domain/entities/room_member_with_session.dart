import 'package:malaz/features/rooms/domain/entities/enums.dart';

class RoomMemberWithSession {
  const RoomMemberWithSession({
    required this.userId,
    required this.fullName,
    this.avatarUrl,
    required this.status,
    required this.lastCheckinAt,
    required this.completedFocusSeconds,
    this.sessionId,
    this.sessionType,
    this.startedAt,
    this.plannedMinutes,
    this.pausedAt,
    this.totalPausedSeconds,
  });
  final String userId;
  final String fullName;
  final String? avatarUrl;
  final UserStatus status;
  final DateTime lastCheckinAt;
  final int completedFocusSeconds;
  final String? sessionId;
  final SessionType? sessionType;
  final DateTime? startedAt;
  final int? plannedMinutes;
  final DateTime? pausedAt;
  final int? totalPausedSeconds;
}
