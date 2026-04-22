// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format width=80

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;
import 'package:malaz/core/di/register_module.dart' as _i642;
import 'package:malaz/core/router/app_router.dart' as _i724;
import 'package:malaz/features/auth/data/auth_remote_datasource_impl.dart'
    as _i121;
import 'package:malaz/features/auth/data/auth_repository_impl.dart' as _i484;
import 'package:malaz/features/auth/domain/repositories/auth_repository.dart'
    as _i146;
import 'package:malaz/features/auth/presentation/cubit/auth_cubit.dart'
    as _i281;
import 'package:malaz/features/rooms/data/datasources/presence_remote_datasource.dart'
    as _i529;
import 'package:malaz/features/rooms/data/datasources/session_remote_datasource.dart'
    as _i744;
import 'package:malaz/features/rooms/data/repositories/presence_repository_impl.dart'
    as _i477;
import 'package:malaz/features/rooms/data/repositories/session_repository_impl.dart'
    as _i865;
import 'package:malaz/features/rooms/data/rooms_remote_datasource.dart'
    as _i986;
import 'package:malaz/features/rooms/data/rooms_repository_impl.dart' as _i557;
import 'package:malaz/features/rooms/domain/repositories/presence_repository.dart'
    as _i590;
import 'package:malaz/features/rooms/domain/repositories/session_repository.dart'
    as _i23;
import 'package:malaz/features/rooms/domain/rooms_repository.dart' as _i756;
import 'package:malaz/features/rooms/presentation/cubit/rooms_cubit.dart'
    as _i235;
import 'package:malaz/features/rooms/presentation/cubit/timer_cubit.dart'
    as _i4;
import 'package:shared_preferences/shared_preferences.dart' as _i460;
import 'package:supabase_flutter/supabase_flutter.dart' as _i454;

extension GetItInjectableX on _i174.GetIt {
  // initializes the registration of main-scope dependencies inside of GetIt
  Future<_i174.GetIt> init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) async {
    final gh = _i526.GetItHelper(this, environment, environmentFilter);
    final registerModule = _$RegisterModule();
    await gh.factoryAsync<_i460.SharedPreferences>(
      () => registerModule.sharedPreferences,
      preResolve: true,
    );
    gh.lazySingleton<_i454.SupabaseClient>(() => registerModule.supabaseClient);
    gh.factory<_i529.PresenceRemoteDataSource>(
      () =>
          _i529.PresenceRemoteDataSource(supabase: gh<_i454.SupabaseClient>()),
    );
    gh.factory<_i744.SessionRemoteDataSource>(
      () => _i744.SessionRemoteDataSource(supabase: gh<_i454.SupabaseClient>()),
    );
    gh.factory<_i986.RoomsRemoteDataSource>(
      () => _i986.RoomsRemoteDataSource(supabase: gh<_i454.SupabaseClient>()),
    );
    gh.lazySingleton<_i121.AuthRemoteDataSourceImpl>(
      () => _i121.AuthRemoteDataSourceImpl(gh<_i454.SupabaseClient>()),
    );
    gh.lazySingleton<_i146.AuthRepository>(
      () => _i484.AuthRepositoryImpl(gh<_i121.AuthRemoteDataSourceImpl>()),
    );
    gh.factory<_i756.RoomsRepository>(
      () =>
          _i557.RoomsRepositoryImpl(remote: gh<_i986.RoomsRemoteDataSource>()),
    );
    gh.factory<_i235.RoomsCubit>(
      () => _i235.RoomsCubit(gh<_i756.RoomsRepository>()),
    );
    gh.factory<_i590.PresenceRepository>(
      () => _i477.PresenceRepositoryImpl(gh<_i529.PresenceRemoteDataSource>()),
    );
    gh.factory<_i23.SessionRepository>(
      () => _i865.SessionRepositoryImpl(gh<_i744.SessionRemoteDataSource>()),
    );
    gh.factoryParam<_i4.TimerCubit, String, dynamic>(
      (roomId, _) => registerModule.timerCubit(
        roomId,
        gh<_i23.SessionRepository>(),
        gh<_i590.PresenceRepository>(),
      ),
    );
    gh.lazySingleton<_i281.AuthCubit>(
      () => _i281.AuthCubit(gh<_i146.AuthRepository>()),
    );
    gh.lazySingleton<_i724.AppRouter>(
      () => _i724.AppRouter(
        sharedPreferences: gh<_i460.SharedPreferences>(),
        authCubit: gh<_i281.AuthCubit>(),
      ),
    );
    return this;
  }
}

class _$RegisterModule extends _i642.RegisterModule {}
