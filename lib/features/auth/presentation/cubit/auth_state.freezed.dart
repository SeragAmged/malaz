// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'auth_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$AuthState {

 AuthStatus get authStatus; UiState get uiState; ScreenState get screenState; User? get user; String? get errorMessage; List<String> get avatarUrls; bool get isLoadingAvatars; int get selectedAvatarIndex;
/// Create a copy of AuthState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AuthStateCopyWith<AuthState> get copyWith => _$AuthStateCopyWithImpl<AuthState>(this as AuthState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AuthState&&(identical(other.authStatus, authStatus) || other.authStatus == authStatus)&&(identical(other.uiState, uiState) || other.uiState == uiState)&&(identical(other.screenState, screenState) || other.screenState == screenState)&&(identical(other.user, user) || other.user == user)&&(identical(other.errorMessage, errorMessage) || other.errorMessage == errorMessage)&&const DeepCollectionEquality().equals(other.avatarUrls, avatarUrls)&&(identical(other.isLoadingAvatars, isLoadingAvatars) || other.isLoadingAvatars == isLoadingAvatars)&&(identical(other.selectedAvatarIndex, selectedAvatarIndex) || other.selectedAvatarIndex == selectedAvatarIndex));
}


@override
int get hashCode => Object.hash(runtimeType,authStatus,uiState,screenState,user,errorMessage,const DeepCollectionEquality().hash(avatarUrls),isLoadingAvatars,selectedAvatarIndex);

@override
String toString() {
  return 'AuthState(authStatus: $authStatus, uiState: $uiState, screenState: $screenState, user: $user, errorMessage: $errorMessage, avatarUrls: $avatarUrls, isLoadingAvatars: $isLoadingAvatars, selectedAvatarIndex: $selectedAvatarIndex)';
}


}

/// @nodoc
abstract mixin class $AuthStateCopyWith<$Res>  {
  factory $AuthStateCopyWith(AuthState value, $Res Function(AuthState) _then) = _$AuthStateCopyWithImpl;
@useResult
$Res call({
 AuthStatus authStatus, UiState uiState, ScreenState screenState, User? user, String? errorMessage, List<String> avatarUrls, bool isLoadingAvatars, int selectedAvatarIndex
});




}
/// @nodoc
class _$AuthStateCopyWithImpl<$Res>
    implements $AuthStateCopyWith<$Res> {
  _$AuthStateCopyWithImpl(this._self, this._then);

  final AuthState _self;
  final $Res Function(AuthState) _then;

/// Create a copy of AuthState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? authStatus = null,Object? uiState = null,Object? screenState = null,Object? user = freezed,Object? errorMessage = freezed,Object? avatarUrls = null,Object? isLoadingAvatars = null,Object? selectedAvatarIndex = null,}) {
  return _then(_self.copyWith(
authStatus: null == authStatus ? _self.authStatus : authStatus // ignore: cast_nullable_to_non_nullable
as AuthStatus,uiState: null == uiState ? _self.uiState : uiState // ignore: cast_nullable_to_non_nullable
as UiState,screenState: null == screenState ? _self.screenState : screenState // ignore: cast_nullable_to_non_nullable
as ScreenState,user: freezed == user ? _self.user : user // ignore: cast_nullable_to_non_nullable
as User?,errorMessage: freezed == errorMessage ? _self.errorMessage : errorMessage // ignore: cast_nullable_to_non_nullable
as String?,avatarUrls: null == avatarUrls ? _self.avatarUrls : avatarUrls // ignore: cast_nullable_to_non_nullable
as List<String>,isLoadingAvatars: null == isLoadingAvatars ? _self.isLoadingAvatars : isLoadingAvatars // ignore: cast_nullable_to_non_nullable
as bool,selectedAvatarIndex: null == selectedAvatarIndex ? _self.selectedAvatarIndex : selectedAvatarIndex // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [AuthState].
extension AuthStatePatterns on AuthState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AuthState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AuthState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AuthState value)  $default,){
final _that = this;
switch (_that) {
case _AuthState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AuthState value)?  $default,){
final _that = this;
switch (_that) {
case _AuthState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( AuthStatus authStatus,  UiState uiState,  ScreenState screenState,  User? user,  String? errorMessage,  List<String> avatarUrls,  bool isLoadingAvatars,  int selectedAvatarIndex)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AuthState() when $default != null:
return $default(_that.authStatus,_that.uiState,_that.screenState,_that.user,_that.errorMessage,_that.avatarUrls,_that.isLoadingAvatars,_that.selectedAvatarIndex);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( AuthStatus authStatus,  UiState uiState,  ScreenState screenState,  User? user,  String? errorMessage,  List<String> avatarUrls,  bool isLoadingAvatars,  int selectedAvatarIndex)  $default,) {final _that = this;
switch (_that) {
case _AuthState():
return $default(_that.authStatus,_that.uiState,_that.screenState,_that.user,_that.errorMessage,_that.avatarUrls,_that.isLoadingAvatars,_that.selectedAvatarIndex);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( AuthStatus authStatus,  UiState uiState,  ScreenState screenState,  User? user,  String? errorMessage,  List<String> avatarUrls,  bool isLoadingAvatars,  int selectedAvatarIndex)?  $default,) {final _that = this;
switch (_that) {
case _AuthState() when $default != null:
return $default(_that.authStatus,_that.uiState,_that.screenState,_that.user,_that.errorMessage,_that.avatarUrls,_that.isLoadingAvatars,_that.selectedAvatarIndex);case _:
  return null;

}
}

}

/// @nodoc


class _AuthState extends AuthState {
  const _AuthState({this.authStatus = AuthStatus.initial, this.uiState = UiState.initial, this.screenState = ScreenState.initial, this.user, this.errorMessage, final  List<String> avatarUrls = const [], this.isLoadingAvatars = false, this.selectedAvatarIndex = 0}): _avatarUrls = avatarUrls,super._();
  

@override@JsonKey() final  AuthStatus authStatus;
@override@JsonKey() final  UiState uiState;
@override@JsonKey() final  ScreenState screenState;
@override final  User? user;
@override final  String? errorMessage;
 final  List<String> _avatarUrls;
@override@JsonKey() List<String> get avatarUrls {
  if (_avatarUrls is EqualUnmodifiableListView) return _avatarUrls;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_avatarUrls);
}

@override@JsonKey() final  bool isLoadingAvatars;
@override@JsonKey() final  int selectedAvatarIndex;

/// Create a copy of AuthState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AuthStateCopyWith<_AuthState> get copyWith => __$AuthStateCopyWithImpl<_AuthState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AuthState&&(identical(other.authStatus, authStatus) || other.authStatus == authStatus)&&(identical(other.uiState, uiState) || other.uiState == uiState)&&(identical(other.screenState, screenState) || other.screenState == screenState)&&(identical(other.user, user) || other.user == user)&&(identical(other.errorMessage, errorMessage) || other.errorMessage == errorMessage)&&const DeepCollectionEquality().equals(other._avatarUrls, _avatarUrls)&&(identical(other.isLoadingAvatars, isLoadingAvatars) || other.isLoadingAvatars == isLoadingAvatars)&&(identical(other.selectedAvatarIndex, selectedAvatarIndex) || other.selectedAvatarIndex == selectedAvatarIndex));
}


@override
int get hashCode => Object.hash(runtimeType,authStatus,uiState,screenState,user,errorMessage,const DeepCollectionEquality().hash(_avatarUrls),isLoadingAvatars,selectedAvatarIndex);

@override
String toString() {
  return 'AuthState(authStatus: $authStatus, uiState: $uiState, screenState: $screenState, user: $user, errorMessage: $errorMessage, avatarUrls: $avatarUrls, isLoadingAvatars: $isLoadingAvatars, selectedAvatarIndex: $selectedAvatarIndex)';
}


}

