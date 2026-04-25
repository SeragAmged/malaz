
import 'package:malaz/features/rooms/domain/entities/enums.dart';

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
  final List<String?> membersAvatars;
  final int activeMembers;
  final int maxMembers;
  final bool isProtected;
  final SessionType? sessionType;
  final int? plannedMinutes;
  final DateTime? pausedAt;
  final DateTime? sessionStartedAt;
  final bool isMember;
}
