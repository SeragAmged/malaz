import '../../domain/entities/room.dart';

sealed class RoomsState {
  const RoomsState();
}

final class RoomsInitial extends RoomsState {
  const RoomsInitial();
}

final class RoomsLoading extends RoomsState {
  const RoomsLoading();
}

final class RoomsSuccess extends RoomsState {
  const RoomsSuccess(this.rooms);

  final List<Room> rooms;
}

final class RoomsFailure extends RoomsState {
  const RoomsFailure(this.message);

  final String message;
}
