// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'room_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$RoomModel {

 String get id; String get name; String? get description;@JsonKey(name: 'background_url') String? get backgroundUrl; String get type; String get color;@JsonKey(name: 'members_avatars') List<String> get membersAvatars;@JsonKey(name: 'active_members') int get activeMembers;@JsonKey(name: 'max_members') int get maxMembers;@JsonKey(name: 'is_protected') bool get isProtected;@JsonKey(name: 'session_type') SessionType? get sessionType;@JsonKey(name: 'planned_minutes') int? get plannedMinutes;@JsonKey(name: 'paused_at') DateTime? get pausedAt;@JsonKey(name: 'session_started_at') DateTime? get sessionStartedAt;@JsonKey(name: 'is_member') bool get isMember;
/// Create a copy of RoomModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$RoomModelCopyWith<RoomModel> get copyWith => _$RoomModelCopyWithImpl<RoomModel>(this as RoomModel, _$identity);

  /// Serializes this RoomModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is RoomModel&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.description, description) || other.description == description)&&(identical(other.backgroundUrl, backgroundUrl) || other.backgroundUrl == backgroundUrl)&&(identical(other.type, type) || other.type == type)&&(identical(other.color, color) || other.color == color)&&const DeepCollectionEquality().equals(other.membersAvatars, membersAvatars)&&(identical(other.activeMembers, activeMembers) || other.activeMembers == activeMembers)&&(identical(other.maxMembers, maxMembers) || other.maxMembers == maxMembers)&&(identical(other.isProtected, isProtected) || other.isProtected == isProtected)&&(identical(other.sessionType, sessionType) || other.sessionType == sessionType)&&(identical(other.plannedMinutes, plannedMinutes) || other.plannedMinutes == plannedMinutes)&&(identical(other.pausedAt, pausedAt) || other.pausedAt == pausedAt)&&(identical(other.sessionStartedAt, sessionStartedAt) || other.sessionStartedAt == sessionStartedAt)&&(identical(other.isMember, isMember) || other.isMember == isMember));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,description,backgroundUrl,type,color,const DeepCollectionEquality().hash(membersAvatars),activeMembers,maxMembers,isProtected,sessionType,plannedMinutes,pausedAt,sessionStartedAt,isMember);

@override
String toString() {
  return 'RoomModel(id: $id, name: $name, description: $description, backgroundUrl: $backgroundUrl, type: $type, color: $color, membersAvatars: $membersAvatars, activeMembers: $activeMembers, maxMembers: $maxMembers, isProtected: $isProtected, sessionType: $sessionType, plannedMinutes: $plannedMinutes, pausedAt: $pausedAt, sessionStartedAt: $sessionStartedAt, isMember: $isMember)';
}


}

