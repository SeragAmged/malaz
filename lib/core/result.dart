import 'errors/domain_errors.dart';

sealed class Result<D, E extends DomainError> {
  const Result();

  T fold<T>({
    required T Function(D data) onSuccess,
    required T Function(E error, D? data) onFailure,
  }) {
    return switch (this) {
      Success<D, E>(data: final data) => onSuccess(data),
      Failure<D, E>(error: final error, data: final data) => onFailure(
        error,
        data,
      ),
    };
  }

  Result<R, E> map<R>(R Function(D data) transform) {
    return switch (this) {
      Success<D, E>(data: final data) => Success(transform(data)),
      Failure<D, E>(error: final error, data: final data) => Failure(
        error,
        data == null ? null : transform(data),
      ),
    };
  }

  D? get dataOrNull => switch (this) {
    Success<D, E>(data: final data) => data,
    Failure<D, E>(data: final data) => data,
  };

  E? get errorOrNull => switch (this) {
    Success<D, E>() => null,
    Failure<D, E>(error: final error) => error,
  };

  bool get isSuccess => this is Success<D, E>;
  bool get isFailure => this is Failure<D, E>;
}

final class Success<D, E extends DomainError> extends Result<D, E> {
  const Success(this.data);

  final D data;
}

final class Failure<D, E extends DomainError> extends Result<D, E> {
  const Failure(this.error, [this.data]);

  final E error;
  final D? data;
}

extension ResultSideEffects<D, E extends DomainError> on Result<D, E> {
  Result<D, E> onSuccess(void Function(D data) action) {
    if (this case Success<D, E>(data: final data)) {
      action(data);
    }
    return this;
  }

  Result<D, E> onFailure(void Function(E error, D? data) action) {
    if (this case Failure<D, E>(error: final error, data: final data)) {
      action(error, data);
    }
    return this;
  }

  Result<D, E> when({
    void Function(D data)? success,
    void Function(E error, D? data)? failure,
    void Function(E? error, D? data)? onResult,
  }) {
    switch (this) {
      case Success<D, E>(data: final data):
        success?.call(data);
        onResult?.call(null, data);
      case Failure<D, E>(error: final error, data: final data):
        failure?.call(error, data);
        onResult?.call(error, data);
    }

    return this;
  }
}
