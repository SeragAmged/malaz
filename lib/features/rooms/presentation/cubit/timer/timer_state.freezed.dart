// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'timer_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$TimerState {

 String? get sessionId; String? get errorMessage; bool get isLoading; TimerStatus get status; SessionType get mode; int get totalSeconds; int get remainingSeconds; int get focusDuration; int get breakDuration; DateTime? get sessionStartedAt;
/// Create a copy of TimerState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TimerStateCopyWith<TimerState> get copyWith => _$TimerStateCopyWithImpl<TimerState>(this as TimerState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TimerState&&(identical(other.sessionId, sessionId) || other.sessionId == sessionId)&&(identical(other.errorMessage, errorMessage) || other.errorMessage == errorMessage)&&(identical(other.isLoading, isLoading) || other.isLoading == isLoading)&&(identical(other.status, status) || other.status == status)&&(identical(other.mode, mode) || other.mode == mode)&&(identical(other.totalSeconds, totalSeconds) || other.totalSeconds == totalSeconds)&&(identical(other.remainingSeconds, remainingSeconds) || other.remainingSeconds == remainingSeconds)&&(identical(other.focusDuration, focusDuration) || other.focusDuration == focusDuration)&&(identical(other.breakDuration, breakDuration) || other.breakDuration == breakDuration)&&(identical(other.sessionStartedAt, sessionStartedAt) || other.sessionStartedAt == sessionStartedAt));
}


@override
int get hashCode => Object.hash(runtimeType,sessionId,errorMessage,isLoading,status,mode,totalSeconds,remainingSeconds,focusDuration,breakDuration,sessionStartedAt);

@override
String toString() {
  return 'TimerState(sessionId: $sessionId, errorMessage: $errorMessage, isLoading: $isLoading, status: $status, mode: $mode, totalSeconds: $totalSeconds, remainingSeconds: $remainingSeconds, focusDuration: $focusDuration, breakDuration: $breakDuration, sessionStartedAt: $sessionStartedAt)';
}


}

