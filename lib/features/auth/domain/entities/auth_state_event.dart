import 'package:malaz/features/auth/domain/entities/user.dart';

enum AuthEventType {
  authenticated,
  unauthenticated,
  passwordRecovery,
}

class AuthStateEvent {
  const AuthStateEvent(
    this.type, {
    this.user,
  });

  final AuthEventType type;
  final User? user;
}
