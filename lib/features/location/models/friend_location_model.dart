class FriendLocationModel {
  final int id;
  final String username;
  final double latitude;
  final double longitude;
  final DateTime updatedAt;

  FriendLocationModel({
    required this.id,
    required this.username,
    required this.latitude,
    required this.longitude,
    required this.updatedAt,
  });

  factory FriendLocationModel.fromJson(Map<String, dynamic> json) {
    return FriendLocationModel(
      id: json['id'],
      username: json['username'],
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }
}
