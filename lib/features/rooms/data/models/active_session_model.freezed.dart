// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'active_session_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ActiveSessionModel {

@JsonKey(name: "session_id") String get sessionId;@JsonKey(name: "session_type") SessionType get sessionType;@JsonKey(name: "started_at") DateTime get startedAt;@JsonKey(name: "planned_minutes") int get plannedMinutes;// @JsonKey(name: "status") required String status,
@JsonKey(name: "total_paused_seconds") int get totalPausedSeconds;@JsonKey(name: "paused_at") DateTime? get pausedAt;
/// Create a copy of ActiveSessionModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ActiveSessionModelCopyWith<ActiveSessionModel> get copyWith => _$ActiveSessionModelCopyWithImpl<ActiveSessionModel>(this as ActiveSessionModel, _$identity);

  /// Serializes this ActiveSessionModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ActiveSessionModel&&(identical(other.sessionId, sessionId) || other.sessionId == sessionId)&&(identical(other.sessionType, sessionType) || other.sessionType == sessionType)&&(identical(other.startedAt, startedAt) || other.startedAt == startedAt)&&(identical(other.plannedMinutes, plannedMinutes) || other.plannedMinutes == plannedMinutes)&&(identical(other.totalPausedSeconds, totalPausedSeconds) || other.totalPausedSeconds == totalPausedSeconds)&&(identical(other.pausedAt, pausedAt) || other.pausedAt == pausedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,sessionId,sessionType,startedAt,plannedMinutes,totalPausedSeconds,pausedAt);

@override
String toString() {
  return 'ActiveSessionModel(sessionId: $sessionId, sessionType: $sessionType, startedAt: $startedAt, plannedMinutes: $plannedMinutes, totalPausedSeconds: $totalPausedSeconds, pausedAt: $pausedAt)';
}


}

