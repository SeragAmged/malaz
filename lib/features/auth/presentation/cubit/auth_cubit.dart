import 'dart:async';
import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:malaz/features/auth/domain/entities/auth_state_event.dart';
import '../../domain/repositories/auth_repository.dart';
import 'auth_state.dart';

/// Cubit for managing authentication state

@lazySingleton
class AuthCubit extends Cubit<AuthState> {
  final AuthRepository _repository;

  AuthCubit(this._repository) : super(const AuthState()) {
    _init();
  }

  StreamSubscription<dynamic>? _authSub;
  @override
  Future<void> close() {
    _authSub?.cancel();
    return super.close();
  }

  void _init() {
    _authSub = _repository.watchAuthState().listen(
      (event) {
        log('Auth event: ${event.type}, user: ${event.user?.email}');
        switch (event.type) {
          case AuthEventType.authenticated:
            emit(
              AuthState(authStatus: AuthStatus.authenticated, user: event.user),
            );
            break;

          case AuthEventType.unauthenticated:
            emit(const AuthState(authStatus: AuthStatus.unauthenticated));
            break;

          case AuthEventType.passwordRecovery:
            emit(
              AuthState(
                screenState: ScreenState.passwordRecovery,
                user: event.user,
              ),
            );
            break;
        }
      },
      onError: (error) {
        emit(AuthState(errorMessage: error.toString()));
      },
    );
  }

  /// Check if user is authenticated on app start
  Future<void> _checkAuthStatus() async {
    final isAuthenticated = await _repository.isAuthenticated();
    if (isAuthenticated) {
      final result = await _repository.getCurrentUser();
      result.fold(
        onFailure: (error, _) => emit(
          state.copyWith(errorMessage: error.message ?? 'Unknown error'),
        ),
        onSuccess: (user) {
          if (user != null) {
            emit(
              state.copyWith(authStatus: AuthStatus.authenticated, user: user),
            );
          } else {
            emit(state.copyWith(authStatus: AuthStatus.unauthenticated));
          }
        },
      );
    } else {
      emit(state.copyWith(authStatus: AuthStatus.unauthenticated));
    }
  }

  /// Sign up with email and password
  Future<void> signUp({
    required String email,
    required String password,
    required String confirmPassword,
    String? fullName,
    String? avatarUrl,
  }) async {
    emit(state.copyWith(uiState: UiState.loading));
    log('Attempting sign up with email: $email');
    final res = await _repository.signUp(
      email: email,
      password: password,
      confirmPassword: confirmPassword,
      fullName: fullName,
      avatarUrl: avatarUrl,
    );
    res.fold(
      onSuccess: (_) => emit(state.copyWith(uiState: UiState.success)),
      onFailure: (error, _) {
        emit(
          state.copyWith(
            uiState: UiState.initial,
            errorMessage: error.message ?? 'Sign up failed',
          ),
        );
      },
    );
  }

  /// Sign in with email and password
  Future<void> signIn({required String email, required String password}) async {
    emit(state.copyWith(uiState: UiState.loading, user: state.user));

    final result = await _repository.signIn(email: email, password: password);

    result.fold(
      onFailure: (error, _) {
        final message = error.message ?? 'Sign in failed';
        emit(state.copyWith(errorMessage: message));
      },
      onSuccess: (user) => emit(
        state.copyWith(authStatus: AuthStatus.authenticated, user: user),
      ),
    );
  }

  /// Sign out
  Future<void> signOut() async {
    emit(state.copyWith(uiState: UiState.loading, user: state.user));

    final result = await _repository.signOut();

    result.fold(
      onFailure: (error, _) {
        final message = error.message ?? 'Sign out failed';
        emit(state.copyWith(errorMessage: message));
      },
      onSuccess: (_) => emit(state.copyWith(errorMessage: null)),
    );
  }

  Future<void> sendPasswordReset({required String email}) async {
    emit(state.copyWith(uiState: UiState.loading));
    final result = await _repository.sendPasswordReset(email: email);
    result.fold(
      onSuccess: (_) => emit(state.copyWith(uiState: UiState.success)),
      onFailure: (error, _) => emit(
        state.copyWith(
          uiState: UiState.initial,
          errorMessage: error.message ?? 'Failed to send reset email',
        ),
      ),
    );
  }

  Future<void> resetPassword({required String newPassword}) async {
    emit(state.copyWith(uiState: UiState.loading));
    final result = await _repository.resetPassword(newPassword: newPassword);
    result.fold(
      onSuccess: (_) => emit(state.copyWith(uiState: UiState.success)),
      onFailure: (error, _) => emit(
        state.copyWith(
          uiState: UiState.initial,
          errorMessage: error.message ?? 'Failed to reset password',
        ),
      ),
    );
  }

  /// Clear error state
  void clearError() {
    if (state.hasError) {
      emit(state.copyWith(errorMessage: null, uiState: UiState.initial));
    }
  }

  void resetSuccess() {
    emit(state.copyWith(uiState: UiState.initial));
  }

  /// Load avatar URLs from data layer
  Future<void> loadAvatarUrls() async {
    emit(state.copyWith(isLoadingAvatars: true));
    final result = await _repository.loadAvatarUrls();
    result.fold(
      onSuccess: (avatarUrls) {
        emit(state.copyWith(isLoadingAvatars: false, avatarUrls: avatarUrls));
      },
      onFailure: (error, _) {
        emit(
          state.copyWith(
            isLoadingAvatars: false,
            errorMessage: error.message ?? 'Failed to load avatars',
          ),
        );
      },
    );
  }

  /// Select an avatar by index
  void selectAvatar(int index) {
    if (index >= 0 && index < state.avatarUrls.length) {
      emit(state.copyWith(selectedAvatarIndex: index));
    }
  }

  Future<void> updateUserProfile({
    String? fullName,
    String? avatarUrl,
  }) async {
    emit(state.copyWith(uiState: UiState.loading, user: state.user));

    final result = await _repository.updateUserProfile(
      fullName: fullName,
      avatarUrl: avatarUrl,
    );

    result.fold(
      onFailure: (error, _) {
        emit(state.copyWith(
          uiState: UiState.initial,
          errorMessage: error.message ?? 'Failed to update profile',
          user: state.user,
        ));
      },
      onSuccess: (updatedUser) {
        emit(state.copyWith(
          uiState: UiState.success,
          user: updatedUser,
          errorMessage: null,
        ));
        // Reset to initial after brief success state
        Future.delayed(const Duration(milliseconds: 500), () {
          if (isClosed) return;
          emit(state.copyWith(uiState: UiState.initial));
        });
      },
    );
  }
}
