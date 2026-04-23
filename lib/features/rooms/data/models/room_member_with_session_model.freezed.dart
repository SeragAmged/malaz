// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'room_member_with_session_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$RoomMemberWithSessionModel {

@JsonKey(name: 'user_id') String get userId;@JsonKey(name: 'full_name') String get fullName;@JsonKey(name: 'avatar_url') String? get avatarUrl; String get status;@JsonKey(name: 'last_checkin_at') DateTime get lastCheckinAt;@JsonKey(name: 'completed_focus_seconds') int get completedFocusSeconds;@JsonKey(name: 'session_id') String? get sessionId;@JsonKey(name: 'session_type') String? get sessionType;@JsonKey(name: 'started_at') DateTime? get startedAt;@JsonKey(name: 'planned_minutes') int? get plannedMinutes;@JsonKey(name: 'paused_at') DateTime? get pausedAt;@JsonKey(name: 'total_paused_seconds') int? get totalPausedSeconds;
/// Create a copy of RoomMemberWithSessionModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$RoomMemberWithSessionModelCopyWith<RoomMemberWithSessionModel> get copyWith => _$RoomMemberWithSessionModelCopyWithImpl<RoomMemberWithSessionModel>(this as RoomMemberWithSessionModel, _$identity);

  /// Serializes this RoomMemberWithSessionModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is RoomMemberWithSessionModel&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.fullName, fullName) || other.fullName == fullName)&&(identical(other.avatarUrl, avatarUrl) || other.avatarUrl == avatarUrl)&&(identical(other.status, status) || other.status == status)&&(identical(other.lastCheckinAt, lastCheckinAt) || other.lastCheckinAt == lastCheckinAt)&&(identical(other.completedFocusSeconds, completedFocusSeconds) || other.completedFocusSeconds == completedFocusSeconds)&&(identical(other.sessionId, sessionId) || other.sessionId == sessionId)&&(identical(other.sessionType, sessionType) || other.sessionType == sessionType)&&(identical(other.startedAt, startedAt) || other.startedAt == startedAt)&&(identical(other.plannedMinutes, plannedMinutes) || other.plannedMinutes == plannedMinutes)&&(identical(other.pausedAt, pausedAt) || other.pausedAt == pausedAt)&&(identical(other.totalPausedSeconds, totalPausedSeconds) || other.totalPausedSeconds == totalPausedSeconds));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,userId,fullName,avatarUrl,status,lastCheckinAt,completedFocusSeconds,sessionId,sessionType,startedAt,plannedMinutes,pausedAt,totalPausedSeconds);

@override
String toString() {
  return 'RoomMemberWithSessionModel(userId: $userId, fullName: $fullName, avatarUrl: $avatarUrl, status: $status, lastCheckinAt: $lastCheckinAt, completedFocusSeconds: $completedFocusSeconds, sessionId: $sessionId, sessionType: $sessionType, startedAt: $startedAt, plannedMinutes: $plannedMinutes, pausedAt: $pausedAt, totalPausedSeconds: $totalPausedSeconds)';
}


}

