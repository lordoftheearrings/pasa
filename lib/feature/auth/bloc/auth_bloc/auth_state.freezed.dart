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





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AuthState);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'AuthState()';
}


}

/// @nodoc
class $AuthStateCopyWith<$Res>  {
$AuthStateCopyWith(AuthState _, $Res Function(AuthState) __);
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( AuthInitial value)?  initial,TResult Function( AuthLoading value)?  loading,TResult Function( AuthUnauthenticated value)?  unauthenticated,TResult Function( AuthVerificationNeeded value)?  verificationNeeded,TResult Function( AuthVerificationNeededFromSignIn value)?  verificationNeededfromSignIn,TResult Function( AuthAuthenticated value)?  authenticated,TResult Function( AuthOtpResent value)?  otpResent,TResult Function( AuthError value)?  error,required TResult orElse(),}){
final _that = this;
switch (_that) {
case AuthInitial() when initial != null:
return initial(_that);case AuthLoading() when loading != null:
return loading(_that);case AuthUnauthenticated() when unauthenticated != null:
return unauthenticated(_that);case AuthVerificationNeeded() when verificationNeeded != null:
return verificationNeeded(_that);case AuthVerificationNeededFromSignIn() when verificationNeededfromSignIn != null:
return verificationNeededfromSignIn(_that);case AuthAuthenticated() when authenticated != null:
return authenticated(_that);case AuthOtpResent() when otpResent != null:
return otpResent(_that);case AuthError() when error != null:
return error(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( AuthInitial value)  initial,required TResult Function( AuthLoading value)  loading,required TResult Function( AuthUnauthenticated value)  unauthenticated,required TResult Function( AuthVerificationNeeded value)  verificationNeeded,required TResult Function( AuthVerificationNeededFromSignIn value)  verificationNeededfromSignIn,required TResult Function( AuthAuthenticated value)  authenticated,required TResult Function( AuthOtpResent value)  otpResent,required TResult Function( AuthError value)  error,}){
final _that = this;
switch (_that) {
case AuthInitial():
return initial(_that);case AuthLoading():
return loading(_that);case AuthUnauthenticated():
return unauthenticated(_that);case AuthVerificationNeeded():
return verificationNeeded(_that);case AuthVerificationNeededFromSignIn():
return verificationNeededfromSignIn(_that);case AuthAuthenticated():
return authenticated(_that);case AuthOtpResent():
return otpResent(_that);case AuthError():
return error(_that);case _:
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( AuthInitial value)?  initial,TResult? Function( AuthLoading value)?  loading,TResult? Function( AuthUnauthenticated value)?  unauthenticated,TResult? Function( AuthVerificationNeeded value)?  verificationNeeded,TResult? Function( AuthVerificationNeededFromSignIn value)?  verificationNeededfromSignIn,TResult? Function( AuthAuthenticated value)?  authenticated,TResult? Function( AuthOtpResent value)?  otpResent,TResult? Function( AuthError value)?  error,}){
final _that = this;
switch (_that) {
case AuthInitial() when initial != null:
return initial(_that);case AuthLoading() when loading != null:
return loading(_that);case AuthUnauthenticated() when unauthenticated != null:
return unauthenticated(_that);case AuthVerificationNeeded() when verificationNeeded != null:
return verificationNeeded(_that);case AuthVerificationNeededFromSignIn() when verificationNeededfromSignIn != null:
return verificationNeededfromSignIn(_that);case AuthAuthenticated() when authenticated != null:
return authenticated(_that);case AuthOtpResent() when otpResent != null:
return otpResent(_that);case AuthError() when error != null:
return error(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  initial,TResult Function()?  loading,TResult Function()?  unauthenticated,TResult Function( UserData user)?  verificationNeeded,TResult Function( String email)?  verificationNeededfromSignIn,TResult Function( UserData user)?  authenticated,TResult Function( int resendId)?  otpResent,TResult Function( String message)?  error,required TResult orElse(),}) {final _that = this;
switch (_that) {
case AuthInitial() when initial != null:
return initial();case AuthLoading() when loading != null:
return loading();case AuthUnauthenticated() when unauthenticated != null:
return unauthenticated();case AuthVerificationNeeded() when verificationNeeded != null:
return verificationNeeded(_that.user);case AuthVerificationNeededFromSignIn() when verificationNeededfromSignIn != null:
return verificationNeededfromSignIn(_that.email);case AuthAuthenticated() when authenticated != null:
return authenticated(_that.user);case AuthOtpResent() when otpResent != null:
return otpResent(_that.resendId);case AuthError() when error != null:
return error(_that.message);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  initial,required TResult Function()  loading,required TResult Function()  unauthenticated,required TResult Function( UserData user)  verificationNeeded,required TResult Function( String email)  verificationNeededfromSignIn,required TResult Function( UserData user)  authenticated,required TResult Function( int resendId)  otpResent,required TResult Function( String message)  error,}) {final _that = this;
switch (_that) {
case AuthInitial():
return initial();case AuthLoading():
return loading();case AuthUnauthenticated():
return unauthenticated();case AuthVerificationNeeded():
return verificationNeeded(_that.user);case AuthVerificationNeededFromSignIn():
return verificationNeededfromSignIn(_that.email);case AuthAuthenticated():
return authenticated(_that.user);case AuthOtpResent():
return otpResent(_that.resendId);case AuthError():
return error(_that.message);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  initial,TResult? Function()?  loading,TResult? Function()?  unauthenticated,TResult? Function( UserData user)?  verificationNeeded,TResult? Function( String email)?  verificationNeededfromSignIn,TResult? Function( UserData user)?  authenticated,TResult? Function( int resendId)?  otpResent,TResult? Function( String message)?  error,}) {final _that = this;
switch (_that) {
case AuthInitial() when initial != null:
return initial();case AuthLoading() when loading != null:
return loading();case AuthUnauthenticated() when unauthenticated != null:
return unauthenticated();case AuthVerificationNeeded() when verificationNeeded != null:
return verificationNeeded(_that.user);case AuthVerificationNeededFromSignIn() when verificationNeededfromSignIn != null:
return verificationNeededfromSignIn(_that.email);case AuthAuthenticated() when authenticated != null:
return authenticated(_that.user);case AuthOtpResent() when otpResent != null:
return otpResent(_that.resendId);case AuthError() when error != null:
return error(_that.message);case _:
  return null;

}
}

}

/// @nodoc


class AuthInitial implements AuthState {
  const AuthInitial();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AuthInitial);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'AuthState.initial()';
}


}




