import 'package:malaz/features/auth/domain/entities/auth_state_event.dart';

import '../../../../core/util/result.dart';
import '../../../../core/util/errors/domain_errors.dart';
import '../entities/user.dart';

abstract class AuthRepository {
  Future<Result<void, DomainError>> signUp({
    required String email,
    required String password,
    required String confirmPassword,
    String? fullName,
    String? avatarUrl,
  });

  Future<Result<User, DomainError>> signIn({
    required String email,
    required String password,
  });

  Future<Result<void, DomainError>> signOut();

  Future<Result<User?, DomainError>> getCurrentUser();

  Future<bool> isAuthenticated();

  Stream<AuthStateEvent> watchAuthState();

  Future<Result<void, DomainError>> sendPasswordReset({required String email});
  Future<Result<void, DomainError>> resetPassword({
    required String newPassword,
  });

  Future<Result<List<String>, DomainError>> loadAvatarUrls();

  Future<Result<User, DomainError>> updateUserProfile({
    String? fullName,
    String? avatarUrl,
  });
}
