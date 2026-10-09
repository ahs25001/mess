import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesManager {
 static late SharedPreferences _prefs ;
 static void init() async {
   _prefs = await SharedPreferences.getInstance();
 }
Future <void> saveString(String key, String value)async {
  await _prefs.setString(key, value);
 }
 String getString(String key) {
   return _prefs.getString(key) ?? '';
 }
}