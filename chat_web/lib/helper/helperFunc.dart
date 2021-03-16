import 'package:shared_preferences/shared_preferences.dart';

class HelperFunctions {
  static String loggedInKey = 'IsLoggenIn';
  static String userNameKey = 'UserNameKey';
  static String userEmailKey = 'UserEmailKey';

  static Future<bool> saveUserLoggedIn(bool isUserLoggedIn) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return await preferences.setBool(loggedInKey, isUserLoggedIn);
  }

  static Future<bool> saveUserName(String userName) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return await preferences.setString(userNameKey, userName);
  }

  static Future<bool> saveUserEmail(String userEmail) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return await preferences.setString(userEmailKey, userEmail);
  }

  static Future<bool> getUserLoggedIn() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences.getBool(loggedInKey);
  }

  static Future<String> getUserName() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences.getString(userNameKey);
  }

  static Future<String> getUserEmail() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences.getString(userEmailKey);
  }
}
