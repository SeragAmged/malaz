import 'package:injectable/injectable.dart';
import 'package:malaz/core/router/app_router.dart';
import 'package:malaz/features/auth/domain/entities/auth_state_event.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../core/util/errors/domain_errors.dart';
import 'models/user_model.dart';
import '../domain/entities/user.dart' as app_user;

/// Implementation of AuthRemoteDataSource using Supabase
@lazySingleton
class AuthRemoteDataSourceImpl {
  final SupabaseClient _supabaseClient;

  AuthRemoteDataSourceImpl(this._supabaseClient);

  Future<void> signUp({
    required String email,
    required String password,
    String? fullName,
    String? avatarUrl,
  }) async {
    try {
      // Validate passwords match
      if (password.length < 6) {
        throw const WeakPasswordError(
          message: 'Password must be at least 6 characters',
        );
      }

      // Sign up with Supabase Auth
      final authResponse = await _supabaseClient.auth.signUp(
        email: email,
        password: password,
        data: {'full_name': fullName, 'avatar_url': avatarUrl},
      );

      final user = authResponse.user;
      if (user == null) {
        throw const AuthError(message: 'Failed to create user');
      }

      // return signIn(email: email, password: password);
    } on AuthException catch (e) {
      if (e.statusCode == '422') {
        throw const EmailAlreadyExistsError(message: 'Email already exists');
      }
      throw AuthError(message: e.message);
    } catch (e) {
      throw AuthError(message: e.toString());
    }
  }

  Future<UserModel> signIn({
    required String email,
    required String password,
  }) async {
    try {
      final authResponse = await _supabaseClient.auth.signInWithPassword(
        email: email,
        password: password,
      );

      final user = authResponse.user;
      if (user == null) {
        throw const AuthError(message: 'Failed to sign in');
      }

      // Fetch user profile from database
      final response = await _supabaseClient
          .from('users')
          .select()
          .eq('id', user.id)
          .single();

      return UserModel.fromJson(response);
    } on AuthException {
      throw const InvalidCredentialsError(message: 'Invalid email or password');
    } catch (e) {
      throw AuthError(message: e.toString());
    }
  }

  Future<void> signOut() async {
    try {
      await _supabaseClient.auth.signOut();
    } catch (e) {
      throw AuthError(message: e.toString());
    }
  }

  Future<UserModel?> getCurrentUser() async {
    try {
      final user = _supabaseClient.auth.currentUser;
      if (user == null) return null;

      final response = await _supabaseClient
          .from('users')
          .select()
          .eq('id', user.id)
          .single();

      return UserModel.fromJson(response);
    } catch (e) {
      return null;
    }
  }

  Future<bool> isAuthenticated() async {
    try {
      return _supabaseClient.auth.currentUser != null;
    } catch (e) {
      return false;
    }
  }

  Future<String> getAvatarUrl(String avatarId) async {
    try {
      final response = _supabaseClient.storage
          .from('avatars')
          .getPublicUrl(avatarId);
      return response;
    } catch (e) {
      throw AuthError(message: 'Failed to get avatar URL: $e');
    }
  }

  Stream<AuthStateEvent> watchAuthState() {
    return _supabaseClient.auth.onAuthStateChange.map((data) {
      final event = data.event;
      final session = data.session;

      final user = _mapUser(session);

      return switch (event) {
        AuthChangeEvent.signedIn => AuthStateEvent(
          AuthEventType.authenticated,
          user: user,
        ),

        AuthChangeEvent.signedOut => AuthStateEvent(
          AuthEventType.unauthenticated,
        ),

        AuthChangeEvent.passwordRecovery => AuthStateEvent(
          AuthEventType.passwordRecovery,
          user: user,
        ),

        _ => AuthStateEvent(
          session?.user != null
              ? AuthEventType.authenticated
              : AuthEventType.unauthenticated,
          user: user,
        ),
      };
    });
  }

  Future<void> sendPasswordReset({required String email}) async {
    await _supabaseClient.auth.resetPasswordForEmail(
      email,
      redirectTo: 'https://malaz.com/${AppRouter.resetPassword}',
    );
  }

  Future<void> resetPassword({required String newPassword}) async {
    final user = _supabaseClient.auth.currentUser;
    if (user == null) {
      throw Exception('No authenticated user for password recovery');
    }
    await _supabaseClient.auth.updateUser(
      UserAttributes(password: newPassword),
    );
  }

  Future<List<String>> loadAvatarUrls() async {
    try {
      final files = await _supabaseClient.storage.from('ready avatars').list();

      final List<String> avatarUrls = [];
      for (final file in files) {
        try {
          final url = _supabaseClient.storage
              .from('ready avatars')
              .getPublicUrl(file.name);
          avatarUrls.add(url);
        } catch (e) {
          throw AvatarLoadError(
            message: 'Error getting URL for ${file.name}: $e',
          );
        }
      }

      return avatarUrls;
    } catch (e) {
      throw AvatarLoadError(message: 'Failed to load avatars: $e');
    }
  }

  app_user.User? _mapUser(Session? session) {
    final json = session?.user.toJson();
    if (json == null) return null;

    return UserModel.fromJson(json).toEntity();
  }
}
