import '../../domain/entities/room.dart';

enum RoomsStatus { initial, loading, success, failure }

enum CreateRoomStatus { idle, creating, createSuccess, createFailure }

class RoomsState {
  const RoomsState({
    this.status = RoomsStatus.initial,
    this.rooms = const [],
    this.errorMessage,
    this.currentPage = 0,
    this.hasMore = true,
    this.isLoadingMore = false,
    this.createStatus = CreateRoomStatus.idle,
    this.createErrorMessage,
  });

  final RoomsStatus status;
  final List<Room> rooms;
  final String? errorMessage;
  final int currentPage;
  final bool hasMore;
  final bool isLoadingMore;
  final CreateRoomStatus createStatus;
  final String? createErrorMessage;

  bool get isInitial => status == RoomsStatus.initial;
  bool get isLoading => status == RoomsStatus.loading;
  bool get isSuccess => status == RoomsStatus.success;
  bool get isFailure => status == RoomsStatus.failure;

  RoomsState copyWith({
    RoomsStatus? status,
    List<Room>? rooms,
    String? errorMessage,
    int? currentPage,
    bool? hasMore,
    bool? isLoadingMore,
    CreateRoomStatus? createStatus,
    String? createErrorMessage,
  }) {
    return RoomsState(
      status: status ?? this.status,
      rooms: rooms ?? this.rooms,
      errorMessage: errorMessage ?? this.errorMessage,
      currentPage: currentPage ?? this.currentPage,
      hasMore: hasMore ?? this.hasMore,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      createStatus: createStatus ?? this.createStatus,
      createErrorMessage: createErrorMessage ?? this.createErrorMessage,
    );
  }
}
