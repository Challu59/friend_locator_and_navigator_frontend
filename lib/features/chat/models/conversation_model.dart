import '../../auth/models/user_models.dart';

class ConversationModel {
  final int roomId;
  final UserModel otherUser;
  final LastMessagePreview? lastMessage;

  ConversationModel({
    required this.roomId,
    required this.otherUser,
    this.lastMessage,
  });

  factory ConversationModel.fromJson(Map<String, dynamic> json) {
    return ConversationModel(
      roomId: json['room_id'],
      otherUser: UserModel.fromJson(json['other_user']),
      lastMessage: json['last_message'] != null
          ? LastMessagePreview.fromJson(json['last_message'])
          : null,
    );
  }
}

class LastMessagePreview {
  final String content;
  final DateTime timestamp;
  final int senderId;

  LastMessagePreview({
    required this.content,
    required this.timestamp,
    required this.senderId,
  });

  factory LastMessagePreview.fromJson(Map<String, dynamic> json) {
    return LastMessagePreview(
      content: json['content'],
      timestamp: DateTime.parse(json['timestamp']),
      senderId: json['sender_id'],
    );
  }
}
