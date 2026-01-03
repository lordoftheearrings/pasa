// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'auth_event.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$AuthEvent {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AuthEvent);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'AuthEvent()';
}


}

/// @nodoc
class $AuthEventCopyWith<$Res>  {
$AuthEventCopyWith(AuthEvent _, $Res Function(AuthEvent) __);
}


/// Adds pattern-matching-related methods to [AuthEvent].
extension AuthEventPatterns on AuthEvent {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( AuthEventSignIn value)?  signIn,TResult Function( AuthEventSignUp value)?  signUp,TResult Function( AuthEventSessionRestored value)?  sessionRestored,TResult Function( AuthEventCompleteSignup value)?  completeSignup,TResult Function( AuthEventResendEmailConfirmation value)?  resendEmailConfirmation,TResult Function( AuthEventResendEmailConfirmationSignIn value)?  resendEmailConfirmationSignIn,required TResult orElse(),}){
final _that = this;
switch (_that) {
case AuthEventSignIn() when signIn != null:
return signIn(_that);case AuthEventSignUp() when signUp != null:
return signUp(_that);case AuthEventSessionRestored() when sessionRestored != null:
return sessionRestored(_that);case AuthEventCompleteSignup() when completeSignup != null:
return completeSignup(_that);case AuthEventResendEmailConfirmation() when resendEmailConfirmation != null:
return resendEmailConfirmation(_that);case AuthEventResendEmailConfirmationSignIn() when resendEmailConfirmationSignIn != null:
return resendEmailConfirmationSignIn(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( AuthEventSignIn value)  signIn,required TResult Function( AuthEventSignUp value)  signUp,required TResult Function( AuthEventSessionRestored value)  sessionRestored,required TResult Function( AuthEventCompleteSignup value)  completeSignup,required TResult Function( AuthEventResendEmailConfirmation value)  resendEmailConfirmation,required TResult Function( AuthEventResendEmailConfirmationSignIn value)  resendEmailConfirmationSignIn,}){
final _that = this;
switch (_that) {
case AuthEventSignIn():
return signIn(_that);case AuthEventSignUp():
return signUp(_that);case AuthEventSessionRestored():
return sessionRestored(_that);case AuthEventCompleteSignup():
return completeSignup(_that);case AuthEventResendEmailConfirmation():
return resendEmailConfirmation(_that);case AuthEventResendEmailConfirmationSignIn():
return resendEmailConfirmationSignIn(_that);case _:
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( AuthEventSignIn value)?  signIn,TResult? Function( AuthEventSignUp value)?  signUp,TResult? Function( AuthEventSessionRestored value)?  sessionRestored,TResult? Function( AuthEventCompleteSignup value)?  completeSignup,TResult? Function( AuthEventResendEmailConfirmation value)?  resendEmailConfirmation,TResult? Function( AuthEventResendEmailConfirmationSignIn value)?  resendEmailConfirmationSignIn,}){
final _that = this;
switch (_that) {
case AuthEventSignIn() when signIn != null:
return signIn(_that);case AuthEventSignUp() when signUp != null:
return signUp(_that);case AuthEventSessionRestored() when sessionRestored != null:
return sessionRestored(_that);case AuthEventCompleteSignup() when completeSignup != null:
return completeSignup(_that);case AuthEventResendEmailConfirmation() when resendEmailConfirmation != null:
return resendEmailConfirmation(_that);case AuthEventResendEmailConfirmationSignIn() when resendEmailConfirmationSignIn != null:
return resendEmailConfirmationSignIn(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function( String email,  String password)?  signIn,TResult Function( String password,  SignupModel signupData)?  signUp,TResult Function( Session session)?  sessionRestored,TResult Function( Session session)?  completeSignup,TResult Function( String email)?  resendEmailConfirmation,TResult Function( String email)?  resendEmailConfirmationSignIn,required TResult orElse(),}) {final _that = this;
switch (_that) {
case AuthEventSignIn() when signIn != null:
return signIn(_that.email,_that.password);case AuthEventSignUp() when signUp != null:
return signUp(_that.password,_that.signupData);case AuthEventSessionRestored() when sessionRestored != null:
return sessionRestored(_that.session);case AuthEventCompleteSignup() when completeSignup != null:
return completeSignup(_that.session);case AuthEventResendEmailConfirmation() when resendEmailConfirmation != null:
return resendEmailConfirmation(_that.email);case AuthEventResendEmailConfirmationSignIn() when resendEmailConfirmationSignIn != null:
return resendEmailConfirmationSignIn(_that.email);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function( String email,  String password)  signIn,required TResult Function( String password,  SignupModel signupData)  signUp,required TResult Function( Session session)  sessionRestored,required TResult Function( Session session)  completeSignup,required TResult Function( String email)  resendEmailConfirmation,required TResult Function( String email)  resendEmailConfirmationSignIn,}) {final _that = this;
switch (_that) {
case AuthEventSignIn():
return signIn(_that.email,_that.password);case AuthEventSignUp():
return signUp(_that.password,_that.signupData);case AuthEventSessionRestored():
return sessionRestored(_that.session);case AuthEventCompleteSignup():
return completeSignup(_that.session);case AuthEventResendEmailConfirmation():
return resendEmailConfirmation(_that.email);case AuthEventResendEmailConfirmationSignIn():
return resendEmailConfirmationSignIn(_that.email);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function( String email,  String password)?  signIn,TResult? Function( String password,  SignupModel signupData)?  signUp,TResult? Function( Session session)?  sessionRestored,TResult? Function( Session session)?  completeSignup,TResult? Function( String email)?  resendEmailConfirmation,TResult? Function( String email)?  resendEmailConfirmationSignIn,}) {final _that = this;
switch (_that) {
case AuthEventSignIn() when signIn != null:
return signIn(_that.email,_that.password);case AuthEventSignUp() when signUp != null:
return signUp(_that.password,_that.signupData);case AuthEventSessionRestored() when sessionRestored != null:
return sessionRestored(_that.session);case AuthEventCompleteSignup() when completeSignup != null:
return completeSignup(_that.session);case AuthEventResendEmailConfirmation() when resendEmailConfirmation != null:
return resendEmailConfirmation(_that.email);case AuthEventResendEmailConfirmationSignIn() when resendEmailConfirmationSignIn != null:
return resendEmailConfirmationSignIn(_that.email);case _:
  return null;

}
}

}

/// @nodoc


class AuthEventSignIn implements AuthEvent {
  const AuthEventSignIn({required this.email, required this.password});
  