/// @nodoc


class AuthLoading implements AuthState {
  const AuthLoading();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AuthLoading);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'AuthState.loading()';
}


}




/// @nodoc


class AuthUnauthenticated implements AuthState {
  const AuthUnauthenticated();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AuthUnauthenticated);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'AuthState.unauthenticated()';
}


}




/// @nodoc


class AuthVerificationNeeded implements AuthState {
  const AuthVerificationNeeded(this.user);
  

 final  UserData user;

/// Create a copy of AuthState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AuthVerificationNeededCopyWith<AuthVerificationNeeded> get copyWith => _$AuthVerificationNeededCopyWithImpl<AuthVerificationNeeded>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AuthVerificationNeeded&&const DeepCollectionEquality().equals(other.user, user));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(user));

@override
String toString() {
  return 'AuthState.verificationNeeded(user: $user)';
}


}

/// @nodoc
abstract mixin class $AuthVerificationNeededCopyWith<$Res> implements $AuthStateCopyWith<$Res> {
  factory $AuthVerificationNeededCopyWith(AuthVerificationNeeded value, $Res Function(AuthVerificationNeeded) _then) = _$AuthVerificationNeededCopyWithImpl;
@useResult
$Res call({
 UserData user
});




}
/// @nodoc
class _$AuthVerificationNeededCopyWithImpl<$Res>
    implements $AuthVerificationNeededCopyWith<$Res> {
  _$AuthVerificationNeededCopyWithImpl(this._self, this._then);

  final AuthVerificationNeeded _self;
  final $Res Function(AuthVerificationNeeded) _then;

/// Create a copy of AuthState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? user = freezed,}) {
  return _then(AuthVerificationNeeded(
freezed == user ? _self.user : user // ignore: cast_nullable_to_non_nullable
as UserData,
  ));
}


}

/// @nodoc


class AuthVerificationNeededFromSignIn implements AuthState {
  const AuthVerificationNeededFromSignIn(this.email);
  

 final  String email;

/// Create a copy of AuthState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AuthVerificationNeededFromSignInCopyWith<AuthVerificationNeededFromSignIn> get copyWith => _$AuthVerificationNeededFromSignInCopyWithImpl<AuthVerificationNeededFromSignIn>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AuthVerificationNeededFromSignIn&&(identical(other.email, email) || other.email == email));
}


@override
int get hashCode => Object.hash(runtimeType,email);

@override
String toString() {
  return 'AuthState.verificationNeededfromSignIn(email: $email)';
}


}

