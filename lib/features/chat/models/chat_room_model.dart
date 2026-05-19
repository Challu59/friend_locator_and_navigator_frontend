class ChatRoomModel {
  final int id;
  final List<dynamic> participants;
  final DateTime createdAt;

  ChatRoomModel(
      {
    required this.id,
    required this.participants,
    required this.createdAt
}
);

  factory ChatRoomModel.fromJson(Map<String, dynamic> json){
  return ChatRoomModel(
  id: json['id'],
  participants: json['participants'],
  createdAt: DateTime.parse(json['created_at'])
  );

  }
}