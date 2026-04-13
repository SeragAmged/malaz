/// Base exception for authentication errors
abstract class AuthException implements Exception {
  final String message;

  AuthException(this.message);

  @override
  String toString() => message;
}

/// Exception for invalid credentials
class InvalidCredentialsException extends AuthException {
  InvalidCredentialsException([super.message = 'Invalid credentials']);
}

/// Exception for user not found
class UserNotFoundException extends AuthException {
  UserNotFoundException([super.message = 'User not found']);
}

/// Exception for email already exists
class EmailAlreadyExistsException extends AuthException {
  EmailAlreadyExistsException([super.message = 'Email already exists']);
}

/// Exception for weak password
class WeakPasswordException extends AuthException {
  WeakPasswordException([super.message = 'Password is too weak']);
}

/// Exception for network error
class NetworkException extends AuthException {
  NetworkException([super.message = 'Network error occurred']);
}

/// Exception for unknown error
class UnknownAuthException extends AuthException {
  UnknownAuthException([super.message = 'An unexpected error occurred']);
}
