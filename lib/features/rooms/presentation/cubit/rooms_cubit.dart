import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/repositories/rooms_repository.dart';
import 'rooms_state.dart';

class RoomsCubit extends Cubit<RoomsState> {
  RoomsCubit({required RoomsRepository repository})
    : _repository = repository,
      super(const RoomsInitial());

  final RoomsRepository _repository;

  Future<void> fetchRooms() async {
    emit(const RoomsLoading());
    throw UnimplementedError(
      'TODO: implement RoomsCubit.fetchRooms() using $_repository.',
    );
  }
}
