import 'package:shared_preferences/shared_preferences.dart';

class SessionStorage {
  static const String userIdKey = 'user_id';
  static const String usernameKey = 'username';
  static const String emailKey = 'email';

  //save user details
  static Future<void> saveUser({
    required int userId,
    required String username,
    required String email,
}) async{
    final prefs = await SharedPreferences.getInstance();

    await prefs.setInt(userIdKey, userId);
    await prefs.setString(usernameKey, username);
    await prefs.setString(emailKey, email);
  }

  //get user id
  static Future<int?> getUserId() async{
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(userIdKey);
  }

 // get username
  static Future<String?> getUsername() async{
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(usernameKey);
  }

 // get email
  static Future<String?> getEmail() async{
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(emailKey);
  }

  //clear current user session
  static Future<void> clearUser() async{
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(userIdKey);
    await prefs.remove(emailKey);
    await prefs.remove(usernameKey);
  }

}