/// @nodoc
abstract mixin class $RoomMemberWithSessionModelCopyWith<$Res>  {
  factory $RoomMemberWithSessionModelCopyWith(RoomMemberWithSessionModel value, $Res Function(RoomMemberWithSessionModel) _then) = _$RoomMemberWithSessionModelCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'user_id') String userId,@JsonKey(name: 'full_name') String fullName,@JsonKey(name: 'avatar_url') String? avatarUrl, String status,@JsonKey(name: 'last_checkin_at') DateTime lastCheckinAt,@JsonKey(name: 'completed_focus_seconds') int completedFocusSeconds,@JsonKey(name: 'session_id') String? sessionId,@JsonKey(name: 'session_type') String? sessionType,@JsonKey(name: 'started_at') DateTime? startedAt,@JsonKey(name: 'planned_minutes') int? plannedMinutes,@JsonKey(name: 'paused_at') DateTime? pausedAt,@JsonKey(name: 'total_paused_seconds') int? totalPausedSeconds
});




}
/// @nodoc
class _$RoomMemberWithSessionModelCopyWithImpl<$Res>
    implements $RoomMemberWithSessionModelCopyWith<$Res> {
  _$RoomMemberWithSessionModelCopyWithImpl(this._self, this._then);

  final RoomMemberWithSessionModel _self;
  final $Res Function(RoomMemberWithSessionModel) _then;

/// Create a copy of RoomMemberWithSessionModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? userId = null,Object? fullName = null,Object? avatarUrl = freezed,Object? status = null,Object? lastCheckinAt = null,Object? completedFocusSeconds = null,Object? sessionId = freezed,Object? sessionType = freezed,Object? startedAt = freezed,Object? plannedMinutes = freezed,Object? pausedAt = freezed,Object? totalPausedSeconds = freezed,}) {
  return _then(_self.copyWith(
userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,fullName: null == fullName ? _self.fullName : fullName // ignore: cast_nullable_to_non_nullable
as String,avatarUrl: freezed == avatarUrl ? _self.avatarUrl : avatarUrl // ignore: cast_nullable_to_non_nullable
as String?,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,lastCheckinAt: null == lastCheckinAt ? _self.lastCheckinAt : lastCheckinAt // ignore: cast_nullable_to_non_nullable
as DateTime,completedFocusSeconds: null == completedFocusSeconds ? _self.completedFocusSeconds : completedFocusSeconds // ignore: cast_nullable_to_non_nullable
as int,sessionId: freezed == sessionId ? _self.sessionId : sessionId // ignore: cast_nullable_to_non_nullable
as String?,sessionType: freezed == sessionType ? _self.sessionType : sessionType // ignore: cast_nullable_to_non_nullable
as String?,startedAt: freezed == startedAt ? _self.startedAt : startedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,plannedMinutes: freezed == plannedMinutes ? _self.plannedMinutes : plannedMinutes // ignore: cast_nullable_to_non_nullable
as int?,pausedAt: freezed == pausedAt ? _self.pausedAt : pausedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,totalPausedSeconds: freezed == totalPausedSeconds ? _self.totalPausedSeconds : totalPausedSeconds // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}

}


/// Adds pattern-matching-related methods to [RoomMemberWithSessionModel].
extension RoomMemberWithSessionModelPatterns on RoomMemberWithSessionModel {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _RoomMemberWithSessionModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _RoomMemberWithSessionModel() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _RoomMemberWithSessionModel value)  $default,){
final _that = this;
switch (_that) {
case _RoomMemberWithSessionModel():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _RoomMemberWithSessionModel value)?  $default,){
final _that = this;
switch (_that) {
case _RoomMemberWithSessionModel() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'user_id')  String userId, @JsonKey(name: 'full_name')  String fullName, @JsonKey(name: 'avatar_url')  String? avatarUrl,  String status, @JsonKey(name: 'last_checkin_at')  DateTime lastCheckinAt, @JsonKey(name: 'completed_focus_seconds')  int completedFocusSeconds, @JsonKey(name: 'session_id')  String? sessionId, @JsonKey(name: 'session_type')  String? sessionType, @JsonKey(name: 'started_at')  DateTime? startedAt, @JsonKey(name: 'planned_minutes')  int? plannedMinutes, @JsonKey(name: 'paused_at')  DateTime? pausedAt, @JsonKey(name: 'total_paused_seconds')  int? totalPausedSeconds)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _RoomMemberWithSessionModel() when $default != null:
return $default(_that.userId,_that.fullName,_that.avatarUrl,_that.status,_that.lastCheckinAt,_that.completedFocusSeconds,_that.sessionId,_that.sessionType,_that.startedAt,_that.plannedMinutes,_that.pausedAt,_that.totalPausedSeconds);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'user_id')  String userId, @JsonKey(name: 'full_name')  String fullName, @JsonKey(name: 'avatar_url')  String? avatarUrl,  String status, @JsonKey(name: 'last_checkin_at')  DateTime lastCheckinAt, @JsonKey(name: 'completed_focus_seconds')  int completedFocusSeconds, @JsonKey(name: 'session_id')  String? sessionId, @JsonKey(name: 'session_type')  String? sessionType, @JsonKey(name: 'started_at')  DateTime? startedAt, @JsonKey(name: 'planned_minutes')  int? plannedMinutes, @JsonKey(name: 'paused_at')  DateTime? pausedAt, @JsonKey(name: 'total_paused_seconds')  int? totalPausedSeconds)  $default,) {final _that = this;
switch (_that) {
case _RoomMemberWithSessionModel():
return $default(_that.userId,_that.fullName,_that.avatarUrl,_that.status,_that.lastCheckinAt,_that.completedFocusSeconds,_that.sessionId,_that.sessionType,_that.startedAt,_that.plannedMinutes,_that.pausedAt,_that.totalPausedSeconds);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'user_id')  String userId, @JsonKey(name: 'full_name')  String fullName, @JsonKey(name: 'avatar_url')  String? avatarUrl,  String status, @JsonKey(name: 'last_checkin_at')  DateTime lastCheckinAt, @JsonKey(name: 'completed_focus_seconds')  int completedFocusSeconds, @JsonKey(name: 'session_id')  String? sessionId, @JsonKey(name: 'session_type')  String? sessionType, @JsonKey(name: 'started_at')  DateTime? startedAt, @JsonKey(name: 'planned_minutes')  int? plannedMinutes, @JsonKey(name: 'paused_at')  DateTime? pausedAt, @JsonKey(name: 'total_paused_seconds')  int? totalPausedSeconds)?  $default,) {final _that = this;
switch (_that) {
case _RoomMemberWithSessionModel() when $default != null:
return $default(_that.userId,_that.fullName,_that.avatarUrl,_that.status,_that.lastCheckinAt,_that.completedFocusSeconds,_that.sessionId,_that.sessionType,_that.startedAt,_that.plannedMinutes,_that.pausedAt,_that.totalPausedSeconds);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _RoomMemberWithSessionModel extends RoomMemberWithSessionModel {
  const _RoomMemberWithSessionModel({@JsonKey(name: 'user_id') required this.userId, @JsonKey(name: 'full_name') required this.fullName, @JsonKey(name: 'avatar_url') this.avatarUrl, required this.status, @JsonKey(name: 'last_checkin_at') required this.lastCheckinAt, @JsonKey(name: 'completed_focus_seconds') required this.completedFocusSeconds, @JsonKey(name: 'session_id') this.sessionId, @JsonKey(name: 'session_type') this.sessionType, @JsonKey(name: 'started_at') this.startedAt, @JsonKey(name: 'planned_minutes') this.plannedMinutes, @JsonKey(name: 'paused_at') this.pausedAt, @JsonKey(name: 'total_paused_seconds') this.totalPausedSeconds}): super._();
  factory _RoomMemberWithSessionModel.fromJson(Map<String, dynamic> json) => _$RoomMemberWithSessionModelFromJson(json);

@override@JsonKey(name: 'user_id') final  String userId;
@override@JsonKey(name: 'full_name') final  String fullName;
@override@JsonKey(name: 'avatar_url') final  String? avatarUrl;
@override final  String status;
@override@JsonKey(name: 'last_checkin_at') final  DateTime lastCheckinAt;
@override@JsonKey(name: 'completed_focus_seconds') final  int completedFocusSeconds;
@override@JsonKey(name: 'session_id') final  String? sessionId;
@override@JsonKey(name: 'session_type') final  String? sessionType;
@override@JsonKey(name: 'started_at') final  DateTime? startedAt;
@override@JsonKey(name: 'planned_minutes') final  int? plannedMinutes;
@override@JsonKey(name: 'paused_at') final  DateTime? pausedAt;
@override@JsonKey(name: 'total_paused_seconds') final  int? totalPausedSeconds;

/// Create a copy of RoomMemberWithSessionModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$RoomMemberWithSessionModelCopyWith<_RoomMemberWithSessionModel> get copyWith => __$RoomMemberWithSessionModelCopyWithImpl<_RoomMemberWithSessionModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$RoomMemberWithSessionModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _RoomMemberWithSessionModel&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.fullName, fullName) || other.fullName == fullName)&&(identical(other.avatarUrl, avatarUrl) || other.avatarUrl == avatarUrl)&&(identical(other.status, status) || other.status == status)&&(identical(other.lastCheckinAt, lastCheckinAt) || other.lastCheckinAt == lastCheckinAt)&&(identical(other.completedFocusSeconds, completedFocusSeconds) || other.completedFocusSeconds == completedFocusSeconds)&&(identical(other.sessionId, sessionId) || other.sessionId == sessionId)&&(identical(other.sessionType, sessionType) || other.sessionType == sessionType)&&(identical(other.startedAt, startedAt) || other.startedAt == startedAt)&&(identical(other.plannedMinutes, plannedMinutes) || other.plannedMinutes == plannedMinutes)&&(identical(other.pausedAt, pausedAt) || other.pausedAt == pausedAt)&&(identical(other.totalPausedSeconds, totalPausedSeconds) || other.totalPausedSeconds == totalPausedSeconds));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,userId,fullName,avatarUrl,status,lastCheckinAt,completedFocusSeconds,sessionId,sessionType,startedAt,plannedMinutes,pausedAt,totalPausedSeconds);

@override
String toString() {
  return 'RoomMemberWithSessionModel(userId: $userId, fullName: $fullName, avatarUrl: $avatarUrl, status: $status, lastCheckinAt: $lastCheckinAt, completedFocusSeconds: $completedFocusSeconds, sessionId: $sessionId, sessionType: $sessionType, startedAt: $startedAt, plannedMinutes: $plannedMinutes, pausedAt: $pausedAt, totalPausedSeconds: $totalPausedSeconds)';
}


}

/// @nodoc
abstract mixin class _$RoomMemberWithSessionModelCopyWith<$Res> implements $RoomMemberWithSessionModelCopyWith<$Res> {
  factory _$RoomMemberWithSessionModelCopyWith(_RoomMemberWithSessionModel value, $Res Function(_RoomMemberWithSessionModel) _then) = __$RoomMemberWithSessionModelCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'user_id') String userId,@JsonKey(name: 'full_name') String fullName,@JsonKey(name: 'avatar_url') String? avatarUrl, String status,@JsonKey(name: 'last_checkin_at') DateTime lastCheckinAt,@JsonKey(name: 'completed_focus_seconds') int completedFocusSeconds,@JsonKey(name: 'session_id') String? sessionId,@JsonKey(name: 'session_type') String? sessionType,@JsonKey(name: 'started_at') DateTime? startedAt,@JsonKey(name: 'planned_minutes') int? plannedMinutes,@JsonKey(name: 'paused_at') DateTime? pausedAt,@JsonKey(name: 'total_paused_seconds') int? totalPausedSeconds
});




}
/// @nodoc
class __$RoomMemberWithSessionModelCopyWithImpl<$Res>
    implements _$RoomMemberWithSessionModelCopyWith<$Res> {
  __$RoomMemberWithSessionModelCopyWithImpl(this._self, this._then);

  final _RoomMemberWithSessionModel _self;
  final $Res Function(_RoomMemberWithSessionModel) _then;

/// Create a copy of RoomMemberWithSessionModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? userId = null,Object? fullName = null,Object? avatarUrl = freezed,Object? status = null,Object? lastCheckinAt = null,Object? completedFocusSeconds = null,Object? sessionId = freezed,Object? sessionType = freezed,Object? startedAt = freezed,Object? plannedMinutes = freezed,Object? pausedAt = freezed,Object? totalPausedSeconds = freezed,}) {
  return _then(_RoomMemberWithSessionModel(
userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,fullName: null == fullName ? _self.fullName : fullName // ignore: cast_nullable_to_non_nullable
as String,avatarUrl: freezed == avatarUrl ? _self.avatarUrl : avatarUrl // ignore: cast_nullable_to_non_nullable
as String?,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,lastCheckinAt: null == lastCheckinAt ? _self.lastCheckinAt : lastCheckinAt // ignore: cast_nullable_to_non_nullable
as DateTime,completedFocusSeconds: null == completedFocusSeconds ? _self.completedFocusSeconds : completedFocusSeconds // ignore: cast_nullable_to_non_nullable
as int,sessionId: freezed == sessionId ? _self.sessionId : sessionId // ignore: cast_nullable_to_non_nullable
as String?,sessionType: freezed == sessionType ? _self.sessionType : sessionType // ignore: cast_nullable_to_non_nullable
as String?,startedAt: freezed == startedAt ? _self.startedAt : startedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,plannedMinutes: freezed == plannedMinutes ? _self.plannedMinutes : plannedMinutes // ignore: cast_nullable_to_non_nullable
as int?,pausedAt: freezed == pausedAt ? _self.pausedAt : pausedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,totalPausedSeconds: freezed == totalPausedSeconds ? _self.totalPausedSeconds : totalPausedSeconds // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}


}

// dart format on
