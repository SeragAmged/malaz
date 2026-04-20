import 'package:malaz/core/util/errors/domain_errors.dart';

import '../../domain/entities/room.dart';

enum UiStatus { initial, loading, success, failure }

class RoomsState {
  const RoomsState({
    this.status = UiStatus.initial,
    this.rooms = const [],
    this.errorMessage,
    this.currentPage = 0,
    this.hasMore = true,
    this.isLoadingMore = false,
    this.createStatus = UiStatus.initial,
    this.createError,
    this.newRoomId,
    this.leaveRoomStatus = UiStatus.initial,
    this.leaveRoomError,
    this.joinStatus = UiStatus.initial,
    this.joinError, this.joinedRoomId,
  });

  final UiStatus status;
  final List<Room> rooms;
  final String? errorMessage;
  final int currentPage;
  final bool hasMore;
  final bool isLoadingMore;
  final UiStatus createStatus;
  final String? newRoomId;
  final DomainError? createError;
  final UiStatus leaveRoomStatus;
  final DomainError? leaveRoomError;
  final UiStatus joinStatus;
  final DomainError? joinError;
  final String? joinedRoomId;

  bool get isInitial => status == UiStatus.initial;
  bool get isLoading => status == UiStatus.loading;
  bool get isSuccess => status == UiStatus.success;
  bool get isFailure => status == UiStatus.failure;
  bool get isCreating => createStatus == UiStatus.loading;
  bool get isCreateSuccess => createStatus == UiStatus.success;
  bool get isCreateFailure => createStatus == UiStatus.failure;

  bool get isLeaving => leaveRoomStatus == UiStatus.loading;
  bool get isLeaveSuccess => leaveRoomStatus == UiStatus.success;
  bool get isLeaveFailure => leaveRoomStatus == UiStatus.failure;

  bool get isJoining => joinStatus == UiStatus.loading;
  bool get isJoinSuccess => joinStatus == UiStatus.success;
  bool get isJoinFailure => joinStatus == UiStatus.failure;

  RoomsState copyWith({
    UiStatus? status,
    List<Room>? rooms,
    String? errorMessage,
    int? currentPage,
    bool? hasMore,
    bool? isLoadingMore,
    UiStatus? createStatus,
    String? newRoomId,
    DomainError? createError,
    UiStatus? leaveRoomStatus,
    DomainError? leaveRoomError,
    UiStatus? joinStatus,
    DomainError? joinError,
    bool clearCreateError = false,
    bool clearLeaveRoomError = false,
    bool clearJoinError = false,
    String? joinedRoomId,
  }) {
    return RoomsState(
      newRoomId: newRoomId ?? this.newRoomId,
      status: status ?? this.status,
      rooms: rooms ?? this.rooms,
      errorMessage: errorMessage ?? this.errorMessage,
      currentPage: currentPage ?? this.currentPage,
      hasMore: hasMore ?? this.hasMore,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      createStatus: createStatus ?? this.createStatus,
      createError: clearCreateError ? null : (createError ?? this.createError),
      leaveRoomError: clearLeaveRoomError ? null : (leaveRoomError ?? this.leaveRoomError),
      leaveRoomStatus: leaveRoomStatus ?? this.leaveRoomStatus,
      joinStatus: joinStatus ?? this.joinStatus,
      joinError: clearJoinError ? null : (joinError ?? this.joinError),
      joinedRoomId: joinedRoomId ?? this.joinedRoomId,
    );
  }
}
