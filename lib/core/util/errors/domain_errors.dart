sealed class DomainError {
  const DomainError({this.message});

  final String? message;
}

final class NetworkError extends DomainError {
  const NetworkError({super.message});
}

final class CacheMissError extends DomainError {
  const CacheMissError({super.message});
}

final class UnknownError extends DomainError {
  const UnknownError({super.message});
}

/// Auth-specific domain errors
final class AuthError extends DomainError {
  const AuthError({super.message});
}

final class InvalidCredentialsError extends DomainError {
  const InvalidCredentialsError({super.message});
}

final class EmailAlreadyExistsError extends DomainError {
  const EmailAlreadyExistsError({super.message});
}

final class WeakPasswordError extends DomainError {
  const WeakPasswordError({super.message});
}

final class AvatarLoadError extends DomainError {
  const AvatarLoadError({super.message});
}

final class SupabaseError extends DomainError {
  const SupabaseError({super.message});
}

final class AlreadyInRoom extends SupabaseError {
  const AlreadyInRoom({super.message});
}