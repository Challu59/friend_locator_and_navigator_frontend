import 'dart:convert';
import 'package:http/http.dart' as http;

import '../../../core/storage/token_storage.dart';
import '../../auth/models/user_models.dart';
import '../models/friend_request_model.dart';

class FriendService {

  final String baseUrl = "http://10.0.2.2:8000/api/friends";

  Future<Map<String, String>> _getHeaders() async {
    final token = await TokenStorage.getAccessToken();

    return {
      "Content-Type": "application/json",
      "Authorization": "Bearer $token",
    };
  }

  Future<void> sendFriendRequest(int receiverId) async {
    final response = await http.post(
      Uri.parse("$baseUrl/send/"),
      headers: await _getHeaders(),
      body: jsonEncode({
        "receiver_id": receiverId,
      }),
    );

    if (response.statusCode != 200 &&
        response.statusCode != 201) {
      throw Exception("Failed to send friend request");
    }
  }

  Future<List<UserModel>> fetchFriends() async {
    final response = await http.get(
      Uri.parse(baseUrl),
      headers: await _getHeaders(),
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);

      return data
          .map((user) => UserModel.fromJson(user))
          .toList();
    }

    throw Exception("Failed to fetch friends");
  }

  Future<List<FriendRequestModel>> fetchPendingRequests() async {
    final response = await http.get(
      Uri.parse("$baseUrl/pending/"),
      headers: await _getHeaders(),
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);

      return data
          .map((request) =>
          FriendRequestModel.fromJson(request))
          .toList();
    }

    throw Exception("Failed to fetch pending requests");
  }

  Future<void> acceptRequest(int requestId) async {
    final response = await http.post(
      Uri.parse("$baseUrl/$requestId/accept/"),
      headers: await _getHeaders(),
    );

    if (response.statusCode != 200) {
      throw Exception("Failed to accept request");
    }
  }

  Future<void> rejectRequest(int requestId) async {
    final response = await http.post(
      Uri.parse("$baseUrl/$requestId/reject/"),
      headers: await _getHeaders(),
    );

    if (response.statusCode != 200) {
      throw Exception("Failed to reject request");
    }
  }
}