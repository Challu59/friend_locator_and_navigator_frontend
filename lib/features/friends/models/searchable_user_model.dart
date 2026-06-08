class SearchableUserModel {
  final int id;
  final String username;
  final String email;
  final String relationship;

  SearchableUserModel({
    required this.id,
    required this.username,
    required this.email,
    required this.relationship,
  });

  factory SearchableUserModel.fromJson(Map<String, dynamic> json) {
    return SearchableUserModel(
      id: json['id'],
      username: json['username'],
      email: json['email'],
      relationship: json['relationship'],
    );
  }

  bool get isFriend => relationship == 'friend';
  bool get isPendingSent => relationship == 'pending_sent';
  bool get isPendingReceived => relationship == 'pending_received';
  bool get canSendRequest => relationship == 'none';
}
