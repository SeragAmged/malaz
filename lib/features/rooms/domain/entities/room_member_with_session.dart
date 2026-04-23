/// A room member with their current active session data.
///
/// Contains user information, member status, completed focus time since last check-in,
/// and their current active session if any (focus or break).
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
  final String status; // 'online' | 'working' | 'onBreak' | 'idle' | 'offline'
  final DateTime lastCheckinAt;
  final int completedFocusSeconds;

  // Active session fields (nullable)
  final String? sessionId;
  final String? sessionType; // 'focus' | 'breakTime'
  final DateTime? startedAt;
  final int? plannedMinutes;
  final DateTime? pausedAt;
  final int? totalPausedSeconds;
}
