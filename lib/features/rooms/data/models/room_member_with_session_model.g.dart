// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'room_member_with_session_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_RoomMemberWithSessionModel _$RoomMemberWithSessionModelFromJson(
  Map<String, dynamic> json,
) => _RoomMemberWithSessionModel(
  userId: json['user_id'] as String,
  fullName: json['full_name'] as String,
  avatarUrl: json['avatar_url'] as String?,
  status: $enumDecode(_$MemberStatusEnumMap, json['status']),
  lastCheckinAt: DateTime.parse(json['last_checkin_at'] as String),
  completedFocusSeconds: (json['completed_focus_seconds'] as num).toInt(),
  sessionId: json['session_id'] as String?,
  sessionType: $enumDecodeNullable(_$SessionTypeEnumMap, json['session_type']),
  startedAt: json['started_at'] == null
      ? null
      : DateTime.parse(json['started_at'] as String),
  plannedMinutes: (json['planned_minutes'] as num?)?.toInt(),
  pausedAt: json['paused_at'] == null
      ? null
      : DateTime.parse(json['paused_at'] as String),
  totalPausedSeconds: (json['total_paused_seconds'] as num?)?.toInt(),
);

Map<String, dynamic> _$RoomMemberWithSessionModelToJson(
  _RoomMemberWithSessionModel instance,
) => <String, dynamic>{
  'user_id': instance.userId,
  'full_name': instance.fullName,
  'avatar_url': instance.avatarUrl,
  'status': _$MemberStatusEnumMap[instance.status]!,
  'last_checkin_at': instance.lastCheckinAt.toIso8601String(),
  'completed_focus_seconds': instance.completedFocusSeconds,
  'session_id': instance.sessionId,
  'session_type': _$SessionTypeEnumMap[instance.sessionType],
  'started_at': instance.startedAt?.toIso8601String(),
  'planned_minutes': instance.plannedMinutes,
  'paused_at': instance.pausedAt?.toIso8601String(),
  'total_paused_seconds': instance.totalPausedSeconds,
};

const _$MemberStatusEnumMap = {
  MemberStatus.online: 'online',
  MemberStatus.working: 'working',
  MemberStatus.onBreak: 'onBreak',
  MemberStatus.idle: 'idle',
  MemberStatus.offline: 'offline',
};

const _$SessionTypeEnumMap = {
  SessionType.focus: 'focus',
  SessionType.breakTime: 'breakTime',
};
