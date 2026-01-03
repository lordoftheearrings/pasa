// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'signup_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
SignupModel _$SignupModelFromJson(
  Map<String, dynamic> json
) {
    return SignupModelData.fromJson(
      json
    );
}

/// @nodoc
mixin _$SignupModel {

 String? get email; String? get phone; String? get fname; String? get mname; String? get lname; String? get fullname; String? get gender; DateTime? get dob; bool? get usePhoneNumber; bool? get hasMiddleName;
/// Create a copy of SignupModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SignupModelCopyWith<SignupModel> get copyWith => _$SignupModelCopyWithImpl<SignupModel>(this as SignupModel, _$identity);

  /// Serializes this SignupModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SignupModel&&(identical(other.email, email) || other.email == email)&&(identical(other.phone, phone) || other.phone == phone)&&(identical(other.fname, fname) || other.fname == fname)&&(identical(other.mname, mname) || other.mname == mname)&&(identical(other.lname, lname) || other.lname == lname)&&(identical(other.fullname, fullname) || other.fullname == fullname)&&(identical(other.gender, gender) || other.gender == gender)&&(identical(other.dob, dob) || other.dob == dob)&&(identical(other.usePhoneNumber, usePhoneNumber) || other.usePhoneNumber == usePhoneNumber)&&(identical(other.hasMiddleName, hasMiddleName) || other.hasMiddleName == hasMiddleName));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,email,phone,fname,mname,lname,fullname,gender,dob,usePhoneNumber,hasMiddleName);

@override
String toString() {
  return 'SignupModel(email: $email, phone: $phone, fname: $fname, mname: $mname, lname: $lname, fullname: $fullname, gender: $gender, dob: $dob, usePhoneNumber: $usePhoneNumber, hasMiddleName: $hasMiddleName)';
}


}

/// @nodoc
abstract mixin class $SignupModelCopyWith<$Res>  {
  factory $SignupModelCopyWith(SignupModel value, $Res Function(SignupModel) _then) = _$SignupModelCopyWithImpl;
@useResult
$Res call({
 String? email, String? phone, String? fname, String? mname, String? lname, String? fullname, String? gender, DateTime? dob, bool? usePhoneNumber, bool? hasMiddleName
});




}
/// @nodoc
class _$SignupModelCopyWithImpl<$Res>
    implements $SignupModelCopyWith<$Res> {
  _$SignupModelCopyWithImpl(this._self, this._then);

  final SignupModel _self;
  final $Res Function(SignupModel) _then;

/// Create a copy of SignupModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? email = freezed,Object? phone = freezed,Object? fname = freezed,Object? mname = freezed,Object? lname = freezed,Object? fullname = freezed,Object? gender = freezed,Object? dob = freezed,Object? usePhoneNumber = freezed,Object? hasMiddleName = freezed,}) {
  return _then(_self.copyWith(
email: freezed == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String?,phone: freezed == phone ? _self.phone : phone // ignore: cast_nullable_to_non_nullable
as String?,fname: freezed == fname ? _self.fname : fname // ignore: cast_nullable_to_non_nullable
as String?,mname: freezed == mname ? _self.mname : mname // ignore: cast_nullable_to_non_nullable
as String?,lname: freezed == lname ? _self.lname : lname // ignore: cast_nullable_to_non_nullable
as String?,fullname: freezed == fullname ? _self.fullname : fullname // ignore: cast_nullable_to_non_nullable
as String?,gender: freezed == gender ? _self.gender : gender // ignore: cast_nullable_to_non_nullable
as String?,dob: freezed == dob ? _self.dob : dob // ignore: cast_nullable_to_non_nullable
as DateTime?,usePhoneNumber: freezed == usePhoneNumber ? _self.usePhoneNumber : usePhoneNumber // ignore: cast_nullable_to_non_nullable
as bool?,hasMiddleName: freezed == hasMiddleName ? _self.hasMiddleName : hasMiddleName // ignore: cast_nullable_to_non_nullable
as bool?,
  ));
}

}


