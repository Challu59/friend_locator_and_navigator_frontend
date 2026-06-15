import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../../core/storage/token_storage.dart';
import '../models/friend_location_model.dart';

class LocationService {
  final String baseUrl = 'http://10.0.2.2:8000/api/location';

  Future<Map<String, String>> _getHeaders() async {
    final token = await TokenStorage.getAccessToken();
    return {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };
  }

  Future<void> updateLocation({
    required double latitude,
    required double longitude,
    bool isSharing = true,
  }) async {
    final response = await http.post(
      Uri.parse('$baseUrl/update/'),
      headers: await _getHeaders(),
      body: jsonEncode({
        'latitude': latitude,
        'longitude': longitude,
        'is_sharing': isSharing,
      }),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to update location');
    }
  }

  Future<void> stopSharing() async {
    final response = await http.post(
      Uri.parse('$baseUrl/stop-sharing/'),
      headers: await _getHeaders(),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to stop sharing location');
    }
  }

  Future<List<FriendLocationModel>> fetchFriendsLocations() async {
    final response = await http.get(
      Uri.parse('$baseUrl/friends/'),
      headers: await _getHeaders(),
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data
          .map((item) => FriendLocationModel.fromJson(item))
          .toList();
    }

    throw Exception('Failed to fetch friends locations');
  }
}
