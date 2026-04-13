import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:malaz/core/di/providers.dart';
import 'package:malaz/core/router/app_router.dart';

import 'core/theme/app_theme.dart';
import 'features/auth/presentation/cubit/auth_cubit.dart';

class MalazApp extends StatelessWidget {
  const MalazApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(390, 844),
        minTextAdapt: true,
        splitScreenMode: true,
      
      builder: (context, child) => BlocProvider<AuthCubit>(
        create: (context) => getIt<AuthCubit>(),
        child: MaterialApp.router(
          title: 'Malaz',
          debugShowCheckedModeBanner: false,
          theme: AppTheme.darkTheme,
          routerConfig: getIt<AppRouter>().router,
        ),
      ),
    );
  }
}