/// @nodoc
abstract mixin class $ActiveSessionModelCopyWith<$Res>  {
  factory $ActiveSessionModelCopyWith(ActiveSessionModel value, $Res Function(ActiveSessionModel) _then) = _$ActiveSessionModelCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: "session_id") String sessionId,@JsonKey(name: "session_type") SessionType sessionType,@JsonKey(name: "started_at") DateTime startedAt,@JsonKey(name: "planned_minutes") int plannedMinutes,@JsonKey(name: "total_paused_seconds") int totalPausedSeconds,@JsonKey(name: "paused_at") DateTime? pausedAt
});




}
/// @nodoc
class _$ActiveSessionModelCopyWithImpl<$Res>
    implements $ActiveSessionModelCopyWith<$Res> {
  _$ActiveSessionModelCopyWithImpl(this._self, this._then);

  final ActiveSessionModel _self;
  final $Res Function(ActiveSessionModel) _then;

/// Create a copy of ActiveSessionModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? sessionId = null,Object? sessionType = null,Object? startedAt = null,Object? plannedMinutes = null,Object? totalPausedSeconds = null,Object? pausedAt = freezed,}) {
  return _then(_self.copyWith(
sessionId: null == sessionId ? _self.sessionId : sessionId // ignore: cast_nullable_to_non_nullable
as String,sessionType: null == sessionType ? _self.sessionType : sessionType // ignore: cast_nullable_to_non_nullable
as SessionType,startedAt: null == startedAt ? _self.startedAt : startedAt // ignore: cast_nullable_to_non_nullable
as DateTime,plannedMinutes: null == plannedMinutes ? _self.plannedMinutes : plannedMinutes // ignore: cast_nullable_to_non_nullable
as int,totalPausedSeconds: null == totalPausedSeconds ? _self.totalPausedSeconds : totalPausedSeconds // ignore: cast_nullable_to_non_nullable
as int,pausedAt: freezed == pausedAt ? _self.pausedAt : pausedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [ActiveSessionModel].
extension ActiveSessionModelPatterns on ActiveSessionModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ActiveSessionModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ActiveSessionModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ActiveSessionModel value)  $default,){
final _that = this;
switch (_that) {
case _ActiveSessionModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ActiveSessionModel value)?  $default,){
final _that = this;
switch (_that) {
case _ActiveSessionModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: "session_id")  String sessionId, @JsonKey(name: "session_type")  SessionType sessionType, @JsonKey(name: "started_at")  DateTime startedAt, @JsonKey(name: "planned_minutes")  int plannedMinutes, @JsonKey(name: "total_paused_seconds")  int totalPausedSeconds, @JsonKey(name: "paused_at")  DateTime? pausedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ActiveSessionModel() when $default != null:
return $default(_that.sessionId,_that.sessionType,_that.startedAt,_that.plannedMinutes,_that.totalPausedSeconds,_that.pausedAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: "session_id")  String sessionId, @JsonKey(name: "session_type")  SessionType sessionType, @JsonKey(name: "started_at")  DateTime startedAt, @JsonKey(name: "planned_minutes")  int plannedMinutes, @JsonKey(name: "total_paused_seconds")  int totalPausedSeconds, @JsonKey(name: "paused_at")  DateTime? pausedAt)  $default,) {final _that = this;
switch (_that) {
case _ActiveSessionModel():
return $default(_that.sessionId,_that.sessionType,_that.startedAt,_that.plannedMinutes,_that.totalPausedSeconds,_that.pausedAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: "session_id")  String sessionId, @JsonKey(name: "session_type")  SessionType sessionType, @JsonKey(name: "started_at")  DateTime startedAt, @JsonKey(name: "planned_minutes")  int plannedMinutes, @JsonKey(name: "total_paused_seconds")  int totalPausedSeconds, @JsonKey(name: "paused_at")  DateTime? pausedAt)?  $default,) {final _that = this;
switch (_that) {
case _ActiveSessionModel() when $default != null:
return $default(_that.sessionId,_that.sessionType,_that.startedAt,_that.plannedMinutes,_that.totalPausedSeconds,_that.pausedAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ActiveSessionModel extends ActiveSessionModel {
  const _ActiveSessionModel({@JsonKey(name: "session_id") required this.sessionId, @JsonKey(name: "session_type") required this.sessionType, @JsonKey(name: "started_at") required this.startedAt, @JsonKey(name: "planned_minutes") required this.plannedMinutes, @JsonKey(name: "total_paused_seconds") required this.totalPausedSeconds, @JsonKey(name: "paused_at") this.pausedAt}): super._();
  factory _ActiveSessionModel.fromJson(Map<String, dynamic> json) => _$ActiveSessionModelFromJson(json);

@override@JsonKey(name: "session_id") final  String sessionId;
@override@JsonKey(name: "session_type") final  SessionType sessionType;
@override@JsonKey(name: "started_at") final  DateTime startedAt;
@override@JsonKey(name: "planned_minutes") final  int plannedMinutes;
// @JsonKey(name: "status") required String status,
@override@JsonKey(name: "total_paused_seconds") final  int totalPausedSeconds;
@override@JsonKey(name: "paused_at") final  DateTime? pausedAt;

/// Create a copy of ActiveSessionModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ActiveSessionModelCopyWith<_ActiveSessionModel> get copyWith => __$ActiveSessionModelCopyWithImpl<_ActiveSessionModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ActiveSessionModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ActiveSessionModel&&(identical(other.sessionId, sessionId) || other.sessionId == sessionId)&&(identical(other.sessionType, sessionType) || other.sessionType == sessionType)&&(identical(other.startedAt, startedAt) || other.startedAt == startedAt)&&(identical(other.plannedMinutes, plannedMinutes) || other.plannedMinutes == plannedMinutes)&&(identical(other.totalPausedSeconds, totalPausedSeconds) || other.totalPausedSeconds == totalPausedSeconds)&&(identical(other.pausedAt, pausedAt) || other.pausedAt == pausedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,sessionId,sessionType,startedAt,plannedMinutes,totalPausedSeconds,pausedAt);

@override
String toString() {
  return 'ActiveSessionModel(sessionId: $sessionId, sessionType: $sessionType, startedAt: $startedAt, plannedMinutes: $plannedMinutes, totalPausedSeconds: $totalPausedSeconds, pausedAt: $pausedAt)';
}


}

/// @nodoc
abstract mixin class _$ActiveSessionModelCopyWith<$Res> implements $ActiveSessionModelCopyWith<$Res> {
  factory _$ActiveSessionModelCopyWith(_ActiveSessionModel value, $Res Function(_ActiveSessionModel) _then) = __$ActiveSessionModelCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: "session_id") String sessionId,@JsonKey(name: "session_type") SessionType sessionType,@JsonKey(name: "started_at") DateTime startedAt,@JsonKey(name: "planned_minutes") int plannedMinutes,@JsonKey(name: "total_paused_seconds") int totalPausedSeconds,@JsonKey(name: "paused_at") DateTime? pausedAt
});




}
/// @nodoc
class __$ActiveSessionModelCopyWithImpl<$Res>
    implements _$ActiveSessionModelCopyWith<$Res> {
  __$ActiveSessionModelCopyWithImpl(this._self, this._then);

  final _ActiveSessionModel _self;
  final $Res Function(_ActiveSessionModel) _then;

/// Create a copy of ActiveSessionModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? sessionId = null,Object? sessionType = null,Object? startedAt = null,Object? plannedMinutes = null,Object? totalPausedSeconds = null,Object? pausedAt = freezed,}) {
  return _then(_ActiveSessionModel(
sessionId: null == sessionId ? _self.sessionId : sessionId // ignore: cast_nullable_to_non_nullable
as String,sessionType: null == sessionType ? _self.sessionType : sessionType // ignore: cast_nullable_to_non_nullable
as SessionType,startedAt: null == startedAt ? _self.startedAt : startedAt // ignore: cast_nullable_to_non_nullable
as DateTime,plannedMinutes: null == plannedMinutes ? _self.plannedMinutes : plannedMinutes // ignore: cast_nullable_to_non_nullable
as int,totalPausedSeconds: null == totalPausedSeconds ? _self.totalPausedSeconds : totalPausedSeconds // ignore: cast_nullable_to_non_nullable
as int,pausedAt: freezed == pausedAt ? _self.pausedAt : pausedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}

// dart format on
