class MessageModel{
  final int id;
  final int room;
  final int sender;
  final String senderUsername;
  final String content;
  final DateTime timestamp;

  MessageModel(
  {
    required this.id,
    required this.room,
    required this.sender,
    required this.senderUsername,
    required this.content,
    required this.timestamp,
}
      );

  factory MessageModel.fromJson(Map<String, dynamic> json){
    return MessageModel(
        id: json['id'],
        room: json['room'],
        sender: json['sender'],
        senderUsername: json['sender_username'],
        content: json['content'],
        timestamp: json['timestamp']);
  }


}