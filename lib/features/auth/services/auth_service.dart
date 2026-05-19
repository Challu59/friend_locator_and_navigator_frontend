import 'package:frontend/core/storage/token_storage.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/user_models.dart';

class AuthService {
  final String baseUrl = "http://10.0.2.2:8000/api/auth";

  //register
  Future<bool> register(String email, String username, String password) async{
    final response = await http.post(
      Uri.parse("$baseUrl/register/"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "email": email,
        "username": username,
        "password": password,
      })
    );
        return response.statusCode == 201;
}

//login
Future<Map<String, dynamic>?> login(String email, String password) async{
    final response = await http.post(
      Uri.parse("$baseUrl/login/"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(
        {
          "email": email,
          "password": password,
        }
      )
    );
    if(response.statusCode == 200){
      return (jsonDecode(response.body));
    }
    else{
      return null;
    }
}

//fetch users
Future<List<UserModel>> fetchUsers() async{
    final token = await TokenStorage.getAccessToken();

    final response = await http.get(
      Uri.parse("${baseUrl}/users/"),
      headers: {
        "Content-Type": "appliation/json",
        "Authorization": "Bearer $token"
      },
    );

    if(response.statusCode == 200){
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((user)=> UserModel.fromJson(user)).toList();
    }
    else{
      throw Exception("Failed to fetch users");
    }
}

}