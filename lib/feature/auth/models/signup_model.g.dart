// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'signup_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SignupModelData _$SignupModelDataFromJson(Map<String, dynamic> json) =>
    SignupModelData(
      name: json['name'] as String?,
      email: json['email'] as String?,
      phone: json['phone'] as String?,
      address: json['address'] as String?,
      bloodGroup: json['bloodGroup'] as String?,
      emergencyNote: json['emergencyNote'] as String?,
      gender: json['gender'] as String?,
      dob: json['dob'] == null ? null : DateTime.parse(json['dob'] as String),
      usePhoneNumber: json['usePhoneNumber'] as bool?,
    );

Map<String, dynamic> _$SignupModelDataToJson(SignupModelData instance) =>
    <String, dynamic>{
      'name': instance.name,
      'email': instance.email,
      'phone': instance.phone,
      'address': instance.address,
      'bloodGroup': instance.bloodGroup,
      'emergencyNote': instance.emergencyNote,
      'gender': instance.gender,
      'dob': instance.dob?.toIso8601String(),
      'usePhoneNumber': instance.usePhoneNumber,
    };
