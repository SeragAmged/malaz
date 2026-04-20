import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:malaz/core/util/errors/domain_errors.dart';
import 'package:malaz/features/rooms/domain/entities/room.dart';
import '../../domain/rooms_repository.dart';
import 'rooms_state.dart';

@injectable
class RoomsCubit extends Cubit<RoomsState> {
  RoomsCubit(this._repository) : super(const RoomsState());

  final RoomsRepository _repository;
  static const int _pageSize = 20;

  Future<void> fetchRooms({bool forceRefresh = false}) async {
    if (forceRefresh) {
      emit(const RoomsState());
    }
    if (state.isLoading) {
      return;
    }
    emit(state.copyWith(status: UiStatus.loading));
    final result = await _repository.getRooms(1, _pageSize);
    result.fold(
      onSuccess: (rooms) => emit(
        state.copyWith(
          status: UiStatus.success,
          rooms: rooms,
          currentPage: 1,
          hasMore: rooms.length >= _pageSize,
          isLoadingMore: false,
        ),
      ),
      onFailure: (error, data) => emit(
        state.copyWith(
          status: UiStatus.failure,
          errorMessage: error.message ?? 'Failed to fetch rooms.',
        ),
      ),
    );
  }

  Future<void> loadMoreRooms() async {
    // Guard against concurrent loads or if no more pages
    if (state.isLoadingMore ||
        !state.hasMore ||
        state.status != UiStatus.success) {
      return;
    }

    emit(state.copyWith(isLoadingMore: true));
    final nextPage = state.currentPage + 1;
    final result = await _repository.getRooms(nextPage, _pageSize);

    result.fold(
      onSuccess: (newRooms) {
        emit(
          state.copyWith(
            rooms: [...state.rooms, ...newRooms],
            currentPage: nextPage,
            hasMore: newRooms.length >= _pageSize,
            isLoadingMore: false,
          ),
        );
      },
      onFailure: (error, data) {
        emit(
          state.copyWith(
            isLoadingMore: false,
            status: UiStatus.failure,
            errorMessage: error.message ?? 'Failed to load more rooms.',
          ),
        );
      },
    );
  }

  Future<void> fetchNewRoom(String roomId) async {
    final result = await _repository.getRoom(roomId);
    result.fold(
      onSuccess: (Room room) =>
          emit(state.copyWith(rooms: state.rooms..insert(0, room))),
      onFailure: (error, data) => emit(
        state.copyWith(
          status: UiStatus.failure,
          errorMessage: error.message ?? 'Failed to fetch room.',
        ),
      ),
    );
  }

  Future<void> createRoom({
    required String name,
    required String type,
    required String color,
    required bool isPrivate,
    String? password,
  }) async {
    if (state.isCreating) return;
    emit(state.copyWith(createStatus: UiStatus.loading));

    if (!state.rooms.first.isMember) {
      emit(
        state.copyWith(
          createStatus: UiStatus.failure,
          createError: AlreadyInRoom(message: 'Already in room'),
        ),
      );
      return;
    }

    final result = await _repository.createRoom(
      name: name,
      type: type,
      color: color,
      password: password,
    );
    result.fold(
      onSuccess: (newRoomId) {
        emit(
          state.copyWith(createStatus: UiStatus.success, newRoomId: newRoomId),
        );
        if (state.rooms.first.isMember) {
          _updateLeftRoom(state.rooms.first.id);
        }
        fetchNewRoom(newRoomId);
      },
      onFailure: (error, _) {
        emit(
          state.copyWith(createStatus: UiStatus.failure, createError: error),
        );
      },
    );
  }

  Future<void> _updateLeftRoom(String roomId) async {
    final res = await _repository.getRoom(roomId);
    res.fold(
      onSuccess: (updatedRoom) {
        final updatedRooms = List.of(state.rooms);

        final freshIndex = updatedRooms.indexWhere((r) => r.id == roomId);
        if (freshIndex == -1) return;

        updatedRooms[freshIndex] = updatedRoom;

        emit(state.copyWith(rooms: updatedRooms));
      },
      onFailure: (error, _) {},
    );
  }

  Future<void> _updateJoinedRoom(String roomId) async {
    if (state.rooms.first.isMember) {
      _updateLeftRoom(state.rooms.first.id);
    }

    final res = await _repository.getRoom(roomId);
    res.fold(
      onSuccess: (updatedRoom) {
        final updatedRooms = List.of(state.rooms);
        final index = updatedRooms.indexWhere((r) => r.id == roomId);
        if (index == -1) return;
        updatedRooms.removeAt(index);
        updatedRooms.insert(0, updatedRoom);
        emit(state.copyWith(rooms: updatedRooms));
      },
      onFailure: (error, _) {},
    );
  }

  Future<void> leaveRoom() async {
    emit(state.copyWith(leaveRoomStatus: UiStatus.loading));
    final result = await _repository.leaveRoom();
    result.fold(
      onSuccess: (roomId) {
        emit(state.copyWith(leaveRoomStatus: UiStatus.success));
        _updateLeftRoom(roomId);
      },

      onFailure: (error, _) => emit(
        state.copyWith(
          leaveRoomStatus: UiStatus.failure,
          leaveRoomError: error,
        ),
      ),
    );
  }

  Future<void> joinRoom(String roomId, String? password) async {
    if (state.isJoining) return;
    emit(state.copyWith(joinStatus: UiStatus.loading, joinedRoomId: roomId));

    final isMember = state.rooms.any(
      (room) => room.id == roomId && room.isMember,
    );
    if (isMember) {
      emit(state.copyWith(joinStatus: UiStatus.success, joinedRoomId: roomId));
      return;
    } else {
      emit(
        state.copyWith(
          joinStatus: UiStatus.failure,
          joinError: AlreadyInRoom(message: 'Already in room '),
        ),
      );
      return;
    }

    final result = await _repository.joinRoom(
      roomId: roomId,
      password: password,
    );

    result.fold(
      onSuccess: (_) {
        emit(
          state.copyWith(joinStatus: UiStatus.success, joinedRoomId: roomId),
        );
        _updateJoinedRoom(roomId);
      },
      onFailure: (error, _) =>
          emit(state.copyWith(joinStatus: UiStatus.failure, joinError: error)),
    );
  }

  void resetStatuses() {
    emit(
      state.copyWith(
        createStatus: UiStatus.initial,
        leaveRoomStatus: UiStatus.initial,
        joinStatus: UiStatus.initial,
        clearCreateError: true,
        clearLeaveRoomError: true,
        clearJoinError: true,
      ),
    );
  }
}
