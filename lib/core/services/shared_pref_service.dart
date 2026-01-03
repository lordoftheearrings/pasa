import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefService {
  final SharedPreferences prefs;

  SharedPrefService(this.prefs);

  Future<void> setString(String key, String value) async {
    await prefs.setString(key, value);
  }

  String? getString(String key) => prefs.getString(key);

  Future<void> setBool(String key, bool value) async {
    await prefs.setBool(key, value);
  }

  bool? getBool(String key) => prefs.getBool(key);

  Future<void> remove(String key) async {
    await prefs.remove(key);
  }
}