/// @nodoc
abstract mixin class $TimerStateCopyWith<$Res>  {
  factory $TimerStateCopyWith(TimerState value, $Res Function(TimerState) _then) = _$TimerStateCopyWithImpl;
@useResult
$Res call({
 String? sessionId, String? errorMessage, bool isLoading, TimerStatus status, SessionType mode, int totalSeconds, int remainingSeconds, int focusDuration, int breakDuration, DateTime? sessionStartedAt
});




}
/// @nodoc
class _$TimerStateCopyWithImpl<$Res>
    implements $TimerStateCopyWith<$Res> {
  _$TimerStateCopyWithImpl(this._self, this._then);

  final TimerState _self;
  final $Res Function(TimerState) _then;

/// Create a copy of TimerState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? sessionId = freezed,Object? errorMessage = freezed,Object? isLoading = null,Object? status = null,Object? mode = null,Object? totalSeconds = null,Object? remainingSeconds = null,Object? focusDuration = null,Object? breakDuration = null,Object? sessionStartedAt = freezed,}) {
  return _then(_self.copyWith(
sessionId: freezed == sessionId ? _self.sessionId : sessionId // ignore: cast_nullable_to_non_nullable
as String?,errorMessage: freezed == errorMessage ? _self.errorMessage : errorMessage // ignore: cast_nullable_to_non_nullable
as String?,isLoading: null == isLoading ? _self.isLoading : isLoading // ignore: cast_nullable_to_non_nullable
as bool,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as TimerStatus,mode: null == mode ? _self.mode : mode // ignore: cast_nullable_to_non_nullable
as SessionType,totalSeconds: null == totalSeconds ? _self.totalSeconds : totalSeconds // ignore: cast_nullable_to_non_nullable
as int,remainingSeconds: null == remainingSeconds ? _self.remainingSeconds : remainingSeconds // ignore: cast_nullable_to_non_nullable
as int,focusDuration: null == focusDuration ? _self.focusDuration : focusDuration // ignore: cast_nullable_to_non_nullable
as int,breakDuration: null == breakDuration ? _self.breakDuration : breakDuration // ignore: cast_nullable_to_non_nullable
as int,sessionStartedAt: freezed == sessionStartedAt ? _self.sessionStartedAt : sessionStartedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [TimerState].
extension TimerStatePatterns on TimerState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TimerState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TimerState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TimerState value)  $default,){
final _that = this;
switch (_that) {
case _TimerState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TimerState value)?  $default,){
final _that = this;
switch (_that) {
case _TimerState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String? sessionId,  String? errorMessage,  bool isLoading,  TimerStatus status,  SessionType mode,  int totalSeconds,  int remainingSeconds,  int focusDuration,  int breakDuration,  DateTime? sessionStartedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _TimerState() when $default != null:
return $default(_that.sessionId,_that.errorMessage,_that.isLoading,_that.status,_that.mode,_that.totalSeconds,_that.remainingSeconds,_that.focusDuration,_that.breakDuration,_that.sessionStartedAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String? sessionId,  String? errorMessage,  bool isLoading,  TimerStatus status,  SessionType mode,  int totalSeconds,  int remainingSeconds,  int focusDuration,  int breakDuration,  DateTime? sessionStartedAt)  $default,) {final _that = this;
switch (_that) {
case _TimerState():
return $default(_that.sessionId,_that.errorMessage,_that.isLoading,_that.status,_that.mode,_that.totalSeconds,_that.remainingSeconds,_that.focusDuration,_that.breakDuration,_that.sessionStartedAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String? sessionId,  String? errorMessage,  bool isLoading,  TimerStatus status,  SessionType mode,  int totalSeconds,  int remainingSeconds,  int focusDuration,  int breakDuration,  DateTime? sessionStartedAt)?  $default,) {final _that = this;
switch (_that) {
case _TimerState() when $default != null:
return $default(_that.sessionId,_that.errorMessage,_that.isLoading,_that.status,_that.mode,_that.totalSeconds,_that.remainingSeconds,_that.focusDuration,_that.breakDuration,_that.sessionStartedAt);case _:
  return null;

}
}

}

/// @nodoc


class _TimerState extends TimerState {
  const _TimerState({this.sessionId, this.errorMessage, this.isLoading = false, this.status = TimerStatus.idle, this.mode = SessionType.focus, this.totalSeconds = 1500, this.remainingSeconds = 1500, this.focusDuration = 25, this.breakDuration = 5, this.sessionStartedAt}): super._();
  

@override final  String? sessionId;
@override final  String? errorMessage;
@override@JsonKey() final  bool isLoading;
@override@JsonKey() final  TimerStatus status;
@override@JsonKey() final  SessionType mode;
@override@JsonKey() final  int totalSeconds;
@override@JsonKey() final  int remainingSeconds;
@override@JsonKey() final  int focusDuration;
@override@JsonKey() final  int breakDuration;
@override final  DateTime? sessionStartedAt;

/// Create a copy of TimerState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TimerStateCopyWith<_TimerState> get copyWith => __$TimerStateCopyWithImpl<_TimerState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _TimerState&&(identical(other.sessionId, sessionId) || other.sessionId == sessionId)&&(identical(other.errorMessage, errorMessage) || other.errorMessage == errorMessage)&&(identical(other.isLoading, isLoading) || other.isLoading == isLoading)&&(identical(other.status, status) || other.status == status)&&(identical(other.mode, mode) || other.mode == mode)&&(identical(other.totalSeconds, totalSeconds) || other.totalSeconds == totalSeconds)&&(identical(other.remainingSeconds, remainingSeconds) || other.remainingSeconds == remainingSeconds)&&(identical(other.focusDuration, focusDuration) || other.focusDuration == focusDuration)&&(identical(other.breakDuration, breakDuration) || other.breakDuration == breakDuration)&&(identical(other.sessionStartedAt, sessionStartedAt) || other.sessionStartedAt == sessionStartedAt));
}


@override
int get hashCode => Object.hash(runtimeType,sessionId,errorMessage,isLoading,status,mode,totalSeconds,remainingSeconds,focusDuration,breakDuration,sessionStartedAt);

@override
String toString() {
  return 'TimerState(sessionId: $sessionId, errorMessage: $errorMessage, isLoading: $isLoading, status: $status, mode: $mode, totalSeconds: $totalSeconds, remainingSeconds: $remainingSeconds, focusDuration: $focusDuration, breakDuration: $breakDuration, sessionStartedAt: $sessionStartedAt)';
}


}

/// @nodoc
abstract mixin class _$TimerStateCopyWith<$Res> implements $TimerStateCopyWith<$Res> {
  factory _$TimerStateCopyWith(_TimerState value, $Res Function(_TimerState) _then) = __$TimerStateCopyWithImpl;
@override @useResult
$Res call({
 String? sessionId, String? errorMessage, bool isLoading, TimerStatus status, SessionType mode, int totalSeconds, int remainingSeconds, int focusDuration, int breakDuration, DateTime? sessionStartedAt
});




}
/// @nodoc
class __$TimerStateCopyWithImpl<$Res>
    implements _$TimerStateCopyWith<$Res> {
  __$TimerStateCopyWithImpl(this._self, this._then);

  final _TimerState _self;
  final $Res Function(_TimerState) _then;

/// Create a copy of TimerState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? sessionId = freezed,Object? errorMessage = freezed,Object? isLoading = null,Object? status = null,Object? mode = null,Object? totalSeconds = null,Object? remainingSeconds = null,Object? focusDuration = null,Object? breakDuration = null,Object? sessionStartedAt = freezed,}) {
  return _then(_TimerState(
sessionId: freezed == sessionId ? _self.sessionId : sessionId // ignore: cast_nullable_to_non_nullable
as String?,errorMessage: freezed == errorMessage ? _self.errorMessage : errorMessage // ignore: cast_nullable_to_non_nullable
as String?,isLoading: null == isLoading ? _self.isLoading : isLoading // ignore: cast_nullable_to_non_nullable
as bool,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as TimerStatus,mode: null == mode ? _self.mode : mode // ignore: cast_nullable_to_non_nullable
as SessionType,totalSeconds: null == totalSeconds ? _self.totalSeconds : totalSeconds // ignore: cast_nullable_to_non_nullable
as int,remainingSeconds: null == remainingSeconds ? _self.remainingSeconds : remainingSeconds // ignore: cast_nullable_to_non_nullable
as int,focusDuration: null == focusDuration ? _self.focusDuration : focusDuration // ignore: cast_nullable_to_non_nullable
as int,breakDuration: null == breakDuration ? _self.breakDuration : breakDuration // ignore: cast_nullable_to_non_nullable
as int,sessionStartedAt: freezed == sessionStartedAt ? _self.sessionStartedAt : sessionStartedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}

// dart format on
