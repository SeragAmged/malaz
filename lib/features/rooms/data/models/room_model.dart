import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:malaz/features/rooms/domain/entities/enums.dart';
import 'package:malaz/features/rooms/domain/entities/room.dart';

part 'room_model.freezed.dart';
part 'room_model.g.dart';

@freezed
abstract class RoomModel with _$RoomModel {
  const RoomModel._();

  const factory RoomModel({
    required String id,
    required String name,
    String? description,
    @JsonKey(name: 'background_url') String? backgroundUrl,
    required String type,
    required String color,
    @JsonKey(name: 'members_avatars', defaultValue: []) required List<String?>? membersAvatars,
    @JsonKey(name: 'active_members') required int activeMembers,
    @JsonKey(name: 'max_members') required int maxMembers,
    @JsonKey(name: 'is_protected') required bool isProtected,
    @JsonKey(name: 'session_type') SessionType? sessionType,
    @JsonKey(name: 'planned_minutes') int? plannedMinutes,
    @JsonKey(name: 'paused_at') DateTime? pausedAt,
    @JsonKey(name: 'session_started_at') DateTime? sessionStartedAt,
    @JsonKey(name: 'is_member') required bool isMember,
  }) = _RoomModel;

  factory RoomModel.fromJson(Map<String, dynamic> json) =>
      _$RoomModelFromJson(json);

  Room toEntity() {
    return Room(
      id: id,
      name: name,
      type: type ,
      color: color,
      membersAvatars: membersAvatars??[] ,
      activeMembers: activeMembers ,
      maxMembers: maxMembers ,
      isProtected: isProtected,
      backgroundUrl: backgroundUrl,
      description: description,
      sessionType: sessionType,
      plannedMinutes: plannedMinutes,
      pausedAt: pausedAt,
      sessionStartedAt: sessionStartedAt,
      isMember: isMember,
    );
  }
}