/// @nodoc
abstract mixin class $RoomModelCopyWith<$Res>  {
  factory $RoomModelCopyWith(RoomModel value, $Res Function(RoomModel) _then) = _$RoomModelCopyWithImpl;
@useResult
$Res call({
 String id, String name, String? description,@JsonKey(name: 'background_url') String? backgroundUrl, String type, String color,@JsonKey(name: 'members_avatars') List<String> membersAvatars,@JsonKey(name: 'active_members') int activeMembers,@JsonKey(name: 'max_members') int maxMembers,@JsonKey(name: 'is_protected') bool isProtected,@JsonKey(name: 'session_type') SessionType? sessionType,@JsonKey(name: 'planned_minutes') int? plannedMinutes,@JsonKey(name: 'paused_at') DateTime? pausedAt,@JsonKey(name: 'session_started_at') DateTime? sessionStartedAt,@JsonKey(name: 'is_member') bool isMember
});




}
/// @nodoc
class _$RoomModelCopyWithImpl<$Res>
    implements $RoomModelCopyWith<$Res> {
  _$RoomModelCopyWithImpl(this._self, this._then);

  final RoomModel _self;
  final $Res Function(RoomModel) _then;

/// Create a copy of RoomModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? description = freezed,Object? backgroundUrl = freezed,Object? type = null,Object? color = null,Object? membersAvatars = null,Object? activeMembers = null,Object? maxMembers = null,Object? isProtected = null,Object? sessionType = freezed,Object? plannedMinutes = freezed,Object? pausedAt = freezed,Object? sessionStartedAt = freezed,Object? isMember = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,backgroundUrl: freezed == backgroundUrl ? _self.backgroundUrl : backgroundUrl // ignore: cast_nullable_to_non_nullable
as String?,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String,color: null == color ? _self.color : color // ignore: cast_nullable_to_non_nullable
as String,membersAvatars: null == membersAvatars ? _self.membersAvatars : membersAvatars // ignore: cast_nullable_to_non_nullable
as List<String>,activeMembers: null == activeMembers ? _self.activeMembers : activeMembers // ignore: cast_nullable_to_non_nullable
as int,maxMembers: null == maxMembers ? _self.maxMembers : maxMembers // ignore: cast_nullable_to_non_nullable
as int,isProtected: null == isProtected ? _self.isProtected : isProtected // ignore: cast_nullable_to_non_nullable
as bool,sessionType: freezed == sessionType ? _self.sessionType : sessionType // ignore: cast_nullable_to_non_nullable
as SessionType?,plannedMinutes: freezed == plannedMinutes ? _self.plannedMinutes : plannedMinutes // ignore: cast_nullable_to_non_nullable
as int?,pausedAt: freezed == pausedAt ? _self.pausedAt : pausedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,sessionStartedAt: freezed == sessionStartedAt ? _self.sessionStartedAt : sessionStartedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,isMember: null == isMember ? _self.isMember : isMember // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [RoomModel].
extension RoomModelPatterns on RoomModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _RoomModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _RoomModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _RoomModel value)  $default,){
final _that = this;
switch (_that) {
case _RoomModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _RoomModel value)?  $default,){
final _that = this;
switch (_that) {
case _RoomModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String name,  String? description, @JsonKey(name: 'background_url')  String? backgroundUrl,  String type,  String color, @JsonKey(name: 'members_avatars')  List<String> membersAvatars, @JsonKey(name: 'active_members')  int activeMembers, @JsonKey(name: 'max_members')  int maxMembers, @JsonKey(name: 'is_protected')  bool isProtected, @JsonKey(name: 'session_type')  SessionType? sessionType, @JsonKey(name: 'planned_minutes')  int? plannedMinutes, @JsonKey(name: 'paused_at')  DateTime? pausedAt, @JsonKey(name: 'session_started_at')  DateTime? sessionStartedAt, @JsonKey(name: 'is_member')  bool isMember)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _RoomModel() when $default != null:
return $default(_that.id,_that.name,_that.description,_that.backgroundUrl,_that.type,_that.color,_that.membersAvatars,_that.activeMembers,_that.maxMembers,_that.isProtected,_that.sessionType,_that.plannedMinutes,_that.pausedAt,_that.sessionStartedAt,_that.isMember);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String name,  String? description, @JsonKey(name: 'background_url')  String? backgroundUrl,  String type,  String color, @JsonKey(name: 'members_avatars')  List<String> membersAvatars, @JsonKey(name: 'active_members')  int activeMembers, @JsonKey(name: 'max_members')  int maxMembers, @JsonKey(name: 'is_protected')  bool isProtected, @JsonKey(name: 'session_type')  SessionType? sessionType, @JsonKey(name: 'planned_minutes')  int? plannedMinutes, @JsonKey(name: 'paused_at')  DateTime? pausedAt, @JsonKey(name: 'session_started_at')  DateTime? sessionStartedAt, @JsonKey(name: 'is_member')  bool isMember)  $default,) {final _that = this;
switch (_that) {
case _RoomModel():
return $default(_that.id,_that.name,_that.description,_that.backgroundUrl,_that.type,_that.color,_that.membersAvatars,_that.activeMembers,_that.maxMembers,_that.isProtected,_that.sessionType,_that.plannedMinutes,_that.pausedAt,_that.sessionStartedAt,_that.isMember);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String name,  String? description, @JsonKey(name: 'background_url')  String? backgroundUrl,  String type,  String color, @JsonKey(name: 'members_avatars')  List<String> membersAvatars, @JsonKey(name: 'active_members')  int activeMembers, @JsonKey(name: 'max_members')  int maxMembers, @JsonKey(name: 'is_protected')  bool isProtected, @JsonKey(name: 'session_type')  SessionType? sessionType, @JsonKey(name: 'planned_minutes')  int? plannedMinutes, @JsonKey(name: 'paused_at')  DateTime? pausedAt, @JsonKey(name: 'session_started_at')  DateTime? sessionStartedAt, @JsonKey(name: 'is_member')  bool isMember)?  $default,) {final _that = this;
switch (_that) {
case _RoomModel() when $default != null:
return $default(_that.id,_that.name,_that.description,_that.backgroundUrl,_that.type,_that.color,_that.membersAvatars,_that.activeMembers,_that.maxMembers,_that.isProtected,_that.sessionType,_that.plannedMinutes,_that.pausedAt,_that.sessionStartedAt,_that.isMember);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _RoomModel extends RoomModel {
  const _RoomModel({required this.id, required this.name, this.description, @JsonKey(name: 'background_url') this.backgroundUrl, required this.type, required this.color, @JsonKey(name: 'members_avatars') required final  List<String> membersAvatars, @JsonKey(name: 'active_members') required this.activeMembers, @JsonKey(name: 'max_members') required this.maxMembers, @JsonKey(name: 'is_protected') required this.isProtected, @JsonKey(name: 'session_type') this.sessionType, @JsonKey(name: 'planned_minutes') this.plannedMinutes, @JsonKey(name: 'paused_at') this.pausedAt, @JsonKey(name: 'session_started_at') this.sessionStartedAt, @JsonKey(name: 'is_member') required this.isMember}): _membersAvatars = membersAvatars,super._();
  factory _RoomModel.fromJson(Map<String, dynamic> json) => _$RoomModelFromJson(json);

@override final  String id;
@override final  String name;
@override final  String? description;
@override@JsonKey(name: 'background_url') final  String? backgroundUrl;
@override final  String type;
@override final  String color;
 final  List<String> _membersAvatars;
@override@JsonKey(name: 'members_avatars') List<String> get membersAvatars {
  if (_membersAvatars is EqualUnmodifiableListView) return _membersAvatars;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_membersAvatars);
}

@override@JsonKey(name: 'active_members') final  int activeMembers;
@override@JsonKey(name: 'max_members') final  int maxMembers;
@override@JsonKey(name: 'is_protected') final  bool isProtected;
@override@JsonKey(name: 'session_type') final  SessionType? sessionType;
@override@JsonKey(name: 'planned_minutes') final  int? plannedMinutes;
@override@JsonKey(name: 'paused_at') final  DateTime? pausedAt;
@override@JsonKey(name: 'session_started_at') final  DateTime? sessionStartedAt;
@override@JsonKey(name: 'is_member') final  bool isMember;

/// Create a copy of RoomModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$RoomModelCopyWith<_RoomModel> get copyWith => __$RoomModelCopyWithImpl<_RoomModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$RoomModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _RoomModel&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.description, description) || other.description == description)&&(identical(other.backgroundUrl, backgroundUrl) || other.backgroundUrl == backgroundUrl)&&(identical(other.type, type) || other.type == type)&&(identical(other.color, color) || other.color == color)&&const DeepCollectionEquality().equals(other._membersAvatars, _membersAvatars)&&(identical(other.activeMembers, activeMembers) || other.activeMembers == activeMembers)&&(identical(other.maxMembers, maxMembers) || other.maxMembers == maxMembers)&&(identical(other.isProtected, isProtected) || other.isProtected == isProtected)&&(identical(other.sessionType, sessionType) || other.sessionType == sessionType)&&(identical(other.plannedMinutes, plannedMinutes) || other.plannedMinutes == plannedMinutes)&&(identical(other.pausedAt, pausedAt) || other.pausedAt == pausedAt)&&(identical(other.sessionStartedAt, sessionStartedAt) || other.sessionStartedAt == sessionStartedAt)&&(identical(other.isMember, isMember) || other.isMember == isMember));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,description,backgroundUrl,type,color,const DeepCollectionEquality().hash(_membersAvatars),activeMembers,maxMembers,isProtected,sessionType,plannedMinutes,pausedAt,sessionStartedAt,isMember);

@override
String toString() {
  return 'RoomModel(id: $id, name: $name, description: $description, backgroundUrl: $backgroundUrl, type: $type, color: $color, membersAvatars: $membersAvatars, activeMembers: $activeMembers, maxMembers: $maxMembers, isProtected: $isProtected, sessionType: $sessionType, plannedMinutes: $plannedMinutes, pausedAt: $pausedAt, sessionStartedAt: $sessionStartedAt, isMember: $isMember)';
}


}

/// @nodoc
abstract mixin class _$RoomModelCopyWith<$Res> implements $RoomModelCopyWith<$Res> {
  factory _$RoomModelCopyWith(_RoomModel value, $Res Function(_RoomModel) _then) = __$RoomModelCopyWithImpl;
@override @useResult
$Res call({
 String id, String name, String? description,@JsonKey(name: 'background_url') String? backgroundUrl, String type, String color,@JsonKey(name: 'members_avatars') List<String> membersAvatars,@JsonKey(name: 'active_members') int activeMembers,@JsonKey(name: 'max_members') int maxMembers,@JsonKey(name: 'is_protected') bool isProtected,@JsonKey(name: 'session_type') SessionType? sessionType,@JsonKey(name: 'planned_minutes') int? plannedMinutes,@JsonKey(name: 'paused_at') DateTime? pausedAt,@JsonKey(name: 'session_started_at') DateTime? sessionStartedAt,@JsonKey(name: 'is_member') bool isMember
});




}
/// @nodoc
class __$RoomModelCopyWithImpl<$Res>
    implements _$RoomModelCopyWith<$Res> {
  __$RoomModelCopyWithImpl(this._self, this._then);

  final _RoomModel _self;
  final $Res Function(_RoomModel) _then;

/// Create a copy of RoomModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? description = freezed,Object? backgroundUrl = freezed,Object? type = null,Object? color = null,Object? membersAvatars = null,Object? activeMembers = null,Object? maxMembers = null,Object? isProtected = null,Object? sessionType = freezed,Object? plannedMinutes = freezed,Object? pausedAt = freezed,Object? sessionStartedAt = freezed,Object? isMember = null,}) {
  return _then(_RoomModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,backgroundUrl: freezed == backgroundUrl ? _self.backgroundUrl : backgroundUrl // ignore: cast_nullable_to_non_nullable
as String?,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String,color: null == color ? _self.color : color // ignore: cast_nullable_to_non_nullable
as String,membersAvatars: null == membersAvatars ? _self._membersAvatars : membersAvatars // ignore: cast_nullable_to_non_nullable
as List<String>,activeMembers: null == activeMembers ? _self.activeMembers : activeMembers // ignore: cast_nullable_to_non_nullable
as int,maxMembers: null == maxMembers ? _self.maxMembers : maxMembers // ignore: cast_nullable_to_non_nullable
as int,isProtected: null == isProtected ? _self.isProtected : isProtected // ignore: cast_nullable_to_non_nullable
as bool,sessionType: freezed == sessionType ? _self.sessionType : sessionType // ignore: cast_nullable_to_non_nullable
as SessionType?,plannedMinutes: freezed == plannedMinutes ? _self.plannedMinutes : plannedMinutes // ignore: cast_nullable_to_non_nullable
as int?,pausedAt: freezed == pausedAt ? _self.pausedAt : pausedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,sessionStartedAt: freezed == sessionStartedAt ? _self.sessionStartedAt : sessionStartedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,isMember: null == isMember ? _self.isMember : isMember // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