 final  String email;
 final  String password;

/// Create a copy of AuthEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AuthEventSignInCopyWith<AuthEventSignIn> get copyWith => _$AuthEventSignInCopyWithImpl<AuthEventSignIn>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AuthEventSignIn&&(identical(other.email, email) || other.email == email)&&(identical(other.password, password) || other.password == password));
}


@override
int get hashCode => Object.hash(runtimeType,email,password);

@override
String toString() {
  return 'AuthEvent.signIn(email: $email, password: $password)';
}


}

/// @nodoc
abstract mixin class $AuthEventSignInCopyWith<$Res> implements $AuthEventCopyWith<$Res> {
  factory $AuthEventSignInCopyWith(AuthEventSignIn value, $Res Function(AuthEventSignIn) _then) = _$AuthEventSignInCopyWithImpl;
@useResult
$Res call({
 String email, String password
});




}
/// @nodoc
class _$AuthEventSignInCopyWithImpl<$Res>
    implements $AuthEventSignInCopyWith<$Res> {
  _$AuthEventSignInCopyWithImpl(this._self, this._then);

  final AuthEventSignIn _self;
  final $Res Function(AuthEventSignIn) _then;

/// Create a copy of AuthEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? email = null,Object? password = null,}) {
  return _then(AuthEventSignIn(
email: null == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String,password: null == password ? _self.password : password // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc


class AuthEventSignUp implements AuthEvent {
  const AuthEventSignUp({required this.password, required this.signupData});
  

 final  String password;
 final  SignupModel signupData;

/// Create a copy of AuthEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AuthEventSignUpCopyWith<AuthEventSignUp> get copyWith => _$AuthEventSignUpCopyWithImpl<AuthEventSignUp>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AuthEventSignUp&&(identical(other.password, password) || other.password == password)&&(identical(other.signupData, signupData) || other.signupData == signupData));
}


@override
int get hashCode => Object.hash(runtimeType,password,signupData);

@override
String toString() {
  return 'AuthEvent.signUp(password: $password, signupData: $signupData)';
}


}

/// @nodoc
abstract mixin class $AuthEventSignUpCopyWith<$Res> implements $AuthEventCopyWith<$Res> {
  factory $AuthEventSignUpCopyWith(AuthEventSignUp value, $Res Function(AuthEventSignUp) _then) = _$AuthEventSignUpCopyWithImpl;
@useResult
$Res call({
 String password, SignupModel signupData
});


$SignupModelCopyWith<$Res> get signupData;

}
/// @nodoc
class _$AuthEventSignUpCopyWithImpl<$Res>
    implements $AuthEventSignUpCopyWith<$Res> {
  _$AuthEventSignUpCopyWithImpl(this._self, this._then);

  final AuthEventSignUp _self;
  final $Res Function(AuthEventSignUp) _then;

/// Create a copy of AuthEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? password = null,Object? signupData = null,}) {
  return _then(AuthEventSignUp(
password: null == password ? _self.password : password // ignore: cast_nullable_to_non_nullable
as String,signupData: null == signupData ? _self.signupData : signupData // ignore: cast_nullable_to_non_nullable
as SignupModel,
  ));
}

/// Create a copy of AuthEvent
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$SignupModelCopyWith<$Res> get signupData {
  
  return $SignupModelCopyWith<$Res>(_self.signupData, (value) {
    return _then(_self.copyWith(signupData: value));
  });
}
}

/// @nodoc


class AuthEventSessionRestored implements AuthEvent {
  const AuthEventSessionRestored({required this.session});
  

 final  Session session;

/// Create a copy of AuthEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AuthEventSessionRestoredCopyWith<AuthEventSessionRestored> get copyWith => _$AuthEventSessionRestoredCopyWithImpl<AuthEventSessionRestored>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AuthEventSessionRestored&&(identical(other.session, session) || other.session == session));
}


@override
int get hashCode => Object.hash(runtimeType,session);

@override
String toString() {
  return 'AuthEvent.sessionRestored(session: $session)';
}


}

