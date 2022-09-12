import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesService {
  static late SharedPreferences pref;

  Future<void> initPrefs() async {
    pref = await SharedPreferences.getInstance();
  }

  Future<bool> saveToSharedPref(String key, String token) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setString(key, token);
  }

  Future<String?> getFromSharedPref(String key) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(key);
  }
}