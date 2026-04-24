import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';
import 'package:malaz/features/rooms/domain/repositories/room_members_repository.dart';
import 'package:malaz/features/rooms/presentation/cubit/room_members/room_members_cubit.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:malaz/features/rooms/presentation/cubit/timer/timer_cubit.dart';
import 'package:malaz/features/rooms/domain/repositories/session_repository.dart';
import 'package:malaz/features/rooms/domain/repositories/presence_repository.dart';

final getIt = GetIt.instance;

@module
abstract class RegisterModule {
  @preResolve
  Future<SharedPreferences> get sharedPreferences =>
      SharedPreferences.getInstance();

  @lazySingleton
  SupabaseClient get supabaseClient => Supabase.instance.client;

  @injectable
  TimerCubit timerCubit(
    @factoryParam String roomId,
    SessionRepository sessionRepository,
    PresenceRepository presenceRepository,
  ) => TimerCubit(
    roomId: roomId,
    sessionRepository: sessionRepository,
    presenceRepository: presenceRepository,
  );

  @injectable
  RoomMembersCubit roomMembersCubit(
    @factoryParam String roomId,
    RoomMembersRepository repository,
  ) => RoomMembersCubit(roomId: roomId, repository: repository);
}