/// @nodoc
abstract mixin class $AuthVerificationNeededFromSignInCopyWith<$Res> implements $AuthStateCopyWith<$Res> {
  factory $AuthVerificationNeededFromSignInCopyWith(AuthVerificationNeededFromSignIn value, $Res Function(AuthVerificationNeededFromSignIn) _then) = _$AuthVerificationNeededFromSignInCopyWithImpl;
@useResult
$Res call({
 String email
});




}
/// @nodoc
class _$AuthVerificationNeededFromSignInCopyWithImpl<$Res>
    implements $AuthVerificationNeededFromSignInCopyWith<$Res> {
  _$AuthVerificationNeededFromSignInCopyWithImpl(this._self, this._then);

  final AuthVerificationNeededFromSignIn _self;
  final $Res Function(AuthVerificationNeededFromSignIn) _then;

/// Create a copy of AuthState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? email = null,}) {
  return _then(AuthVerificationNeededFromSignIn(
null == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc


class AuthAuthenticated implements AuthState {
  const AuthAuthenticated(this.user);
  

 final  UserData user;

/// Create a copy of AuthState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AuthAuthenticatedCopyWith<AuthAuthenticated> get copyWith => _$AuthAuthenticatedCopyWithImpl<AuthAuthenticated>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AuthAuthenticated&&const DeepCollectionEquality().equals(other.user, user));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(user));

@override
String toString() {
  return 'AuthState.authenticated(user: $user)';
}


}

/// @nodoc
abstract mixin class $AuthAuthenticatedCopyWith<$Res> implements $AuthStateCopyWith<$Res> {
  factory $AuthAuthenticatedCopyWith(AuthAuthenticated value, $Res Function(AuthAuthenticated) _then) = _$AuthAuthenticatedCopyWithImpl;
@useResult
$Res call({
 UserData user
});




}
/// @nodoc
class _$AuthAuthenticatedCopyWithImpl<$Res>
    implements $AuthAuthenticatedCopyWith<$Res> {
  _$AuthAuthenticatedCopyWithImpl(this._self, this._then);

  final AuthAuthenticated _self;
  final $Res Function(AuthAuthenticated) _then;

/// Create a copy of AuthState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? user = freezed,}) {
  return _then(AuthAuthenticated(
freezed == user ? _self.user : user // ignore: cast_nullable_to_non_nullable
as UserData,
  ));
}


}

/// @nodoc


class AuthOtpResent implements AuthState {
  const AuthOtpResent({this.resendId = 0});
  

@JsonKey() final  int resendId;

/// Create a copy of AuthState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AuthOtpResentCopyWith<AuthOtpResent> get copyWith => _$AuthOtpResentCopyWithImpl<AuthOtpResent>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AuthOtpResent&&(identical(other.resendId, resendId) || other.resendId == resendId));
}


@override
int get hashCode => Object.hash(runtimeType,resendId);

@override
String toString() {
  return 'AuthState.otpResent(resendId: $resendId)';
}


}

/// @nodoc
abstract mixin class $AuthOtpResentCopyWith<$Res> implements $AuthStateCopyWith<$Res> {
  factory $AuthOtpResentCopyWith(AuthOtpResent value, $Res Function(AuthOtpResent) _then) = _$AuthOtpResentCopyWithImpl;
@useResult
$Res call({
 int resendId
});




}
/// @nodoc
class _$AuthOtpResentCopyWithImpl<$Res>
    implements $AuthOtpResentCopyWith<$Res> {
  _$AuthOtpResentCopyWithImpl(this._self, this._then);

  final AuthOtpResent _self;
  final $Res Function(AuthOtpResent) _then;

/// Create a copy of AuthState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? resendId = null,}) {
  return _then(AuthOtpResent(
resendId: null == resendId ? _self.resendId : resendId // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

/// @nodoc


class AuthError implements AuthState {
  const AuthError(this.message);
  

 final  String message;

/// Create a copy of AuthState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AuthErrorCopyWith<AuthError> get copyWith => _$AuthErrorCopyWithImpl<AuthError>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AuthError&&(identical(other.message, message) || other.message == message));
}


@override
int get hashCode => Object.hash(runtimeType,message);

@override
String toString() {
  return 'AuthState.error(message: $message)';
}


}

/// @nodoc
abstract mixin class $AuthErrorCopyWith<$Res> implements $AuthStateCopyWith<$Res> {
  factory $AuthErrorCopyWith(AuthError value, $Res Function(AuthError) _then) = _$AuthErrorCopyWithImpl;
@useResult
$Res call({
 String message
});




}
/// @nodoc
class _$AuthErrorCopyWithImpl<$Res>
    implements $AuthErrorCopyWith<$Res> {
  _$AuthErrorCopyWithImpl(this._self, this._then);

  final AuthError _self;
  final $Res Function(AuthError) _then;

/// Create a copy of AuthState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? message = null,}) {
  return _then(AuthError(
null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