/// Adds pattern-matching-related methods to [SignupModel].
extension SignupModelPatterns on SignupModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( SignupModelData value)?  data,required TResult orElse(),}){
final _that = this;
switch (_that) {
case SignupModelData() when data != null:
return data(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( SignupModelData value)  data,}){
final _that = this;
switch (_that) {
case SignupModelData():
return data(_that);case _:
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( SignupModelData value)?  data,}){
final _that = this;
switch (_that) {
case SignupModelData() when data != null:
return data(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function( String? email,  String? phone,  String? fname,  String? mname,  String? lname,  String? fullname,  String? gender,  DateTime? dob,  bool? usePhoneNumber,  bool? hasMiddleName)?  data,required TResult orElse(),}) {final _that = this;
switch (_that) {
case SignupModelData() when data != null:
return data(_that.email,_that.phone,_that.fname,_that.mname,_that.lname,_that.fullname,_that.gender,_that.dob,_that.usePhoneNumber,_that.hasMiddleName);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function( String? email,  String? phone,  String? fname,  String? mname,  String? lname,  String? fullname,  String? gender,  DateTime? dob,  bool? usePhoneNumber,  bool? hasMiddleName)  data,}) {final _that = this;
switch (_that) {
case SignupModelData():
return data(_that.email,_that.phone,_that.fname,_that.mname,_that.lname,_that.fullname,_that.gender,_that.dob,_that.usePhoneNumber,_that.hasMiddleName);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function( String? email,  String? phone,  String? fname,  String? mname,  String? lname,  String? fullname,  String? gender,  DateTime? dob,  bool? usePhoneNumber,  bool? hasMiddleName)?  data,}) {final _that = this;
switch (_that) {
case SignupModelData() when data != null:
return data(_that.email,_that.phone,_that.fname,_that.mname,_that.lname,_that.fullname,_that.gender,_that.dob,_that.usePhoneNumber,_that.hasMiddleName);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class SignupModelData implements SignupModel {
  const SignupModelData({this.email, this.phone, this.fname, this.mname, this.lname, this.fullname, this.gender, this.dob, this.usePhoneNumber, this.hasMiddleName});
  factory SignupModelData.fromJson(Map<String, dynamic> json) => _$SignupModelDataFromJson(json);

@override final  String? email;
@override final  String? phone;
@override final  String? fname;
@override final  String? mname;
@override final  String? lname;
@override final  String? fullname;
@override final  String? gender;
@override final  DateTime? dob;
@override final  bool? usePhoneNumber;
@override final  bool? hasMiddleName;

/// Create a copy of SignupModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SignupModelDataCopyWith<SignupModelData> get copyWith => _$SignupModelDataCopyWithImpl<SignupModelData>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$SignupModelDataToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SignupModelData&&(identical(other.email, email) || other.email == email)&&(identical(other.phone, phone) || other.phone == phone)&&(identical(other.fname, fname) || other.fname == fname)&&(identical(other.mname, mname) || other.mname == mname)&&(identical(other.lname, lname) || other.lname == lname)&&(identical(other.fullname, fullname) || other.fullname == fullname)&&(identical(other.gender, gender) || other.gender == gender)&&(identical(other.dob, dob) || other.dob == dob)&&(identical(other.usePhoneNumber, usePhoneNumber) || other.usePhoneNumber == usePhoneNumber)&&(identical(other.hasMiddleName, hasMiddleName) || other.hasMiddleName == hasMiddleName));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,email,phone,fname,mname,lname,fullname,gender,dob,usePhoneNumber,hasMiddleName);

@override
String toString() {
  return 'SignupModel.data(email: $email, phone: $phone, fname: $fname, mname: $mname, lname: $lname, fullname: $fullname, gender: $gender, dob: $dob, usePhoneNumber: $usePhoneNumber, hasMiddleName: $hasMiddleName)';
}


}

/// @nodoc
abstract mixin class $SignupModelDataCopyWith<$Res> implements $SignupModelCopyWith<$Res> {
  factory $SignupModelDataCopyWith(SignupModelData value, $Res Function(SignupModelData) _then) = _$SignupModelDataCopyWithImpl;
@override @useResult
$Res call({
 String? email, String? phone, String? fname, String? mname, String? lname, String? fullname, String? gender, DateTime? dob, bool? usePhoneNumber, bool? hasMiddleName
});




}
/// @nodoc
class _$SignupModelDataCopyWithImpl<$Res>
    implements $SignupModelDataCopyWith<$Res> {
  _$SignupModelDataCopyWithImpl(this._self, this._then);

  final SignupModelData _self;
  final $Res Function(SignupModelData) _then;

/// Create a copy of SignupModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? email = freezed,Object? phone = freezed,Object? fname = freezed,Object? mname = freezed,Object? lname = freezed,Object? fullname = freezed,Object? gender = freezed,Object? dob = freezed,Object? usePhoneNumber = freezed,Object? hasMiddleName = freezed,}) {
  return _then(SignupModelData(
email: freezed == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String?,phone: freezed == phone ? _self.phone : phone // ignore: cast_nullable_to_non_nullable
as String?,fname: freezed == fname ? _self.fname : fname // ignore: cast_nullable_to_non_nullable
as String?,mname: freezed == mname ? _self.mname : mname // ignore: cast_nullable_to_non_nullable
as String?,lname: freezed == lname ? _self.lname : lname // ignore: cast_nullable_to_non_nullable
as String?,fullname: freezed == fullname ? _self.fullname : fullname // ignore: cast_nullable_to_non_nullable
as String?,gender: freezed == gender ? _self.gender : gender // ignore: cast_nullable_to_non_nullable
as String?,dob: freezed == dob ? _self.dob : dob // ignore: cast_nullable_to_non_nullable
as DateTime?,usePhoneNumber: freezed == usePhoneNumber ? _self.usePhoneNumber : usePhoneNumber // ignore: cast_nullable_to_non_nullable
as bool?,hasMiddleName: freezed == hasMiddleName ? _self.hasMiddleName : hasMiddleName // ignore: cast_nullable_to_non_nullable
as bool?,
  ));
}


}

// dart format on
