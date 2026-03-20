import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:pasa/core/enums/gender.dart';

part 'signup_event.freezed.dart';

@freezed
abstract class SignupEvent with _$SignupEvent {
  const factory SignupEvent.loadInitialData() = LoadInitialData;

  const factory SignupEvent.updateName(String name) = UpdateName;

  const factory SignupEvent.updateEmail(String email) = UpdateEmail;
  const factory SignupEvent.updatePhone(String phone) = UpdatePhone;
  const factory SignupEvent.updateAddress(String address) = UpdateAddress;
  const factory SignupEvent.updateBloodGroup(String bloodGroup) =
      UpdateBloodGroup;
  const factory SignupEvent.updateEmergencyNote(String emergencyNote) =
      UpdateEmergencyNote;

  const factory SignupEvent.updateGender(Gender? gender) = UpdateGender;
  const factory SignupEvent.updateDob(DateTime? dob) = UpdateDob;

  const factory SignupEvent.updateUsePhoneNumber(bool value) =
      UpdateUsePhoneNumber;

  const factory SignupEvent.clear() = ClearSignupData;

  const factory SignupEvent.submitSignup(String? password) = SubmitSignup;

  const factory SignupEvent.launchemail() = LaunchEmail;
}
