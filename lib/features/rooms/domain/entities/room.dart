enum SessionType { focus, breakTime }

class Room {
  const Room({
    required this.id,
    required this.name,
    required this.type,
    required this.color,
    required this.membersAvatars,
    required this.maxMembers,
    required this.isProtected,
    required this.activeMembers,
    this.description,
    this.backgroundUrl,
    this.sessionType,
    this.plannedMinutes,
    this.pausedAt,
    this.sessionStartedAt,
    required this.isMember,
  });

  final String id;
  final String name;
  final String? description;
  final String? backgroundUrl;
  final String type;
  final String color;
  final List<String> membersAvatars;
  final int activeMembers;
  final int maxMembers;
  final bool isProtected;
  final SessionType? sessionType;
  final int? plannedMinutes;
  final DateTime? pausedAt;
  final DateTime? sessionStartedAt;
  final bool isMember;

  Room copyWith({
    String? id,
    String? name,
    String? description,
    String? backgroundUrl,
    String? type,
    String? color,
    List<String>? membersAvatars,
    int? activeMembers,
    int? maxMembers,
    bool? isProtected,
    SessionType? sessionType,
    int? plannedMinutes,
    DateTime? pausedAt,
    DateTime? sessionStartedAt,
    bool? isMember,
  }) {
    return Room(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      backgroundUrl: backgroundUrl ?? this.backgroundUrl,
      type: type ?? this.type,
      color: color ?? this.color,
      membersAvatars: membersAvatars ?? this.membersAvatars,
      activeMembers: activeMembers ?? this.activeMembers,
      maxMembers: maxMembers ?? this.maxMembers,
      isProtected: isProtected ?? this.isProtected,
      sessionType: sessionType ?? this.sessionType,
      plannedMinutes: plannedMinutes ?? this.plannedMinutes,
      pausedAt: pausedAt ?? this.pausedAt,
      sessionStartedAt: sessionStartedAt ?? this.sessionStartedAt,
      isMember: isMember ?? this.isMember,
    );
  }
}
