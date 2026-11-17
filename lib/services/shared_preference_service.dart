import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesService {
  static final SharedPreferencesService _instance =
      SharedPreferencesService._internal();

  late SharedPreferences _prefs;

  SharedPreferencesService._internal();

  factory SharedPreferencesService() {
    return _instance;
  }

  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  Future<bool> setString(String key, String value) async {
    return await _prefs.setString(key, value);
  }

  Set<String> getKeys() {
    return _prefs.getKeys();
  }

  Future<void> remove(String key) async {
    await _prefs.remove(key);
  }

  String? getString(String key) {
    return _prefs.getString(key);
  }

  Future<bool> clear() async {
    return await _prefs.clear();
  }

  bool containsKey(String key) {
    return _prefs.containsKey(key);
  }
}