/// @nodoc
abstract mixin class _$AuthStateCopyWith<$Res> implements $AuthStateCopyWith<$Res> {
  factory _$AuthStateCopyWith(_AuthState value, $Res Function(_AuthState) _then) = __$AuthStateCopyWithImpl;
@override @useResult
$Res call({
 AuthStatus authStatus, UiState uiState, ScreenState screenState, User? user, String? errorMessage, List<String> avatarUrls, bool isLoadingAvatars, int selectedAvatarIndex
});




}
/// @nodoc
class __$AuthStateCopyWithImpl<$Res>
    implements _$AuthStateCopyWith<$Res> {
  __$AuthStateCopyWithImpl(this._self, this._then);

  final _AuthState _self;
  final $Res Function(_AuthState) _then;

/// Create a copy of AuthState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? authStatus = null,Object? uiState = null,Object? screenState = null,Object? user = freezed,Object? errorMessage = freezed,Object? avatarUrls = null,Object? isLoadingAvatars = null,Object? selectedAvatarIndex = null,}) {
  return _then(_AuthState(
authStatus: null == authStatus ? _self.authStatus : authStatus // ignore: cast_nullable_to_non_nullable
as AuthStatus,uiState: null == uiState ? _self.uiState : uiState // ignore: cast_nullable_to_non_nullable
as UiState,screenState: null == screenState ? _self.screenState : screenState // ignore: cast_nullable_to_non_nullable
as ScreenState,user: freezed == user ? _self.user : user // ignore: cast_nullable_to_non_nullable
as User?,errorMessage: freezed == errorMessage ? _self.errorMessage : errorMessage // ignore: cast_nullable_to_non_nullable
as String?,avatarUrls: null == avatarUrls ? _self._avatarUrls : avatarUrls // ignore: cast_nullable_to_non_nullable
as List<String>,isLoadingAvatars: null == isLoadingAvatars ? _self.isLoadingAvatars : isLoadingAvatars // ignore: cast_nullable_to_non_nullable
as bool,selectedAvatarIndex: null == selectedAvatarIndex ? _self.selectedAvatarIndex : selectedAvatarIndex // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
