// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'room_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_RoomModel _$RoomModelFromJson(Map<String, dynamic> json) => _RoomModel(
  id: json['id'] as String,
  name: json['name'] as String,
  description: json['description'] as String?,
  backgroundUrl: json['background_url'] as String?,
  type: json['type'] as String,
  color: json['color'] as String,
  membersAvatars:
      (json['members_avatars'] as List<dynamic>?)
          ?.map((e) => e as String?)
          .toList() ??
      [],
  activeMembers: (json['active_members'] as num).toInt(),
  maxMembers: (json['max_members'] as num).toInt(),
  isProtected: json['is_protected'] as bool,
  sessionType: $enumDecodeNullable(_$SessionTypeEnumMap, json['session_type']),
  plannedMinutes: (json['planned_minutes'] as num?)?.toInt(),
  pausedAt: json['paused_at'] == null
      ? null
      : DateTime.parse(json['paused_at'] as String),
  sessionStartedAt: json['session_started_at'] == null
      ? null
      : DateTime.parse(json['session_started_at'] as String),
  isMember: json['is_member'] as bool,
);

Map<String, dynamic> _$RoomModelToJson(_RoomModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'description': instance.description,
      'background_url': instance.backgroundUrl,
      'type': instance.type,
      'color': instance.color,
      'members_avatars': instance.membersAvatars,
      'active_members': instance.activeMembers,
      'max_members': instance.maxMembers,
      'is_protected': instance.isProtected,
      'session_type': _$SessionTypeEnumMap[instance.sessionType],
      'planned_minutes': instance.plannedMinutes,
      'paused_at': instance.pausedAt?.toIso8601String(),
      'session_started_at': instance.sessionStartedAt?.toIso8601String(),
      'is_member': instance.isMember,
    };

const _$SessionTypeEnumMap = {
  SessionType.focus: 'focus',
  SessionType.breakTime: 'breakTime',
};
