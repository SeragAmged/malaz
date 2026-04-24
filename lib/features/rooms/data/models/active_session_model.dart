import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:malaz/features/rooms/domain/entities/enums.dart';

import '../../domain/entities/active_session.dart';

part 'active_session_model.freezed.dart';
part 'active_session_model.g.dart';

@freezed
abstract class ActiveSessionModel with _$ActiveSessionModel {
  const ActiveSessionModel._();

  const factory ActiveSessionModel({
    @JsonKey(name: "session_id") required String sessionId,
    @JsonKey(name: "session_type") required SessionType sessionType,
    @JsonKey(name: "started_at") required DateTime startedAt,
    @JsonKey(name: "planned_minutes") required int plannedMinutes,
    // @JsonKey(name: "status") required String status,
    @JsonKey(name: "total_paused_seconds") required int totalPausedSeconds,
    @JsonKey(name: "paused_at") DateTime? pausedAt,
  }) = _ActiveSessionModel;

  factory ActiveSessionModel.fromJson(Map<String, dynamic> json) =>
      _$ActiveSessionModelFromJson(json);

  ActiveSession toEntity() => ActiveSession(
    sessionId: sessionId,
    sessionType: sessionType,
    startedAt: startedAt,
    plannedMinutes: plannedMinutes,
    // status: status,
    totalPausedSeconds: totalPausedSeconds,
    pausedAt: pausedAt,
  );
}
