import 'package:flutter/material.dart';

import '../../auth/models/user_models.dart';
import '../../chat/screens/chat_screen.dart';
import '../../chat/services/chat_service.dart';
import '../services/friend_service.dart';

class FriendsScreen extends StatefulWidget {
  const FriendsScreen({super.key});

  @override
  State<FriendsScreen> createState() =>
      _FriendsScreenState();
}

class _FriendsScreenState extends State<FriendsScreen> {

  final FriendService friendService =
  FriendService();

  String _getInitials(String username) {
    if (username.isEmpty) return "?";

    return username[0].toUpperCase();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: const Text("Friends"),
      ),
      body: FutureBuilder<List<UserModel>>(
        future: friendService.fetchFriends(),
        builder: (context, snapshot) {

          if (snapshot.connectionState ==
              ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (snapshot.hasError) {
            return Center(
              child: Text(
                snapshot.error.toString(),
              ),
            );
          }

          final friends = snapshot.data ?? [];

          if (friends.isEmpty) {
            return const Center(
              child: Text("No friends yet"),
            );
          }

          return ListView.builder(
            itemCount: friends.length,
            itemBuilder: (context, index) {

              final friend = friends[index];

              return ListTile(
                leading: CircleAvatar(
                  child: Text(
                    _getInitials(
                      friend.username,
                    ),
                  ),
                ),
                title: Text(
                  friend.username,
                ),
                subtitle: Text(
                  friend.email,
                ),
                onTap: () async {

                  final room =
                  await ChatService()
                      .createOrGetRoom(
                    friend.id,
                  );

                  if (!context.mounted) return;

                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => ChatScreen(
                        roomId: room.id,
                        otherUser: friend,
                      ),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}