/// @nodoc
abstract mixin class $AuthEventSessionRestoredCopyWith<$Res> implements $AuthEventCopyWith<$Res> {
  factory $AuthEventSessionRestoredCopyWith(AuthEventSessionRestored value, $Res Function(AuthEventSessionRestored) _then) = _$AuthEventSessionRestoredCopyWithImpl;
@useResult
$Res call({
 Session session
});




}
/// @nodoc
class _$AuthEventSessionRestoredCopyWithImpl<$Res>
    implements $AuthEventSessionRestoredCopyWith<$Res> {
  _$AuthEventSessionRestoredCopyWithImpl(this._self, this._then);

  final AuthEventSessionRestored _self;
  final $Res Function(AuthEventSessionRestored) _then;

/// Create a copy of AuthEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? session = null,}) {
  return _then(AuthEventSessionRestored(
session: null == session ? _self.session : session // ignore: cast_nullable_to_non_nullable
as Session,
  ));
}


}

/// @nodoc


class AuthEventCompleteSignup implements AuthEvent {
  const AuthEventCompleteSignup({required this.session});
  

 final  Session session;

/// Create a copy of AuthEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AuthEventCompleteSignupCopyWith<AuthEventCompleteSignup> get copyWith => _$AuthEventCompleteSignupCopyWithImpl<AuthEventCompleteSignup>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AuthEventCompleteSignup&&(identical(other.session, session) || other.session == session));
}


@override
int get hashCode => Object.hash(runtimeType,session);

@override
String toString() {
  return 'AuthEvent.completeSignup(session: $session)';
}


}

