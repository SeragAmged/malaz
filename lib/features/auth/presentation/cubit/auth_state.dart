import 'package:freezed_annotation/freezed_annotation.dart';

import '../../domain/entities/user.dart';

part 'auth_state.freezed.dart';

enum AuthStatus { initial, authenticated, unauthenticated }

enum ScreenState { initial, passwordRecovery, signup, login }

enum UiState { initial, loading, success }

@freezed
abstract class AuthState with _$AuthState {
  const AuthState._();

  const factory AuthState({
    @Default(AuthStatus.initial) AuthStatus authStatus,
    @Default(UiState.initial) UiState uiState,
    @Default(ScreenState.initial) ScreenState screenState,
    User? user,
    String? errorMessage,
    @Default([]) List<String> avatarUrls,
    @Default(false) bool isLoadingAvatars,
    @Default(0) int selectedAvatarIndex,
  }) = _AuthState;

  bool get isInitial => authStatus == AuthStatus.initial;
  bool get isLoading => uiState == UiState.loading;
  bool get isAuthenticated => authStatus == AuthStatus.authenticated;
  bool get isUnauthenticated => authStatus == AuthStatus.unauthenticated;
  bool get isPasswordRecovery => screenState == ScreenState.passwordRecovery;
  bool get hasError => errorMessage != null && errorMessage!.isNotEmpty;
}
