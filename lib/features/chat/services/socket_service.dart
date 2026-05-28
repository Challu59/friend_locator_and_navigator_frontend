import 'dart:convert';
import 'package:web_socket_channel/web_socket_channel.dart';

class SocketService {
  WebSocketChannel? channel;

  void connect(int roomId) {
    channel = WebSocketChannel.connect(
      Uri.parse(
        'ws://10.0.2.2:8000/ws/chat/$roomId/',
      ),
    );
  }

  void sendMessage({
    required String message,
    required int senderId,
  }) {
    channel?.sink.add(
      jsonEncode({
        'message': message,
        'sender_id': senderId,
      }),
    );
  }

  Stream get stream => channel!.stream;

  void disconnect() {
    channel?.sink.close();
  }
}