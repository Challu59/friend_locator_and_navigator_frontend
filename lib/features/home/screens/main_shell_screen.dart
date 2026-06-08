import 'package:flutter/material.dart';

import '../../friends/screens/requests_screen.dart';
import '../../friends/screens/search_screen.dart';
import '../../friends/services/friend_service.dart';
import 'chats_screen.dart';
import 'profile_screen.dart';

class MainShellScreen extends StatefulWidget {
  const MainShellScreen({super.key});

  @override
  State<MainShellScreen> createState() => _MainShellScreenState();
}

class _MainShellScreenState extends State<MainShellScreen> {
  int _currentIndex = 0;
  int _pendingRequestCount = 0;

  final GlobalKey<ChatsScreenState> _chatsKey = GlobalKey();
  final GlobalKey<SearchScreenState> _searchKey = GlobalKey();
  final GlobalKey<RequestsScreenState> _requestsKey = GlobalKey();

  final FriendService _friendService = FriendService();

  @override
  void initState() {
    super.initState();
    _loadPendingCount();
  }

  Future<void> _loadPendingCount() async {
    try {
      final requests = await _friendService.fetchPendingRequests();
      if (!mounted) return;
      setState(() => _pendingRequestCount = requests.length);
    } catch (_) {}
  }

  void _onTabSelected(int index) {
    setState(() => _currentIndex = index);

    if (index == 0) {
      _chatsKey.currentState?.refresh();
    } else if (index == 1) {
      _requestsKey.currentState?.refresh();
      _loadPendingCount();
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final screens = [
      ChatsScreen(key: _chatsKey),
      RequestsScreen(
        key: _requestsKey,
        onRequestsChanged: _loadPendingCount,
      ),
      SearchScreen(key: _searchKey),
      const ProfileScreen(),
    ];

    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: screens,
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: _onTabSelected,
        destinations: [
          const NavigationDestination(
            icon: Icon(Icons.chat_bubble_outline),
            selectedIcon: Icon(Icons.chat_bubble),
            label: 'Chats',
          ),
          NavigationDestination(
            icon: _pendingRequestCount > 0
                ? Badge(
                    label: Text('$_pendingRequestCount'),
                    child: const Icon(Icons.notifications_outlined),
                  )
                : const Icon(Icons.notifications_outlined),
            selectedIcon: _pendingRequestCount > 0
                ? Badge(
                    label: Text('$_pendingRequestCount'),
                    child: const Icon(Icons.notifications),
                  )
                : const Icon(Icons.notifications),
            label: 'Requests',
          ),
          const NavigationDestination(
            icon: Icon(Icons.search),
            selectedIcon: Icon(Icons.search),
            label: 'Search',
          ),
          const NavigationDestination(
            icon: Icon(Icons.person_outline),
            selectedIcon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
        indicatorColor: theme.colorScheme.primary.withValues(alpha: 0.15),
      ),
    );
  }
}
