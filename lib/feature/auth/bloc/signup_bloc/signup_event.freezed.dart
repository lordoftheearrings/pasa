// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'signup_event.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$SignupEvent {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SignupEvent);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'SignupEvent()';
}


}

/// @nodoc
class $SignupEventCopyWith<$Res>  {
$SignupEventCopyWith(SignupEvent _, $Res Function(SignupEvent) __);
}


/// Adds pattern-matching-related methods to [SignupEvent].
extension SignupEventPatterns on SignupEvent {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( LoadInitialData value)?  loadInitialData,TResult Function( UpdateName value)?  updateName,TResult Function( UpdateEmail value)?  updateEmail,TResult Function( UpdatePhone value)?  updatePhone,TResult Function( UpdateGender value)?  updateGender,TResult Function( UpdateDob value)?  updateDob,TResult Function( UpdateUsePhoneNumber value)?  updateUsePhoneNumber,TResult Function( UpdateHasMiddleName value)?  updateHasMiddleName,TResult Function( ClearSignupData value)?  clear,TResult Function( SubmitSignup value)?  submitSignup,TResult Function( LaunchEmail value)?  launchemail,required TResult orElse(),}){
final _that = this;
switch (_that) {
case LoadInitialData() when loadInitialData != null:
return loadInitialData(_that);case UpdateName() when updateName != null:
return updateName(_that);case UpdateEmail() when updateEmail != null:
return updateEmail(_that);case UpdatePhone() when updatePhone != null:
return updatePhone(_that);case UpdateGender() when updateGender != null:
return updateGender(_that);case UpdateDob() when updateDob != null:
return updateDob(_that);case UpdateUsePhoneNumber() when updateUsePhoneNumber != null:
return updateUsePhoneNumber(_that);case UpdateHasMiddleName() when updateHasMiddleName != null:
return updateHasMiddleName(_that);case ClearSignupData() when clear != null:
return clear(_that);case SubmitSignup() when submitSignup != null:
return submitSignup(_that);case LaunchEmail() when launchemail != null:
return launchemail(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( LoadInitialData value)  loadInitialData,required TResult Function( UpdateName value)  updateName,required TResult Function( UpdateEmail value)  updateEmail,required TResult Function( UpdatePhone value)  updatePhone,required TResult Function( UpdateGender value)  updateGender,required TResult Function( UpdateDob value)  updateDob,required TResult Function( UpdateUsePhoneNumber value)  updateUsePhoneNumber,required TResult Function( UpdateHasMiddleName value)  updateHasMiddleName,required TResult Function( ClearSignupData value)  clear,required TResult Function( SubmitSignup value)  submitSignup,required TResult Function( LaunchEmail value)  launchemail,}){
final _that = this;
switch (_that) {
case LoadInitialData():
return loadInitialData(_that);case UpdateName():
return updateName(_that);case UpdateEmail():
return updateEmail(_that);case UpdatePhone():
return updatePhone(_that);case UpdateGender():
return updateGender(_that);case UpdateDob():
return updateDob(_that);case UpdateUsePhoneNumber():
return updateUsePhoneNumber(_that);case UpdateHasMiddleName():
return updateHasMiddleName(_that);case ClearSignupData():
return clear(_that);case SubmitSignup():
return submitSignup(_that);case LaunchEmail():
return launchemail(_that);case _:
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( LoadInitialData value)?  loadInitialData,TResult? Function( UpdateName value)?  updateName,TResult? Function( UpdateEmail value)?  updateEmail,TResult? Function( UpdatePhone value)?  updatePhone,TResult? Function( UpdateGender value)?  updateGender,TResult? Function( UpdateDob value)?  updateDob,TResult? Function( UpdateUsePhoneNumber value)?  updateUsePhoneNumber,TResult? Function( UpdateHasMiddleName value)?  updateHasMiddleName,TResult? Function( ClearSignupData value)?  clear,TResult? Function( SubmitSignup value)?  submitSignup,TResult? Function( LaunchEmail value)?  launchemail,}){
final _that = this;
switch (_that) {
case LoadInitialData() when loadInitialData != null:
return loadInitialData(_that);case UpdateName() when updateName != null:
return updateName(_that);case UpdateEmail() when updateEmail != null:
return updateEmail(_that);case UpdatePhone() when updatePhone != null:
return updatePhone(_that);case UpdateGender() when updateGender != null:
return updateGender(_that);case UpdateDob() when updateDob != null:
return updateDob(_that);case UpdateUsePhoneNumber() when updateUsePhoneNumber != null:
return updateUsePhoneNumber(_that);case UpdateHasMiddleName() when updateHasMiddleName != null:
return updateHasMiddleName(_that);case ClearSignupData() when clear != null:
return clear(_that);case SubmitSignup() when submitSignup != null:
return submitSignup(_that);case LaunchEmail() when launchemail != null:
return launchemail(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  loadInitialData,TResult Function( String fname,  String? mname,  String lname)?  updateName,TResult Function( String email)?  updateEmail,TResult Function( String phone)?  updatePhone,TResult Function( Gender? gender)?  updateGender,TResult Function( DateTime? dob)?  updateDob,TResult Function( bool value)?  updateUsePhoneNumber,TResult Function( bool value)?  updateHasMiddleName,TResult Function()?  clear,TResult Function( String? password)?  submitSignup,TResult Function()?  launchemail,required TResult orElse(),}) {final _that = this;
switch (_that) {
case LoadInitialData() when loadInitialData != null:
return loadInitialData();case UpdateName() when updateName != null:
return updateName(_that.fname,_that.mname,_that.lname);case UpdateEmail() when updateEmail != null:
return updateEmail(_that.email);case UpdatePhone() when updatePhone != null:
return updatePhone(_that.phone);case UpdateGender() when updateGender != null:
return updateGender(_that.gender);case UpdateDob() when updateDob != null:
return updateDob(_that.dob);case UpdateUsePhoneNumber() when updateUsePhoneNumber != null:
return updateUsePhoneNumber(_that.value);case UpdateHasMiddleName() when updateHasMiddleName != null:
return updateHasMiddleName(_that.value);case ClearSignupData() when clear != null:
return clear();case SubmitSignup() when submitSignup != null:
return submitSignup(_that.password);case LaunchEmail() when launchemail != null:
return launchemail();case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  loadInitialData,required TResult Function( String fname,  String? mname,  String lname)  updateName,required TResult Function( String email)  updateEmail,required TResult Function( String phone)  updatePhone,required TResult Function( Gender? gender)  updateGender,required TResult Function( DateTime? dob)  updateDob,required TResult Function( bool value)  updateUsePhoneNumber,required TResult Function( bool value)  updateHasMiddleName,required TResult Function()  clear,required TResult Function( String? password)  submitSignup,required TResult Function()  launchemail,}) {final _that = this;
switch (_that) {
case LoadInitialData():
return loadInitialData();case UpdateName():
return updateName(_that.fname,_that.mname,_that.lname);case UpdateEmail():
return updateEmail(_that.email);case UpdatePhone():
return updatePhone(_that.phone);case UpdateGender():
return updateGender(_that.gender);case UpdateDob():
return updateDob(_that.dob);case UpdateUsePhoneNumber():
return updateUsePhoneNumber(_that.value);case UpdateHasMiddleName():
return updateHasMiddleName(_that.value);case ClearSignupData():
return clear();case SubmitSignup():
return submitSignup(_that.password);case LaunchEmail():
return launchemail();case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  loadInitialData,TResult? Function( String fname,  String? mname,  String lname)?  updateName,TResult? Function( String email)?  updateEmail,TResult? Function( String phone)?  updatePhone,TResult? Function( Gender? gender)?  updateGender,TResult? Function( DateTime? dob)?  updateDob,TResult? Function( bool value)?  updateUsePhoneNumber,TResult? Function( bool value)?  updateHasMiddleName,TResult? Function()?  clear,TResult? Function( String? password)?  submitSignup,TResult? Function()?  launchemail,}) {final _that = this;
switch (_that) {
case LoadInitialData() when loadInitialData != null:
return loadInitialData();case UpdateName() when updateName != null:
return updateName(_that.fname,_that.mname,_that.lname);case UpdateEmail() when updateEmail != null:
return updateEmail(_that.email);case UpdatePhone() when updatePhone != null:
return updatePhone(_that.phone);case UpdateGender() when updateGender != null:
return updateGender(_that.gender);case UpdateDob() when updateDob != null:
return updateDob(_that.dob);case UpdateUsePhoneNumber() when updateUsePhoneNumber != null:
return updateUsePhoneNumber(_that.value);case UpdateHasMiddleName() when updateHasMiddleName != null:
return updateHasMiddleName(_that.value);case ClearSignupData() when clear != null:
return clear();case SubmitSignup() when submitSignup != null:
return submitSignup(_that.password);case LaunchEmail() when launchemail != null:
return launchemail();case _:
  return null;

}
}

}

/// @nodoc


class LoadInitialData implements SignupEvent {
  const LoadInitialData();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is LoadInitialData);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'SignupEvent.loadInitialData()';
}


}




