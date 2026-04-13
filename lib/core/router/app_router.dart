import 'package:injectable/injectable.dart';
import 'package:go_router/go_router.dart';
import 'package:malaz/features/auth/presentation/pages/reset_password_page.dart';
import 'package:malaz/features/auth/presentation/pages/forgot_password_page.dart';
import 'package:malaz/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:malaz/features/auth/presentation/pages/signin_page.dart';
import 'package:malaz/features/auth/presentation/pages/signup_page.dart';
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

  // Keep legacy alias so old references still compile
  static const authGate = signIn;

  final SharedPreferences _sharedPreferences;
  final AuthCubit _authCubit;

  late final GoRouter router = GoRouter(
    initialLocation: root,
    refreshListenable: AuthRefreshListenable(_authCubit),
    redirect: (context, state) {
      // final hasSeenOnboarding =
      //     _sharedPreferences.getBool(AppConstants.onboardingSeenKey) ?? false;
      final location = state.matchedLocation;

      // Onboarding guard
      // if (!hasSeenOnboarding) {
      //   return location == onboarding ? null : onboarding;
      // }

      // Auth guard
      final authState = _authCubit.state;
      final isAuthenticated = authState.isAuthenticated;
      final isInRecovery = authState.isPasswordRecovery;

      const authRoutes = [signIn, signUp, forgotPassword, resetPassword];
      final isOnAuthRoute = authRoutes.contains(location);

      // Magic Link / Password Recovery guard
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
      GoRoute(path: root, redirect: (_, _) => signIn),
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
      GoRoute(path: signIn, builder: (_, _) => const SignInPage()),
      GoRoute(path: signUp, builder: (_, _) => const SignUpPage()),
      GoRoute(
        path: forgotPassword,
        builder: (_, _) => const ForgotPasswordPage(),
      ),
      GoRoute(
        path: resetPassword,
        builder: (context, state) {
          // Extract token from deep link query parameters
          final token = state.uri.queryParameters['token'];
          final type = state.uri.queryParameters['type'];

          // Store token in state if available (for Supabase recovery)
          if (token != null && type == 'recovery') {
            // The token will be automatically handled by Supabase
            // when updateUser is called
          }

          return const ResetPasswordPage();
        },
      ),
      GoRoute(path: rooms, builder: (_, _) => const RoomsPage()),
    ],
  );
}
