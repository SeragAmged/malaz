import 'package:injectable/injectable.dart';
import 'package:malaz/features/auth/data/auth_remote_datasource_impl.dart';
import 'package:malaz/features/auth/domain/entities/auth_state_event.dart';
import 'package:supabase_flutter/supabase_flutter.dart' as supabase;

import '../../../core/util/result.dart';
import '../../../core/util/errors/domain_errors.dart';
import '../domain/entities/user.dart';
import '../domain/repositories/auth_repository.dart';

/// Implementation of AuthRepository
///
@LazySingleton(as: AuthRepository)
class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSourceImpl _remoteDataSource;

  AuthRepositoryImpl(this._remoteDataSource);

  @override
  Future<Result<void, DomainError>> signUp({
    required String email,
    required String password,
    required String confirmPassword,
    String? fullName,
    String? avatarUrl,
  }) async {
    try {
      // Validate passwords match
      if (password != confirmPassword) {
        return Failure(const AuthError(message: 'Passwords do not match'));
      }

      await _remoteDataSource.signUp(
        email: email,
        password: password,
        fullName: fullName,
        avatarUrl: avatarUrl,
      );

      return Success(null);
    } on DomainError catch (e) {
      return Failure(e);
    } catch (e) {
      return Failure(AuthError(message: e.toString()));
    }
  }

  @override
  Future<Result<User, DomainError>> signIn({
    required String email,
    required String password,
  }) async {
    try {
      final userModel = await _remoteDataSource.signIn(
        email: email,
        password: password,
      );

      return Success(userModel.toEntity());
    } on DomainError catch (e) {
      return Failure(e);
    } catch (e) {
      return Failure(AuthError(message: e.toString()));
    }
  }

  @override
  Future<Result<void, DomainError>> signOut() async {
    try {
      await _remoteDataSource.signOut();
      return Success(null);
    } on DomainError catch (e) {
      return Failure(e);
    } catch (e) {
      return Failure(AuthError(message: e.toString()));
    }
  }

  @override
  Future<Result<User?, DomainError>> getCurrentUser() async {
    try {
      final userModel = await _remoteDataSource.getCurrentUser();
      return Success(userModel?.toEntity());
    } on DomainError catch (e) {
      return Failure(e);
    } catch (e) {
      return Failure(AuthError(message: e.toString()));
    }
  }

  @override
  Future<bool> isAuthenticated() {
    return _remoteDataSource.isAuthenticated();
  }

  @override
  Future<Result<void, DomainError>> resetPassword({
    required String newPassword,
  }) async {
    try {
      await _remoteDataSource.resetPassword(newPassword: newPassword);
      return Success(null);
    } catch (e) {
      return Failure(AuthError(message: e.toString()));
    }
  }

  @override
  Future<Result<void, DomainError>> sendPasswordReset({
    required String email,
  }) async {
    try {
      await _remoteDataSource.sendPasswordReset(email: email);
      return Success(null);
    } catch (e) {
      return Failure(AuthError(message: e.toString()));
    }
  }

  @override
  Stream<AuthStateEvent> watchAuthState() => _remoteDataSource.watchAuthState();

  @override
  Future<Result<List<String>, DomainError>> loadAvatarUrls() async {
    try {
      final avatarUrls = await _remoteDataSource.loadAvatarUrls();
      return Success(avatarUrls);
    } on AvatarLoadError catch (e) {
      return Failure(e);
    } catch (e) {
      return Failure(AvatarLoadError(message: e.toString()));
    }
  }

  @override
  Future<Result<User, DomainError>> updateUserProfile({
    String? fullName,
    String? avatarUrl,
  }) async {
    try {
      final supabaseClient = supabase.Supabase.instance.client;
      final response = await supabaseClient.rpc(
        'update_user_profile',
        params: {
          'full_name': fullName,
          'avatar_url': avatarUrl,
        },
      ) as Map<String, dynamic>;

      final user = User(
        id: response['id'] ?? '',
        email: response['email'] ?? '',
        fullName: response['full_name'],
        avatarUrl: response['avatar_url'],
        createdAt: response['created_at'] != null
            ? DateTime.parse(response['created_at'])
            : DateTime.now(),
      );

      return Success(user);
    } on supabase.AuthException catch (e) {
      return Failure(AuthError(message: e.message));
    } catch (e) {
      return Failure(UnknownError(message: e.toString()));
    }
  }
}
