import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';
import 'package:go_router/go_router.dart';
import 'package:malaz/features/auth/presentation/pages/reset_password_page.dart';
import 'package:malaz/features/auth/presentation/pages/forgot_password_page.dart';
import 'package:malaz/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:malaz/features/auth/presentation/pages/signin_page.dart';
import 'package:malaz/features/auth/presentation/pages/signup_page.dart';
import 'package:malaz/features/layout/layout_page.dart';
import 'package:malaz/features/rooms/presentation/pages/room_page.dart';
import 'package:malaz/features/rooms/presentation/pages/rooms_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'auth_refresh_listenable.dart';

@lazySingleton
class AppRouter {
  AppRouter({
    required SharedPreferences sharedPreferences,
    required AuthCubit authCubit,
  }) : _sharedPreferences = sharedPreferences,
       _authCubit = authCubit;

  static const root = '/';
  static const onboarding = '/onboarding';
  static const signIn = '/sign-in';
  static const signUp = '/sign-up';
  static const forgotPassword = '/forgot-password';
  static const resetPassword = '/reset-password';
  static const rooms = '/rooms';
  static const stats = '/stats';
  static const profile = '/profile';

  static int getScreenIndex(String location) {
    switch (true) {
      case true when location.startsWith(rooms):
        return 0;
      case true when location.startsWith(stats):
        return 1;
      case true when location.startsWith(profile):
        return 2;
      default:
        return 0;
    }
  }

  final SharedPreferences _sharedPreferences;
  final AuthCubit _authCubit;

  late final GoRouter router = GoRouter(
    initialLocation: root,
    refreshListenable: AuthRefreshListenable(_authCubit),
    redirect: (context, state) {
      final location = state.matchedLocation;

      // Onboarding guard

      // final hasSeenOnboarding =
      //     _sharedPreferences.getBool(AppConstants.onboardingSeenKey) ?? false;
      // if (!hasSeenOnboarding) {
      //   return location == onboarding ? null : onboarding;
      // }

      final authState = _authCubit.state;
      final isAuthenticated = authState.isAuthenticated;
      final isInRecovery = authState.isPasswordRecovery;

      const authRoutes = [signIn, signUp, forgotPassword, resetPassword];
      final isOnAuthRoute = authRoutes.contains(location);

      if (authState.isInitial) {
        return null;
      }

      // Password Recovery guard
      if (isInRecovery && location != resetPassword) {
        return resetPassword;
      }

      if (!isAuthenticated && !isOnAuthRoute && location != onboarding) {
        return signIn;
      }

      if (isAuthenticated && (isOnAuthRoute || location == root)) {
        return rooms;
      }

      return null;
    },
    routes: [
      // GoRoute(
      //   path: onboarding,
      //   builder: (context, state) {
      //     return OnboardingPage(
      //       onCompleted: () async {
      //         await _sharedPreferences.setBool(
      //           AppConstants.onboardingSeenKey,
      //           true,
      //         );
      //         if (context.mounted) {
      //           context.go(signIn);
      //         }
      //       },
      //     );
      //   },
      // ),
      GoRoute(path: root, redirect: (_, _) => rooms),
      GoRoute(path: signIn, builder: (_, _) => const SignInPage()),
      GoRoute(path: signUp, builder: (_, _) => const SignUpPage()),
      GoRoute(
        path: forgotPassword,
        builder: (_, _) => const ForgotPasswordPage(),
      ),
      GoRoute(
        path: resetPassword,
        builder: (context, state) => const ResetPasswordPage(),
      ),
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) {
          return LayoutPage(
            currentIndex: navigationShell.currentIndex,
            onTap: (index) => navigationShell.goBranch(index),
            child: navigationShell,
          );
        },
        branches: [
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: rooms,
                pageBuilder: (context, state) =>
                    const NoTransitionPage(child: RoomsPage()),
                routes: [
                  GoRoute(
                    path: ':id',
                    builder: (context, state) =>
                        RoomPage(roomId: state.pathParameters['id']!),
                  ),
                ],
              ),
            ],
          ),

          StatefulShellBranch(
            routes: [
              GoRoute(
                path: stats,
                pageBuilder: (context, state) => const NoTransitionPage(
                  child: TempScreen(title: 'Statistics'),
                ),
              ),
            ],
          ),

          StatefulShellBranch(
            routes: [
              GoRoute(
                path: profile,
                pageBuilder: (context, state) =>
                    const NoTransitionPage(child: TempScreen(title: 'Profile')),
              ),
            ],
          ),
        ],
      ),
    ],
  );
}

class TempScreen extends StatelessWidget {
  const TempScreen({super.key, required this.title});
  final String title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: SelectableText('TODO: Implement $title screen')),
    );
  }
}
