
import 'package:flutter_ecommerce_app/services/auth_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SessionManager {
  static const String KEY_EMAIL = "email";
  static const String KEY_USER_ID = "uid";
  static const String KEY_IS_LOGGED_IN = "is_logged_in";


  void setLogin(User data) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(KEY_EMAIL, data.email);
    await prefs.setString(KEY_USER_ID, data.uid);
    await prefs.setBool(KEY_IS_LOGGED_IN, true);
  }

  Future<User> getUserData() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      User data = User(
          prefs.getString(KEY_EMAIL),
          prefs.getString(KEY_USER_ID));
      return data;
    } catch (e) {
      print(e);
    }
  }

  Future<bool> isLoggedIn() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool(KEY_IS_LOGGED_IN);
  }

  Future<bool> clear() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.clear();
    print("clear shared preferences");
    return true;
  }

}
