import 'package:shared_preferences/shared_preferences.dart';

class TokenStorage {

  static const accessTokenKey = 'access_token';
  static const refreshTokenKey = 'refresh_token';

  //save access and refresh tokens
  static Future<void> saveTokens({ required String accessToken, required String refreshToken})
  async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString(accessTokenKey, accessToken);
    prefs.setString(refreshTokenKey, refreshToken);
  }

  //get access token
  static Future<String?> getAccessToken() async{
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(accessTokenKey);
  }

  //get refresh token
  static Future<String?> getRefreshToken() async{
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(refreshTokenKey);
  }

  //check whether user is logged in
static Future<bool> isLoggedIn() async{
    final token = await getAccessToken();
    return (token!=null && token.isNotEmpty);
}

//clear tokens
static Future<void> clearTokens() async{
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(accessTokenKey);
    await prefs.remove(refreshTokenKey);
}
}