import 'package:flutter/material.dart';

import '../models/friend_request_model.dart';
import '../services/friend_service.dart';

class RequestsScreen extends StatefulWidget {
  final VoidCallback? onRequestsChanged;

  const RequestsScreen({super.key, this.onRequestsChanged});

  @override
  State<RequestsScreen> createState() => RequestsScreenState();
}

class RequestsScreenState extends State<RequestsScreen> {
  final FriendService friendService = FriendService();
  late Future<List<FriendRequestModel>> _requestsFuture;

  @override
  void initState() {
    super.initState();
    _loadRequests();
  }

  void _loadRequests() {
    setState(() {
      _requestsFuture = friendService.fetchPendingRequests();
    });
  }

  void refresh() => _loadRequests();

  Future<void> _acceptRequest(int id) async {
    await friendService.acceptRequest(id);
    _loadRequests();
    widget.onRequestsChanged?.call();
  }

  Future<void> _rejectRequest(int id) async {
    await friendService.rejectRequest(id);
    _loadRequests();
    widget.onRequestsChanged?.call();
  }

  String _getInitials(String username) {
    if (username.isEmpty) return '?';
    return username[0].toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text(
          'Requests',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 24,
            letterSpacing: -0.5,
          ),
        ),
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      body: FutureBuilder<List<FriendRequestModel>>(
        future: _requestsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(snapshot.error.toString()),
                  const SizedBox(height: 8),
                  TextButton(
                    onPressed: _loadRequests,
                    child: const Text('Try again'),
                  ),
                ],
              ),
            );
          }

          final requests = snapshot.data ?? [];

          if (requests.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.notifications_none,
                      size: 64, color: Colors.grey.shade400),
                  const SizedBox(height: 16),
                  Text(
                    'No pending requests',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey.shade600,
                    ),
                  ),
                ],
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: () async => _loadRequests(),
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              itemCount: requests.length,
              itemBuilder: (context, index) {
                final request = requests[index];

                return Card(
                  margin: const EdgeInsets.only(bottom: 8),
                  child: ListTile(
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    leading: CircleAvatar(
                      backgroundColor: theme.colorScheme.primary,
                      child: Text(
                        _getInitials(request.senderUsername),
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    title: Text(
                      request.senderUsername,
                      style: const TextStyle(fontWeight: FontWeight.w600),
                    ),
                    subtitle: const Text('Sent you a friend request'),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.check_circle),
                          color: Colors.green.shade600,
                          tooltip: 'Accept',
                          onPressed: () => _acceptRequest(request.id),
                        ),
                        IconButton(
                          icon: const Icon(Icons.cancel),
                          color: Colors.red.shade600,
                          tooltip: 'Reject',
                          onPressed: () => _rejectRequest(request.id),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
