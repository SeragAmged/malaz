class RoomModel {
  const RoomModel({
    required this.id,
    required this.name,
    required this.theme,
    required this.currentUsers,
    required this.capacity,
    required this.focusMinutes,
    required this.isLive,
  });

  factory RoomModel.fromJson(Map<String, dynamic> json) {
    return RoomModel(
      id: json['id'] as String,
      name: json['name'] as String,
      theme: json['theme'] as String,
      currentUsers: json['current_users'] as int,
      capacity: json['capacity'] as int,
      focusMinutes: json['focus_minutes'] as int,
      isLive: json['is_live'] as bool,
    );
  }

  final String id;
  final String name;
  final String theme;
  final int currentUsers;
  final int capacity;
  final int focusMinutes;
  final bool isLive;

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'theme': theme,
      'current_users': currentUsers,
      'capacity': capacity,
      'focus_minutes': focusMinutes,
      'is_live': isLive,
    };
  }
}
