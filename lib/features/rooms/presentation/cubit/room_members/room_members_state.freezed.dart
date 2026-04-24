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

 List<RoomMemberWithSession> get members; List<LeaderboardEntry> get topLeaders; bool get isLoading; String? get errorMessage; DateTime? get localNow; Set<String> get pausedMemberIds;
/// Create a copy of RoomMembersState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$RoomMembersStateCopyWith<RoomMembersState> get copyWith => _$RoomMembersStateCopyWithImpl<RoomMembersState>(this as RoomMembersState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is RoomMembersState&&const DeepCollectionEquality().equals(other.members, members)&&const DeepCollectionEquality().equals(other.topLeaders, topLeaders)&&(identical(other.isLoading, isLoading) || other.isLoading == isLoading)&&(identical(other.errorMessage, errorMessage) || other.errorMessage == errorMessage)&&(identical(other.localNow, localNow) || other.localNow == localNow)&&const DeepCollectionEquality().equals(other.pausedMemberIds, pausedMemberIds));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(members),const DeepCollectionEquality().hash(topLeaders),isLoading,errorMessage,localNow,const DeepCollectionEquality().hash(pausedMemberIds));

@override
String toString() {
  return 'RoomMembersState(members: $members, topLeaders: $topLeaders, isLoading: $isLoading, errorMessage: $errorMessage, localNow: $localNow, pausedMemberIds: $pausedMemberIds)';
}


}

/// @nodoc
abstract mixin class $RoomMembersStateCopyWith<$Res>  {
  factory $RoomMembersStateCopyWith(RoomMembersState value, $Res Function(RoomMembersState) _then) = _$RoomMembersStateCopyWithImpl;
@useResult
$Res call({
 List<RoomMemberWithSession> members, List<LeaderboardEntry> topLeaders, bool isLoading, String? errorMessage, DateTime? localNow, Set<String> pausedMemberIds
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
@pragma('vm:prefer-inline') @override $Res call({Object? members = null,Object? topLeaders = null,Object? isLoading = null,Object? errorMessage = freezed,Object? localNow = freezed,Object? pausedMemberIds = null,}) {
  return _then(_self.copyWith(
members: null == members ? _self.members : members // ignore: cast_nullable_to_non_nullable
as List<RoomMemberWithSession>,topLeaders: null == topLeaders ? _self.topLeaders : topLeaders // ignore: cast_nullable_to_non_nullable
as List<LeaderboardEntry>,isLoading: null == isLoading ? _self.isLoading : isLoading // ignore: cast_nullable_to_non_nullable
as bool,errorMessage: freezed == errorMessage ? _self.errorMessage : errorMessage // ignore: cast_nullable_to_non_nullable
as String?,localNow: freezed == localNow ? _self.localNow : localNow // ignore: cast_nullable_to_non_nullable
as DateTime?,pausedMemberIds: null == pausedMemberIds ? _self.pausedMemberIds : pausedMemberIds // ignore: cast_nullable_to_non_nullable
as Set<String>,
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<RoomMemberWithSession> members,  List<LeaderboardEntry> topLeaders,  bool isLoading,  String? errorMessage,  DateTime? localNow,  Set<String> pausedMemberIds)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _RoomMembersState() when $default != null:
return $default(_that.members,_that.topLeaders,_that.isLoading,_that.errorMessage,_that.localNow,_that.pausedMemberIds);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<RoomMemberWithSession> members,  List<LeaderboardEntry> topLeaders,  bool isLoading,  String? errorMessage,  DateTime? localNow,  Set<String> pausedMemberIds)  $default,) {final _that = this;
switch (_that) {
case _RoomMembersState():
return $default(_that.members,_that.topLeaders,_that.isLoading,_that.errorMessage,_that.localNow,_that.pausedMemberIds);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<RoomMemberWithSession> members,  List<LeaderboardEntry> topLeaders,  bool isLoading,  String? errorMessage,  DateTime? localNow,  Set<String> pausedMemberIds)?  $default,) {final _that = this;
switch (_that) {
case _RoomMembersState() when $default != null:
return $default(_that.members,_that.topLeaders,_that.isLoading,_that.errorMessage,_that.localNow,_that.pausedMemberIds);case _:
  return null;

}
}

}

/// @nodoc


class _RoomMembersState implements RoomMembersState {
  const _RoomMembersState({final  List<RoomMemberWithSession> members = const [], final  List<LeaderboardEntry> topLeaders = const [], this.isLoading = false, this.errorMessage, this.localNow, final  Set<String> pausedMemberIds = const {}}): _members = members,_topLeaders = topLeaders,_pausedMemberIds = pausedMemberIds;
  

 final  List<RoomMemberWithSession> _members;
@override@JsonKey() List<RoomMemberWithSession> get members {
  if (_members is EqualUnmodifiableListView) return _members;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_members);
}

 final  List<LeaderboardEntry> _topLeaders;
@override@JsonKey() List<LeaderboardEntry> get topLeaders {
  if (_topLeaders is EqualUnmodifiableListView) return _topLeaders;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_topLeaders);
}

@override@JsonKey() final  bool isLoading;
@override final  String? errorMessage;
@override final  DateTime? localNow;
 final  Set<String> _pausedMemberIds;
@override@JsonKey() Set<String> get pausedMemberIds {
  if (_pausedMemberIds is EqualUnmodifiableSetView) return _pausedMemberIds;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableSetView(_pausedMemberIds);
}


/// Create a copy of RoomMembersState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$RoomMembersStateCopyWith<_RoomMembersState> get copyWith => __$RoomMembersStateCopyWithImpl<_RoomMembersState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _RoomMembersState&&const DeepCollectionEquality().equals(other._members, _members)&&const DeepCollectionEquality().equals(other._topLeaders, _topLeaders)&&(identical(other.isLoading, isLoading) || other.isLoading == isLoading)&&(identical(other.errorMessage, errorMessage) || other.errorMessage == errorMessage)&&(identical(other.localNow, localNow) || other.localNow == localNow)&&const DeepCollectionEquality().equals(other._pausedMemberIds, _pausedMemberIds));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_members),const DeepCollectionEquality().hash(_topLeaders),isLoading,errorMessage,localNow,const DeepCollectionEquality().hash(_pausedMemberIds));

@override
String toString() {
  return 'RoomMembersState(members: $members, topLeaders: $topLeaders, isLoading: $isLoading, errorMessage: $errorMessage, localNow: $localNow, pausedMemberIds: $pausedMemberIds)';
}


}

