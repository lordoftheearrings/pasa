import 'package:freezed_annotation/freezed_annotation.dart';

part 'signup_model.freezed.dart';
part 'signup_model.g.dart';

@freezed
abstract class SignupModel with _$SignupModel {
  const factory SignupModel.data({
    String? email,
    String? phone,
    String? fname,
    String? mname,
    String? lname,
    String? fullname,
    String? gender,
    DateTime? dob,
    bool? usePhoneNumber,
    bool? hasMiddleName,
  }) = SignupModelData;

  factory SignupModel.fromJson(Map<String, dynamic> json) =>
      _$SignupModelFromJson(json);
}

extension SignupModelX on SignupModel {
  SignupModel createFullName() {
    final parts = [fname, mname, lname].where((e) => e?.isNotEmpty == true);
    final fullNameValue = parts.isNotEmpty ? parts.join(' ') : null;
    return copyWith(fullname: fullNameValue);
  }
}
