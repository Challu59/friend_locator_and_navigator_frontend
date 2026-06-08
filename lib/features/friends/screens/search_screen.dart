import 'package:flutter/material.dart';

import '../models/searchable_user_model.dart';
import '../services/friend_service.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => SearchScreenState();
}

class SearchScreenState extends State<SearchScreen> {
  final FriendService _friendService = FriendService();
  final TextEditingController _searchController = TextEditingController();

  List<SearchableUserModel> _results = [];
  bool _isLoading = false;
  String? _error;
  final Set<int> _sentRequestIds = {};

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _search() async {
    final query = _searchController.text.trim();
    if (query.isEmpty) {
      setState(() {
        _results = [];
        _error = null;
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final results = await _friendService.searchUsers(query);
      if (!mounted) return;
      setState(() {
        _results = results;
        _isLoading = false;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _isLoading = false;
        _error = 'Could not search users';
      });
    }
  }

  Future<void> _sendRequest(SearchableUserModel user) async {
    try {
      await _friendService.sendFriendRequest(user.id);
      if (!mounted) return;
      setState(() {
        _sentRequestIds.add(user.id);
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Friend request sent to ${user.username}'),
          behavior: SnackBarBehavior.floating,
        ),
      );
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Failed to send friend request'),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  String _getInitials(String username) {
    if (username.isEmpty) return '?';
    return username[0].toUpperCase();
  }

  Widget _buildActionButton(SearchableUserModel user) {
    if (user.isFriend) {
      return Text(
        'Friends',
        style: TextStyle(color: Colors.green.shade700, fontWeight: FontWeight.w600),
      );
    }
    if (user.isPendingSent || _sentRequestIds.contains(user.id)) {
      return Text(
        'Pending',
        style: TextStyle(color: Colors.orange.shade700, fontWeight: FontWeight.w600),
      );
    }
    if (user.isPendingReceived) {
      return Text(
        'Respond in Requests',
        style: TextStyle(color: Colors.blue.shade700, fontSize: 12),
      );
    }
    return TextButton(
      onPressed: () => _sendRequest(user),
      child: const Text('Add Friend'),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text(
          'Search',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 24,
            letterSpacing: -0.5,
          ),
        ),
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search by username or email',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          _searchController.clear();
                          _search();
                        },
                      )
                    : null,
              ),
              onSubmitted: (_) => _search(),
              onChanged: (_) => setState(() {}),
              textInputAction: TextInputAction.search,
            ),
          ),
          if (_isLoading) const LinearProgressIndicator(minHeight: 2),
          Expanded(
            child: _buildBody(theme),
          ),
        ],
      ),
    );
  }

  Widget _buildBody(ThemeData theme) {
    if (_error != null) {
      return Center(child: Text(_error!));
    }

    if (_searchController.text.trim().isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.person_search, size: 64, color: Colors.grey.shade400),
            const SizedBox(height: 16),
            Text(
              'Find people to connect with',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey.shade600,
              ),
            ),
          ],
        ),
      );
    }

    if (_results.isEmpty && !_isLoading) {
      return const Center(child: Text('No users found'));
    }

    return ListView.separated(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: _results.length,
      separatorBuilder: (_, __) => Divider(color: Colors.grey.shade300, height: 1),
      itemBuilder: (context, index) {
        final user = _results[index];
        return ListTile(
          contentPadding: const EdgeInsets.symmetric(vertical: 4),
          leading: CircleAvatar(
            backgroundColor: theme.colorScheme.primary,
            child: Text(
              _getInitials(user.username),
              style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
          ),
          title: Text(
            user.username,
            style: const TextStyle(fontWeight: FontWeight.w600),
          ),
          subtitle: Text(user.email),
          trailing: _buildActionButton(user),
        );
      },
    );
  }
}
