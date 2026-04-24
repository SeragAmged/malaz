import 'package:malaz/features/rooms/domain/entities/enums.dart';
import 'package:malaz/features/rooms/domain/entities/room_member_with_session.dart';

import '../../../../core/util/errors/domain_errors.dart';
import '../../../../core/util/result.dart';

abstract interface class PresenceRepository {
  Future<Result<void, DomainError>> setStatus(MemberStatus status);
}