/// @nodoc


class UpdateName implements SignupEvent {
  const UpdateName({required this.fname, this.mname, required this.lname});
  

 final  String fname;
 final  String? mname;
 final  String lname;

/// Create a copy of SignupEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$UpdateNameCopyWith<UpdateName> get copyWith => _$UpdateNameCopyWithImpl<UpdateName>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is UpdateName&&(identical(other.fname, fname) || other.fname == fname)&&(identical(other.mname, mname) || other.mname == mname)&&(identical(other.lname, lname) || other.lname == lname));
}


@override
int get hashCode => Object.hash(runtimeType,fname,mname,lname);

@override
String toString() {
  return 'SignupEvent.updateName(fname: $fname, mname: $mname, lname: $lname)';
}


}

/// @nodoc
abstract mixin class $UpdateNameCopyWith<$Res> implements $SignupEventCopyWith<$Res> {
  factory $UpdateNameCopyWith(UpdateName value, $Res Function(UpdateName) _then) = _$UpdateNameCopyWithImpl;
@useResult
$Res call({
 String fname, String? mname, String lname
});




}
/// @nodoc
class _$UpdateNameCopyWithImpl<$Res>
    implements $UpdateNameCopyWith<$Res> {
  _$UpdateNameCopyWithImpl(this._self, this._then);

  final UpdateName _self;
  final $Res Function(UpdateName) _then;

/// Create a copy of SignupEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? fname = null,Object? mname = freezed,Object? lname = null,}) {
  return _then(UpdateName(
fname: null == fname ? _self.fname : fname // ignore: cast_nullable_to_non_nullable
as String,mname: freezed == mname ? _self.mname : mname // ignore: cast_nullable_to_non_nullable
as String?,lname: null == lname ? _self.lname : lname // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc


class UpdateEmail implements SignupEvent {
  const UpdateEmail(this.email);
  

 final  String email;

/// Create a copy of SignupEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$UpdateEmailCopyWith<UpdateEmail> get copyWith => _$UpdateEmailCopyWithImpl<UpdateEmail>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is UpdateEmail&&(identical(other.email, email) || other.email == email));
}


@override
int get hashCode => Object.hash(runtimeType,email);

@override
String toString() {
  return 'SignupEvent.updateEmail(email: $email)';
}


}

/// @nodoc
abstract mixin class $UpdateEmailCopyWith<$Res> implements $SignupEventCopyWith<$Res> {
  factory $UpdateEmailCopyWith(UpdateEmail value, $Res Function(UpdateEmail) _then) = _$UpdateEmailCopyWithImpl;
@useResult
$Res call({
 String email
});




}
/// @nodoc
class _$UpdateEmailCopyWithImpl<$Res>
    implements $UpdateEmailCopyWith<$Res> {
  _$UpdateEmailCopyWithImpl(this._self, this._then);

  final UpdateEmail _self;
  final $Res Function(UpdateEmail) _then;

/// Create a copy of SignupEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? email = null,}) {
  return _then(UpdateEmail(
null == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc


class UpdatePhone implements SignupEvent {
  const UpdatePhone(this.phone);
  

 final  String phone;

/// Create a copy of SignupEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$UpdatePhoneCopyWith<UpdatePhone> get copyWith => _$UpdatePhoneCopyWithImpl<UpdatePhone>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is UpdatePhone&&(identical(other.phone, phone) || other.phone == phone));
}


@override
int get hashCode => Object.hash(runtimeType,phone);

@override
String toString() {
  return 'SignupEvent.updatePhone(phone: $phone)';
}


}

/// @nodoc
abstract mixin class $UpdatePhoneCopyWith<$Res> implements $SignupEventCopyWith<$Res> {
  factory $UpdatePhoneCopyWith(UpdatePhone value, $Res Function(UpdatePhone) _then) = _$UpdatePhoneCopyWithImpl;
@useResult
$Res call({
 String phone
});




}
/// @nodoc
class _$UpdatePhoneCopyWithImpl<$Res>
    implements $UpdatePhoneCopyWith<$Res> {
  _$UpdatePhoneCopyWithImpl(this._self, this._then);

  final UpdatePhone _self;
  final $Res Function(UpdatePhone) _then;

/// Create a copy of SignupEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? phone = null,}) {
  return _then(UpdatePhone(
null == phone ? _self.phone : phone // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc


class UpdateGender implements SignupEvent {
  const UpdateGender(this.gender);
  

 final  Gender? gender;

/// Create a copy of SignupEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$UpdateGenderCopyWith<UpdateGender> get copyWith => _$UpdateGenderCopyWithImpl<UpdateGender>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is UpdateGender&&(identical(other.gender, gender) || other.gender == gender));
}


@override
int get hashCode => Object.hash(runtimeType,gender);

@override
String toString() {
  return 'SignupEvent.updateGender(gender: $gender)';
}


}

/// @nodoc
abstract mixin class $UpdateGenderCopyWith<$Res> implements $SignupEventCopyWith<$Res> {
  factory $UpdateGenderCopyWith(UpdateGender value, $Res Function(UpdateGender) _then) = _$UpdateGenderCopyWithImpl;
@useResult
$Res call({
 Gender? gender
});




}
/// @nodoc
class _$UpdateGenderCopyWithImpl<$Res>
    implements $UpdateGenderCopyWith<$Res> {
  _$UpdateGenderCopyWithImpl(this._self, this._then);

  final UpdateGender _self;
  final $Res Function(UpdateGender) _then;

/// Create a copy of SignupEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? gender = freezed,}) {
  return _then(UpdateGender(
freezed == gender ? _self.gender : gender // ignore: cast_nullable_to_non_nullable
as Gender?,
  ));
}


}

/// @nodoc


class UpdateDob implements SignupEvent {
  const UpdateDob(this.dob);
  

 final  DateTime? dob;

/// Create a copy of SignupEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$UpdateDobCopyWith<UpdateDob> get copyWith => _$UpdateDobCopyWithImpl<UpdateDob>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is UpdateDob&&(identical(other.dob, dob) || other.dob == dob));
}


@override
int get hashCode => Object.hash(runtimeType,dob);

@override
String toString() {
  return 'SignupEvent.updateDob(dob: $dob)';
}


}

/// @nodoc
abstract mixin class $UpdateDobCopyWith<$Res> implements $SignupEventCopyWith<$Res> {
  factory $UpdateDobCopyWith(UpdateDob value, $Res Function(UpdateDob) _then) = _$UpdateDobCopyWithImpl;
@useResult
$Res call({
 DateTime? dob
});




}
/// @nodoc
class _$UpdateDobCopyWithImpl<$Res>
    implements $UpdateDobCopyWith<$Res> {
  _$UpdateDobCopyWithImpl(this._self, this._then);

  final UpdateDob _self;
  final $Res Function(UpdateDob) _then;

/// Create a copy of SignupEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? dob = freezed,}) {
  return _then(UpdateDob(
freezed == dob ? _self.dob : dob // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}

/// @nodoc


class UpdateUsePhoneNumber implements SignupEvent {
  const UpdateUsePhoneNumber(this.value);
  

 final  bool value;

/// Create a copy of SignupEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$UpdateUsePhoneNumberCopyWith<UpdateUsePhoneNumber> get copyWith => _$UpdateUsePhoneNumberCopyWithImpl<UpdateUsePhoneNumber>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is UpdateUsePhoneNumber&&(identical(other.value, value) || other.value == value));
}


@override
int get hashCode => Object.hash(runtimeType,value);

@override
String toString() {
  return 'SignupEvent.updateUsePhoneNumber(value: $value)';
}


}

/// @nodoc
abstract mixin class $UpdateUsePhoneNumberCopyWith<$Res> implements $SignupEventCopyWith<$Res> {
  factory $UpdateUsePhoneNumberCopyWith(UpdateUsePhoneNumber value, $Res Function(UpdateUsePhoneNumber) _then) = _$UpdateUsePhoneNumberCopyWithImpl;
@useResult
$Res call({
 bool value
});




}
/// @nodoc
class _$UpdateUsePhoneNumberCopyWithImpl<$Res>
    implements $UpdateUsePhoneNumberCopyWith<$Res> {
  _$UpdateUsePhoneNumberCopyWithImpl(this._self, this._then);

  final UpdateUsePhoneNumber _self;
  final $Res Function(UpdateUsePhoneNumber) _then;

/// Create a copy of SignupEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? value = null,}) {
  return _then(UpdateUsePhoneNumber(
null == value ? _self.value : value // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

/// @nodoc


class UpdateHasMiddleName implements SignupEvent {
  const UpdateHasMiddleName(this.value);
  

 final  bool value;

/// Create a copy of SignupEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$UpdateHasMiddleNameCopyWith<UpdateHasMiddleName> get copyWith => _$UpdateHasMiddleNameCopyWithImpl<UpdateHasMiddleName>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is UpdateHasMiddleName&&(identical(other.value, value) || other.value == value));
}


@override
int get hashCode => Object.hash(runtimeType,value);

@override
String toString() {
  return 'SignupEvent.updateHasMiddleName(value: $value)';
}


}

/// @nodoc
abstract mixin class $UpdateHasMiddleNameCopyWith<$Res> implements $SignupEventCopyWith<$Res> {
  factory $UpdateHasMiddleNameCopyWith(UpdateHasMiddleName value, $Res Function(UpdateHasMiddleName) _then) = _$UpdateHasMiddleNameCopyWithImpl;
@useResult
$Res call({
 bool value
});




}
/// @nodoc
class _$UpdateHasMiddleNameCopyWithImpl<$Res>
    implements $UpdateHasMiddleNameCopyWith<$Res> {
  _$UpdateHasMiddleNameCopyWithImpl(this._self, this._then);

  final UpdateHasMiddleName _self;
  final $Res Function(UpdateHasMiddleName) _then;

/// Create a copy of SignupEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? value = null,}) {
  return _then(UpdateHasMiddleName(
null == value ? _self.value : value // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

/// @nodoc


class ClearSignupData implements SignupEvent {
  const ClearSignupData();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ClearSignupData);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'SignupEvent.clear()';
}


}




/// @nodoc


class SubmitSignup implements SignupEvent {
  const SubmitSignup(this.password);
  

 final  String? password;

/// Create a copy of SignupEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SubmitSignupCopyWith<SubmitSignup> get copyWith => _$SubmitSignupCopyWithImpl<SubmitSignup>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SubmitSignup&&(identical(other.password, password) || other.password == password));
}


@override
int get hashCode => Object.hash(runtimeType,password);

@override
String toString() {
  return 'SignupEvent.submitSignup(password: $password)';
}


}

/// @nodoc
abstract mixin class $SubmitSignupCopyWith<$Res> implements $SignupEventCopyWith<$Res> {
  factory $SubmitSignupCopyWith(SubmitSignup value, $Res Function(SubmitSignup) _then) = _$SubmitSignupCopyWithImpl;
@useResult
$Res call({
 String? password
});




}
/// @nodoc
class _$SubmitSignupCopyWithImpl<$Res>
    implements $SubmitSignupCopyWith<$Res> {
  _$SubmitSignupCopyWithImpl(this._self, this._then);

  final SubmitSignup _self;
  final $Res Function(SubmitSignup) _then;

/// Create a copy of SignupEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? password = freezed,}) {
  return _then(SubmitSignup(
freezed == password ? _self.password : password // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

/// @nodoc


class LaunchEmail implements SignupEvent {
  const LaunchEmail();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is LaunchEmail);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'SignupEvent.launchemail()';
}


}




// dart format on
