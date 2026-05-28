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
    if (channel == null) {
      throw StateError('Socket is not connected.');
    }

    channel!.sink.add(
      jsonEncode({
        'message': message,
        'sender_id': senderId,
      }),
    );
  }

  Stream<String> get stream {
    if (channel == null) {
      throw StateError('Socket is not connected.');
    }
    return channel!.stream.cast<String>();
  }

  void disconnect() {
    channel?.sink.close();
    channel = null;
  }
}