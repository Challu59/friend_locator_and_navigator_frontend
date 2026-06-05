import 'package:flutter/material.dart';

import '../models/friend_request_model.dart';
import '../services/friend_service.dart';

class RequestsScreen extends StatefulWidget {
  const RequestsScreen({super.key});

  @override
  State<RequestsScreen> createState() =>
      _RequestsScreenState();
}

class _RequestsScreenState extends State<RequestsScreen> {

  final FriendService friendService = FriendService();

  Future<void> _acceptRequest(int id) async {
    await friendService.acceptRequest(id);

    setState(() {});
  }

  Future<void> _rejectRequest(int id) async {
    await friendService.rejectRequest(id);

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Friend Requests"),
      ),
      body: FutureBuilder<List<FriendRequestModel>>(
        future: friendService.fetchPendingRequests(),
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

          final requests = snapshot.data ?? [];

          if (requests.isEmpty) {
            return const Center(
              child: Text("No pending requests"),
            );
          }

          return ListView.builder(
            itemCount: requests.length,
            itemBuilder: (context, index) {

              final request = requests[index];

              return Card(
                margin: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                child: ListTile(
                  title: Text(
                    request.senderUsername,
                  ),
                  subtitle: const Text(
                    "Sent you a friend request",
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [

                      IconButton(
                        icon: const Icon(
                          Icons.check_circle,
                          color: Colors.green,
                        ),
                        onPressed: () =>
                            _acceptRequest(request.id),
                      ),

                      IconButton(
                        icon: const Icon(
                          Icons.cancel,
                          color: Colors.red,
                        ),
                        onPressed: () =>
                            _rejectRequest(request.id),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}