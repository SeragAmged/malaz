import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';
import 'package:malaz/core/di/providers.config.dart';

final getIt = GetIt.instance;
@InjectableInit()
Future<void> configureDependencies({required String env}) async =>
    getIt.init(environment: env);
