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
import 'package:malaz/features/rooms/data/datasources/room_members_data_source.dart'
    as _i573;
import 'package:malaz/features/rooms/data/datasources/rooms_remote_datasource.dart'
    as _i479;
import 'package:malaz/features/rooms/data/datasources/session_remote_datasource.dart'
    as _i744;
import 'package:malaz/features/rooms/data/repositories/presence_repository_impl.dart'
    as _i477;
import 'package:malaz/features/rooms/data/repositories/room_members_repository_impl.dart'
    as _i909;
import 'package:malaz/features/rooms/data/repositories/rooms_repository_impl.dart'
    as _i1064;
import 'package:malaz/features/rooms/data/repositories/session_repository_impl.dart'
    as _i865;
import 'package:malaz/features/rooms/domain/repositories/presence_repository.dart'
    as _i590;
import 'package:malaz/features/rooms/domain/repositories/room_members_repository.dart'
    as _i1062;
import 'package:malaz/features/rooms/domain/repositories/rooms_repository.dart'
    as _i850;
import 'package:malaz/features/rooms/domain/repositories/session_repository.dart'
    as _i23;
import 'package:malaz/features/rooms/presentation/cubit/room_members/room_members_cubit.dart'
    as _i728;
import 'package:malaz/features/rooms/presentation/cubit/rooms/rooms_cubit.dart'
    as _i62;
import 'package:malaz/features/rooms/presentation/cubit/timer/timer_cubit.dart'
    as _i185;
import 'package:malaz/features/statistics/data/statistics_remote_datasource.dart'
    as _i977;
import 'package:malaz/features/statistics/data/statistics_repository_impl.dart'
    as _i542;
import 'package:malaz/features/statistics/domain/repositories/statistics_repository.dart'
    as _i778;
import 'package:malaz/features/statistics/presentation/cubit/statistics_cubit.dart'
    as _i1065;
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
    gh.factory<_i977.StatisticsRemoteDataSource>(
      () =>
          _i977.StatisticsRemoteDataSource(client: gh<_i454.SupabaseClient>()),
    );
    gh.factory<_i529.PresenceRemoteDataSource>(
      () =>
          _i529.PresenceRemoteDataSource(supabase: gh<_i454.SupabaseClient>()),
    );
    gh.factory<_i573.RoomMembersDataSource>(
      () => _i573.RoomMembersDataSource(supabase: gh<_i454.SupabaseClient>()),
    );
    gh.factory<_i479.RoomsRemoteDataSource>(
      () => _i479.RoomsRemoteDataSource(supabase: gh<_i454.SupabaseClient>()),
    );
    gh.factory<_i744.SessionRemoteDataSource>(
      () => _i744.SessionRemoteDataSource(supabase: gh<_i454.SupabaseClient>()),
    );
    gh.factory<_i850.RoomsRepository>(
      () =>
          _i1064.RoomsRepositoryImpl(remote: gh<_i479.RoomsRemoteDataSource>()),
    );
    gh.lazySingleton<_i121.AuthRemoteDataSourceImpl>(
      () => _i121.AuthRemoteDataSourceImpl(gh<_i454.SupabaseClient>()),
    );
    gh.factory<_i62.RoomsCubit>(
      () => _i62.RoomsCubit(gh<_i850.RoomsRepository>()),
    );
    gh.factory<_i778.StatisticsRepository>(
      () => _i542.StatisticsRepositoryImpl(
        remote: gh<_i977.StatisticsRemoteDataSource>(),
      ),
    );
    gh.lazySingleton<_i146.AuthRepository>(
      () => _i484.AuthRepositoryImpl(gh<_i121.AuthRemoteDataSourceImpl>()),
    );
    gh.factory<_i590.PresenceRepository>(
      () => _i477.PresenceRepositoryImpl(gh<_i529.PresenceRemoteDataSource>()),
    );
    gh.factory<_i23.SessionRepository>(
      () => _i865.SessionRepositoryImpl(gh<_i744.SessionRemoteDataSource>()),
    );
    gh.factory<_i1062.RoomMembersRepository>(
      () => _i909.RoomMembersRepositoryImpl(
        datasource: gh<_i573.RoomMembersDataSource>(),
      ),
    );
    gh.factoryParam<_i185.TimerCubit, String, dynamic>(
      (roomId, _) => registerModule.timerCubit(
        roomId,
        gh<_i23.SessionRepository>(),
        gh<_i590.PresenceRepository>(),
      ),
    );
    gh.factory<_i1065.StatisticsCubit>(
      () => _i1065.StatisticsCubit(gh<_i778.StatisticsRepository>()),
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
    gh.factoryParam<_i728.RoomMembersCubit, String, dynamic>(
      (roomId, _) => registerModule.roomMembersCubit(
        roomId,
        gh<_i1062.RoomMembersRepository>(),
      ),
    );
    return this;
  }
}

class _$RegisterModule extends _i642.RegisterModule {}
