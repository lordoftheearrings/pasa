// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'signup_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SignupModelData _$SignupModelDataFromJson(Map<String, dynamic> json) =>
    SignupModelData(
      email: json['email'] as String?,
      phone: json['phone'] as String?,
      fname: json['fname'] as String?,
      mname: json['mname'] as String?,
      lname: json['lname'] as String?,
      fullname: json['fullname'] as String?,
      gender: json['gender'] as String?,
      dob: json['dob'] == null ? null : DateTime.parse(json['dob'] as String),
      usePhoneNumber: json['usePhoneNumber'] as bool?,
      hasMiddleName: json['hasMiddleName'] as bool?,
    );

Map<String, dynamic> _$SignupModelDataToJson(SignupModelData instance) =>
    <String, dynamic>{
      'email': instance.email,
      'phone': instance.phone,
      'fname': instance.fname,
      'mname': instance.mname,
      'lname': instance.lname,
      'fullname': instance.fullname,
      'gender': instance.gender,
      'dob': instance.dob?.toIso8601String(),
      'usePhoneNumber': instance.usePhoneNumber,
      'hasMiddleName': instance.hasMiddleName,
    };
