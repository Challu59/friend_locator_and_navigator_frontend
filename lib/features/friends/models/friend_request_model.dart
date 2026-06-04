class FriendRequestModel {
  final int id;
  final int sender;
  final int receiver;
  final String senderUsername;
  final String receiverUsername;
  final String status;

  FriendRequestModel({
    required this.id,
    required this.sender,
    required this.receiver,
    required this.senderUsername,
    required this.receiverUsername,
    required this.status,
  });

  factory FriendRequestModel.fromJson(
      Map<String, dynamic> json,
      ) {
    return FriendRequestModel(
      id: json['id'],
      sender: json['sender'],
      receiver: json['receiver'],
      senderUsername: json['sender_username'],
      receiverUsername: json['receiver_username'],
      status: json['status'],
    );
  }
}