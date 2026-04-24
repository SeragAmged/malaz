// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'active_session_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ActiveSessionModel _$ActiveSessionModelFromJson(Map<String, dynamic> json) =>
    _ActiveSessionModel(
      sessionId: json['session_id'] as String,
      sessionType: $enumDecode(_$SessionTypeEnumMap, json['session_type']),
      startedAt: DateTime.parse(json['started_at'] as String),
      plannedMinutes: (json['planned_minutes'] as num).toInt(),
      totalPausedSeconds: (json['total_paused_seconds'] as num).toInt(),
      pausedAt: json['paused_at'] == null
          ? null
          : DateTime.parse(json['paused_at'] as String),
    );

Map<String, dynamic> _$ActiveSessionModelToJson(_ActiveSessionModel instance) =>
    <String, dynamic>{
      'session_id': instance.sessionId,
      'session_type': _$SessionTypeEnumMap[instance.sessionType]!,
      'started_at': instance.startedAt.toIso8601String(),
      'planned_minutes': instance.plannedMinutes,
      'total_paused_seconds': instance.totalPausedSeconds,
      'paused_at': instance.pausedAt?.toIso8601String(),
    };

const _$SessionTypeEnumMap = {
  SessionType.focus: 'focus',
  SessionType.breakTime: 'breakTime',
};
