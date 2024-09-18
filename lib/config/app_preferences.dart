import 'package:chat_app/config/app_const.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppPreferences {
  // Load the saved theme state from SharedPreferences
  Future<bool> getTheme() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool(UserKey.IS_DARK_MODE) ??
        false; // Default to light mode
  }

  // Save the theme state in SharedPreferences
  Future<void> setTheme(bool isDarkMode) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool(UserKey.IS_DARK_MODE, isDarkMode);
  }
}
