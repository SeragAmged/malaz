class ActiveSession {
  const ActiveSession({
    required this.sessionId,
    required this.sessionType,
    required this.startedAt,
    required this.plannedMinutes,
    required this.status,
    required this.totalPausedSeconds,
    this.pausedAt,
  });

  final String sessionId;
  final String sessionType; // 'focus' | 'breakTime'
  final DateTime startedAt;
  final int plannedMinutes;
  final String status; // 'running' | 'paused'
  final int totalPausedSeconds; // sum of all previous pause durations
  final DateTime? pausedAt; // when the current pause started (if paused)
}
