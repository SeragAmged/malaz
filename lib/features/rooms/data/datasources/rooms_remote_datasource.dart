import '../../../../core/util/errors/domain_errors.dart';
import '../../../../core/util/result.dart';
import '../models/room_model.dart';

abstract interface class RoomsRemoteDataSource {
  Future<Result<List<RoomModel>, DomainError>> fetchRooms();
}

class DemoRoomsRemoteDataSource implements RoomsRemoteDataSource {
  @override
  Future<Result<List<RoomModel>, DomainError>> fetchRooms() async {
    await Future<void>.delayed(const Duration(milliseconds: 250));

    return const Success([
      RoomModel(
        id: 'deep-work',
        name: 'Deep Work Club',
        theme: 'Quiet focus',
        currentUsers: 18,
        capacity: 24,
        focusMinutes: 50,
        isLive: true,
      ),
      RoomModel(
        id: 'study-sprint',
        name: 'Study Sprint',
        theme: 'Exam prep',
        currentUsers: 11,
        capacity: 20,
        focusMinutes: 25,
        isLive: true,
      ),
      RoomModel(
        id: 'creative-lab',
        name: 'Creative Lab',
        theme: 'Sketch and ship',
        currentUsers: 7,
        capacity: 16,
        focusMinutes: 40,
        isLive: false,
      ),
    ]);
  }
}
