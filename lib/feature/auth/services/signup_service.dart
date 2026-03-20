import 'package:pasa/core/enums/gender.dart';
import 'package:pasa/core/services/shared_pref_service.dart';
import 'package:pasa/feature/auth/enums/signup_local_storage_keys.dart';
import 'package:pasa/feature/auth/models/signup_model.dart';

class SignupService {
  final SharedPrefService sharedPrefs;

  SignupService(this.sharedPrefs);
  bool get hasData => sharedPrefs.getBool(SignupKeys.hasData.name) ?? false;

  Future<void> saveString(SignupKeys key, String value) async {
    await sharedPrefs.setString(key.name, value);
    await _markHasData();
  }

  String? getString(SignupKeys key) {
    return sharedPrefs.getString(key.name);
  }

  Future<void> saveBool(SignupKeys key, bool value) async {
    await sharedPrefs.setBool(key.name, value);
    await _markHasData();
  }

  bool? getBool(SignupKeys key) {
    return sharedPrefs.getBool(key.name);
  }

  Future<void> saveGender(Gender? gender) async {
    if (gender == null) {
      await sharedPrefs.remove(SignupKeys.gender.name);
    } else {
      await saveString(SignupKeys.gender, gender.name);
    }
    await _markHasData();
  }

  Gender? getGender() {
    final val = getString(SignupKeys.gender);
    if (val == null) return null;
    return Gender.values.firstWhere((g) => g.name == val);
  }

  Future<void> saveSignupDob(String dob) async {
    await saveString(SignupKeys.dob, dob);
    await _markHasData();
  }

  DateTime? getSignupDob() {
    String? savedDob = getString(SignupKeys.dob);
    DateTime? dob;
    if (savedDob != null) {
      dob = DateTime.tryParse(savedDob);
    }
    return dob;
  }

  Future<void> clearSignupData() async {
    for (var key in SignupKeys.values) {
      await sharedPrefs.remove(key.name);
    }
  }

  Future<void> _markHasData() async {
    await sharedPrefs.setBool(SignupKeys.hasData.name, true);
  }

  Future<void> markSignupCompleted() async {
    await sharedPrefs.setBool(SignupKeys.signUpCompleted.name, true);
  }

  bool wasSignupJustCompleted() {
    return sharedPrefs.getBool(SignupKeys.signUpCompleted.name) ?? false;
  }

  SignupModel? getPendingSignupData() {
    if (!(sharedPrefs.getBool(SignupKeys.hasData.name) ?? false)) {
      return null;
    }

    return SignupModel.data(
      name: getString(SignupKeys.name) ?? '',
      email: getString(SignupKeys.email) ?? '',
      phone: getString(SignupKeys.phone) ?? '',
      address: getString(SignupKeys.address) ?? '',
      bloodGroup: getString(SignupKeys.bloodGroup) ?? '',
      emergencyNote: getString(SignupKeys.emergencyNote) ?? '',
      dob: getSignupDob(),
      gender: getGender()?.name ?? '',
      usePhoneNumber: getBool(SignupKeys.usePhoneNumber) ?? false,
    );
  }
}
