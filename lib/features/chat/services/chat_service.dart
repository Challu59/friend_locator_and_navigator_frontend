import 'dart:convert';
import 'package:http/http.dart' as http;

import '../../../core/storage/token_storage.dart';
import '../models/chat_room_model.dart';
import '../models/message_model.dart';
import '../models/conversation_model.dart';

class ChatService {
  final String baseUrl = "http://10.0.2.2:8000/api/chat";

  Future<Map<String, String>> _getHeaders() async{
    final token = await TokenStorage.getAccessToken();

  return{
    "Content-Type" : "application/json",
    "Authorization" : "Bearer $token",
  };
  }

  // future that returns ChatRoomModel on successful creation or retrieval
  Future<ChatRoomModel> createOrGetRoom(int userId) async{
    final response = await http.post(
      Uri.parse("$baseUrl/rooms/"),
      headers: await _getHeaders(),
      body: jsonEncode({"user_id": userId}),
    );

    if(response.statusCode == 200 || response.statusCode == 201){
      return ChatRoomModel.fromJson(
        jsonDecode(response.body),
      );

    }

    throw Exception("Failed to create or get room");

  }

  Future<List<ConversationModel>> fetchConversations() async {
    final response = await http.get(
      Uri.parse("$baseUrl/conversations/"),
      headers: await _getHeaders(),
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data
          .map((item) => ConversationModel.fromJson(item))
          .toList();
    }

    throw Exception("Failed to fetch conversations");
  }

  // future to fetch messages from the backend
  Future<List<MessageModel>> fetchMessages(int roomId) async{
    final response = await http.get(
      Uri.parse("$baseUrl/rooms/$roomId/messages"),
      headers: await _getHeaders(),
    );
    if(response.statusCode == 200){
      final List<dynamic> data = jsonDecode(response.body);

      return data.map((message) =>
            MessageModel.fromJson(message)).toList();
    }
    throw Exception("Failed to fetch messages.");
  }

  Future<MessageModel> sendMessage(int roomId, String content) async{
    final response = await http.post(
      Uri.parse("$baseUrl/rooms/$roomId/messages"),
      headers: await _getHeaders(),
      body: jsonEncode({"content": content}),
    );

    if (response.statusCode == 201){
      return MessageModel.fromJson(
        jsonDecode(response.body),
      );
    }

    throw Exception("Failed to send message.");
  }


}