/// @nodoc
abstract mixin class _$RoomMembersStateCopyWith<$Res> implements $RoomMembersStateCopyWith<$Res> {
  factory _$RoomMembersStateCopyWith(_RoomMembersState value, $Res Function(_RoomMembersState) _then) = __$RoomMembersStateCopyWithImpl;
@override @useResult
$Res call({
 List<RoomMemberWithSession> members, List<LeaderboardEntry> topLeaders, bool isLoading, String? errorMessage, DateTime? localNow, Set<String> pausedMemberIds
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
@override @pragma('vm:prefer-inline') $Res call({Object? members = null,Object? topLeaders = null,Object? isLoading = null,Object? errorMessage = freezed,Object? localNow = freezed,Object? pausedMemberIds = null,}) {
  return _then(_RoomMembersState(
members: null == members ? _self._members : members // ignore: cast_nullable_to_non_nullable
as List<RoomMemberWithSession>,topLeaders: null == topLeaders ? _self._topLeaders : topLeaders // ignore: cast_nullable_to_non_nullable
as List<LeaderboardEntry>,isLoading: null == isLoading ? _self.isLoading : isLoading // ignore: cast_nullable_to_non_nullable
as bool,errorMessage: freezed == errorMessage ? _self.errorMessage : errorMessage // ignore: cast_nullable_to_non_nullable
as String?,localNow: freezed == localNow ? _self.localNow : localNow // ignore: cast_nullable_to_non_nullable
as DateTime?,pausedMemberIds: null == pausedMemberIds ? _self._pausedMemberIds : pausedMemberIds // ignore: cast_nullable_to_non_nullable
as Set<String>,
  ));
}


}

// dart format on
