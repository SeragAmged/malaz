// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'room_members_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$RoomMembersState {

 List<RoomMemberWithSessionModel> get members; bool get isLoading; String? get errorMessage; DateTime? get localNow;
/// Create a copy of RoomMembersState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$RoomMembersStateCopyWith<RoomMembersState> get copyWith => _$RoomMembersStateCopyWithImpl<RoomMembersState>(this as RoomMembersState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is RoomMembersState&&const DeepCollectionEquality().equals(other.members, members)&&(identical(other.isLoading, isLoading) || other.isLoading == isLoading)&&(identical(other.errorMessage, errorMessage) || other.errorMessage == errorMessage)&&(identical(other.localNow, localNow) || other.localNow == localNow));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(members),isLoading,errorMessage,localNow);

@override
String toString() {
  return 'RoomMembersState(members: $members, isLoading: $isLoading, errorMessage: $errorMessage, localNow: $localNow)';
}


}

/// @nodoc
abstract mixin class $RoomMembersStateCopyWith<$Res>  {
  factory $RoomMembersStateCopyWith(RoomMembersState value, $Res Function(RoomMembersState) _then) = _$RoomMembersStateCopyWithImpl;
@useResult
$Res call({
 List<RoomMemberWithSessionModel> members, bool isLoading, String? errorMessage, DateTime? localNow
});




}
/// @nodoc
class _$RoomMembersStateCopyWithImpl<$Res>
    implements $RoomMembersStateCopyWith<$Res> {
  _$RoomMembersStateCopyWithImpl(this._self, this._then);

  final RoomMembersState _self;
  final $Res Function(RoomMembersState) _then;

/// Create a copy of RoomMembersState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? members = null,Object? isLoading = null,Object? errorMessage = freezed,Object? localNow = freezed,}) {
  return _then(_self.copyWith(
members: null == members ? _self.members : members // ignore: cast_nullable_to_non_nullable
as List<RoomMemberWithSessionModel>,isLoading: null == isLoading ? _self.isLoading : isLoading // ignore: cast_nullable_to_non_nullable
as bool,errorMessage: freezed == errorMessage ? _self.errorMessage : errorMessage // ignore: cast_nullable_to_non_nullable
as String?,localNow: freezed == localNow ? _self.localNow : localNow // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [RoomMembersState].
extension RoomMembersStatePatterns on RoomMembersState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _RoomMembersState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _RoomMembersState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _RoomMembersState value)  $default,){
final _that = this;
switch (_that) {
case _RoomMembersState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _RoomMembersState value)?  $default,){
final _that = this;
switch (_that) {
case _RoomMembersState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<RoomMemberWithSessionModel> members,  bool isLoading,  String? errorMessage,  DateTime? localNow)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _RoomMembersState() when $default != null:
return $default(_that.members,_that.isLoading,_that.errorMessage,_that.localNow);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<RoomMemberWithSessionModel> members,  bool isLoading,  String? errorMessage,  DateTime? localNow)  $default,) {final _that = this;
switch (_that) {
case _RoomMembersState():
return $default(_that.members,_that.isLoading,_that.errorMessage,_that.localNow);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<RoomMemberWithSessionModel> members,  bool isLoading,  String? errorMessage,  DateTime? localNow)?  $default,) {final _that = this;
switch (_that) {
case _RoomMembersState() when $default != null:
return $default(_that.members,_that.isLoading,_that.errorMessage,_that.localNow);case _:
  return null;

}
}

}

/// @nodoc


class _RoomMembersState implements RoomMembersState {
  const _RoomMembersState({final  List<RoomMemberWithSessionModel> members = const [], this.isLoading = false, this.errorMessage, this.localNow}): _members = members;
  

 final  List<RoomMemberWithSessionModel> _members;
@override@JsonKey() List<RoomMemberWithSessionModel> get members {
  if (_members is EqualUnmodifiableListView) return _members;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_members);
}

@override@JsonKey() final  bool isLoading;
@override final  String? errorMessage;
@override final  DateTime? localNow;

/// Create a copy of RoomMembersState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$RoomMembersStateCopyWith<_RoomMembersState> get copyWith => __$RoomMembersStateCopyWithImpl<_RoomMembersState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _RoomMembersState&&const DeepCollectionEquality().equals(other._members, _members)&&(identical(other.isLoading, isLoading) || other.isLoading == isLoading)&&(identical(other.errorMessage, errorMessage) || other.errorMessage == errorMessage)&&(identical(other.localNow, localNow) || other.localNow == localNow));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_members),isLoading,errorMessage,localNow);

@override
String toString() {
  return 'RoomMembersState(members: $members, isLoading: $isLoading, errorMessage: $errorMessage, localNow: $localNow)';
}


}

/// @nodoc
abstract mixin class _$RoomMembersStateCopyWith<$Res> implements $RoomMembersStateCopyWith<$Res> {
  factory _$RoomMembersStateCopyWith(_RoomMembersState value, $Res Function(_RoomMembersState) _then) = __$RoomMembersStateCopyWithImpl;
@override @useResult
$Res call({
 List<RoomMemberWithSessionModel> members, bool isLoading, String? errorMessage, DateTime? localNow
});




}
/// @nodoc
class __$RoomMembersStateCopyWithImpl<$Res>
    implements _$RoomMembersStateCopyWith<$Res> {
  __$RoomMembersStateCopyWithImpl(this._self, this._then);

  final _RoomMembersState _self;
  final $Res Function(_RoomMembersState) _then;

/// Create a copy of RoomMembersState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? members = null,Object? isLoading = null,Object? errorMessage = freezed,Object? localNow = freezed,}) {
  return _then(_RoomMembersState(
members: null == members ? _self._members : members // ignore: cast_nullable_to_non_nullable
as List<RoomMemberWithSessionModel>,isLoading: null == isLoading ? _self.isLoading : isLoading // ignore: cast_nullable_to_non_nullable
as bool,errorMessage: freezed == errorMessage ? _self.errorMessage : errorMessage // ignore: cast_nullable_to_non_nullable
as String?,localNow: freezed == localNow ? _self.localNow : localNow // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}

// dart format on
