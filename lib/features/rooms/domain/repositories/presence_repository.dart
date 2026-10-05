import 'package:malaz/features/rooms/domain/entities/enums.dart';

import '../../../../core/util/errors/domain_errors.dart';
import '../../../../core/util/result.dart';

abstract interface class PresenceRepository {
  Future<Result<void, DomainError>> setStatus(UserStatus status);
}