/// @nodoc
abstract mixin class $AuthEventCompleteSignupCopyWith<$Res> implements $AuthEventCopyWith<$Res> {
  factory $AuthEventCompleteSignupCopyWith(AuthEventCompleteSignup value, $Res Function(AuthEventCompleteSignup) _then) = _$AuthEventCompleteSignupCopyWithImpl;
@useResult
$Res call({
 Session session
});




}
/// @nodoc
class _$AuthEventCompleteSignupCopyWithImpl<$Res>
    implements $AuthEventCompleteSignupCopyWith<$Res> {
  _$AuthEventCompleteSignupCopyWithImpl(this._self, this._then);

  final AuthEventCompleteSignup _self;
  final $Res Function(AuthEventCompleteSignup) _then;

/// Create a copy of AuthEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? session = null,}) {
  return _then(AuthEventCompleteSignup(
session: null == session ? _self.session : session // ignore: cast_nullable_to_non_nullable
as Session,
  ));
}


}

/// @nodoc


class AuthEventResendEmailConfirmation implements AuthEvent {
  const AuthEventResendEmailConfirmation({required this.email});
  

 final  String email;

/// Create a copy of AuthEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AuthEventResendEmailConfirmationCopyWith<AuthEventResendEmailConfirmation> get copyWith => _$AuthEventResendEmailConfirmationCopyWithImpl<AuthEventResendEmailConfirmation>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AuthEventResendEmailConfirmation&&(identical(other.email, email) || other.email == email));
}


@override
int get hashCode => Object.hash(runtimeType,email);

@override
String toString() {
  return 'AuthEvent.resendEmailConfirmation(email: $email)';
}


}

/// @nodoc
abstract mixin class $AuthEventResendEmailConfirmationCopyWith<$Res> implements $AuthEventCopyWith<$Res> {
  factory $AuthEventResendEmailConfirmationCopyWith(AuthEventResendEmailConfirmation value, $Res Function(AuthEventResendEmailConfirmation) _then) = _$AuthEventResendEmailConfirmationCopyWithImpl;
@useResult
$Res call({
 String email
});




}
/// @nodoc
class _$AuthEventResendEmailConfirmationCopyWithImpl<$Res>
    implements $AuthEventResendEmailConfirmationCopyWith<$Res> {
  _$AuthEventResendEmailConfirmationCopyWithImpl(this._self, this._then);

  final AuthEventResendEmailConfirmation _self;
  final $Res Function(AuthEventResendEmailConfirmation) _then;

/// Create a copy of AuthEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? email = null,}) {
  return _then(AuthEventResendEmailConfirmation(
email: null == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc


class AuthEventResendEmailConfirmationSignIn implements AuthEvent {
  const AuthEventResendEmailConfirmationSignIn({required this.email});
  

 final  String email;

/// Create a copy of AuthEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AuthEventResendEmailConfirmationSignInCopyWith<AuthEventResendEmailConfirmationSignIn> get copyWith => _$AuthEventResendEmailConfirmationSignInCopyWithImpl<AuthEventResendEmailConfirmationSignIn>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AuthEventResendEmailConfirmationSignIn&&(identical(other.email, email) || other.email == email));
}


@override
int get hashCode => Object.hash(runtimeType,email);

@override
String toString() {
  return 'AuthEvent.resendEmailConfirmationSignIn(email: $email)';
}


}

/// @nodoc
abstract mixin class $AuthEventResendEmailConfirmationSignInCopyWith<$Res> implements $AuthEventCopyWith<$Res> {
  factory $AuthEventResendEmailConfirmationSignInCopyWith(AuthEventResendEmailConfirmationSignIn value, $Res Function(AuthEventResendEmailConfirmationSignIn) _then) = _$AuthEventResendEmailConfirmationSignInCopyWithImpl;
@useResult
$Res call({
 String email
});




}
/// @nodoc
class _$AuthEventResendEmailConfirmationSignInCopyWithImpl<$Res>
    implements $AuthEventResendEmailConfirmationSignInCopyWith<$Res> {
  _$AuthEventResendEmailConfirmationSignInCopyWithImpl(this._self, this._then);

  final AuthEventResendEmailConfirmationSignIn _self;
  final $Res Function(AuthEventResendEmailConfirmationSignIn) _then;

/// Create a copy of AuthEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? email = null,}) {
  return _then(AuthEventResendEmailConfirmationSignIn(
email: null == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
