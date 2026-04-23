import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/room_member_with_session.dart';

part 'room_member_with_session_model.freezed.dart';
part 'room_member_with_session_model.g.dart';

@freezed
abstract class RoomMemberWithSessionModel with _$RoomMemberWithSessionModel {
  const RoomMemberWithSessionModel._();

  const factory RoomMemberWithSessionModel({
    @JsonKey(name: 'user_id') required String userId,
    @JsonKey(name: 'full_name') required String fullName,
    @JsonKey(name: 'avatar_url') String? avatarUrl,
    required String status,
    @JsonKey(name: 'last_checkin_at') required DateTime lastCheckinAt,
    @JsonKey(name: 'completed_focus_seconds') required int completedFocusSeconds,
    @JsonKey(name: 'session_id') String? sessionId,
    @JsonKey(name: 'session_type') String? sessionType,
    @JsonKey(name: 'started_at') DateTime? startedAt,
    @JsonKey(name: 'planned_minutes') int? plannedMinutes,
    @JsonKey(name: 'paused_at') DateTime? pausedAt,
    @JsonKey(name: 'total_paused_seconds') int? totalPausedSeconds,
  }) = _RoomMemberWithSessionModel;

  factory RoomMemberWithSessionModel.fromJson(Map<String, dynamic> json) =>
      _$RoomMemberWithSessionModelFromJson(json);

  RoomMemberWithSession toEntity() => RoomMemberWithSession(
    userId: userId,
    fullName: fullName,
    avatarUrl: avatarUrl,
    status: status,
    lastCheckinAt: lastCheckinAt,
    completedFocusSeconds: completedFocusSeconds,
    sessionId: sessionId,
    sessionType: sessionType,
    startedAt: startedAt,
    plannedMinutes: plannedMinutes,
    pausedAt: pausedAt,
    totalPausedSeconds: totalPausedSeconds,
  );
}
