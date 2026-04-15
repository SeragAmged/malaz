import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../domain/repositories/rooms_repository.dart';
import 'rooms_state.dart';

@injectable
class RoomsCubit extends Cubit<RoomsState> {
  RoomsCubit(this._repository) : super(const RoomsState());

  final RoomsRepository _repository;
  static const int _pageSize = 20;

  Future<void> fetchRooms() async {
    emit(state.copyWith(status: RoomsStatus.loading));
    final result = await _repository.getRooms(1, _pageSize);
    result.fold(
      onSuccess: (rooms) => emit(
        state.copyWith(
          status: RoomsStatus.success,
          rooms: rooms,
          currentPage: 1,
          hasMore: rooms.length >= _pageSize,
          isLoadingMore: false,
        ),
      ),
      onFailure: (error, data) => emit(
        state.copyWith(
          status: RoomsStatus.failure,
          errorMessage: error.message ?? 'Failed to fetch rooms.',
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
    // Reset to idle first so re-submissions after failure work correctly
    emit(state.copyWith(createStatus: CreateRoomStatus.idle));
    emit(state.copyWith(createStatus: CreateRoomStatus.creating));

    final result = await _repository.createRoom(
      name: name,
      type: type,
      theme: color,
      capacity: 10,
      password: password,
    );

    result.fold(
      onSuccess: (_) => emit(
        state.copyWith(createStatus: CreateRoomStatus.createSuccess),
      ),
      onFailure: (error, _) => emit(
        state.copyWith(
          createStatus: CreateRoomStatus.createFailure,
          createErrorMessage: error.message ?? 'Failed to create room.',
        ),
      ),
    );
  }

  Future<void> loadMoreRooms() async {
    // Guard against concurrent loads or if no more pages
    if (state.isLoadingMore || !state.hasMore || state.status != RoomsStatus.success) {
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
            status: RoomsStatus.failure,
            errorMessage: error.message ?? 'Failed to load more rooms.',
          ),
        );
      },
    );
  }
}
