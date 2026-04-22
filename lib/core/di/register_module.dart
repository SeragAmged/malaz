import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:malaz/features/rooms/presentation/cubit/timer_cubit.dart';

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
    String roomId,
  ) =>
      TimerCubit(
        roomId: roomId,
        sessionRepository: getIt(),
        presenceRepository: getIt(),
      );
}
