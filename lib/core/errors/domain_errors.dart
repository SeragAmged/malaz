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
