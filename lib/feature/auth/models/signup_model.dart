import 'package:freezed_annotation/freezed_annotation.dart';

part 'signup_model.freezed.dart';
part 'signup_model.g.dart';

@freezed
abstract class SignupModel with _$SignupModel {
  const factory SignupModel.data({
    String? name,
    String? email,
    String? phone,
    String? address,
    String? bloodGroup,
    String? emergencyNote,
    String? gender,
    DateTime? dob,
    bool? usePhoneNumber,
  }) = SignupModelData;

  factory SignupModel.fromJson(Map<String, dynamic> json) =>
      _$SignupModelFromJson(json);
}
