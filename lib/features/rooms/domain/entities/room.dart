class Room {
  const Room({
    required this.id,
    required this.name,
    required this.theme,
    required this.currentUsers,
    required this.capacity,
    required this.focusMinutes,
    required this.isLive,
  });

  final String id;
  final String name;
  final String theme;
  final int currentUsers;
  final int capacity;
  final int focusMinutes;
  final bool isLive;
}
