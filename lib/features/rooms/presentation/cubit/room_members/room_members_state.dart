import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:malaz/features/rooms/domain/entities/room_member_with_session.dart';
import '../../../data/models/room_member_with_session_model.dart';

part 'room_members_state.freezed.dart';

@freezed
abstract class RoomMembersState with _$RoomMembersState {
  const factory RoomMembersState({
    @Default([]) List<RoomMemberWithSession> members,
    @Default(false) bool isLoading,
    String? errorMessage,
    DateTime? localNow,
    @Default({}) Set<String> pausedMemberIds,
  }) = _RoomMembersState;
}
