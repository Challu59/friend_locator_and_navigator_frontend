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
  int _unreadMessageCount = 0;

  final GlobalKey<ChatsScreenState> _chatsKey = GlobalKey();
  final GlobalKey<SearchScreenState> _searchKey = GlobalKey();
  final GlobalKey<RequestsScreenState> _requestsKey = GlobalKey();

  final FriendService _friendService = FriendService();

  late final List<Widget> _screens = [
    ChatsScreen(
      key: _chatsKey,
      onUnreadCountChanged: (count) {
        if (!mounted) return;
        setState(() => _unreadMessageCount = count);
      },
    ),
    RequestsScreen(
      key: _requestsKey,
      onRequestsChanged: _loadPendingCount,
    ),
    SearchScreen(key: _searchKey),
    const ProfileScreen(),
  ];

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
    if (_currentIndex == index) return;

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

    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _screens,
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          border: Border(
            top: BorderSide(color: Colors.grey.shade200, width: 1),
          ),
        ),
        child: NavigationBar(
          selectedIndex: _currentIndex,
          onDestinationSelected: _onTabSelected,
          elevation: 0,
          backgroundColor: Colors.white,
          height: 65,
          labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
          animationDuration: const Duration(milliseconds: 400),
          indicatorColor: theme.colorScheme.primary.withOpacity(0.12),
          destinations: [
            NavigationDestination(
              icon: _unreadMessageCount > 0
                  ? Badge(
                      label: Text(
                        _unreadMessageCount > 99
                            ? '99+'
                            : '$_unreadMessageCount',
                      ),
                      child: const Icon(Icons.chat_bubble_outline, size: 22),
                    )
                  : const Icon(Icons.chat_bubble_outline, size: 22),
              selectedIcon: _unreadMessageCount > 0
                  ? Badge(
                      label: Text(
                        _unreadMessageCount > 99
                            ? '99+'
                            : '$_unreadMessageCount',
                      ),
                      child: const Icon(Icons.chat_bubble, size: 22),
                    )
                  : const Icon(Icons.chat_bubble, size: 22),
              label: 'Chats',
            ),
            NavigationDestination(
              icon: _pendingRequestCount > 0
                  ? Badge(
                label: Text('$_pendingRequestCount'),
                child: const Icon(Icons.notifications_outlined, size: 24),
              )
                  : const Icon(Icons.notifications_outlined, size: 24),
              selectedIcon: _pendingRequestCount > 0
                  ? Badge(
                label: Text('$_pendingRequestCount'),
                child: const Icon(Icons.notifications, size: 24),
              )
                  : const Icon(Icons.notifications, size: 24),
              label: 'Requests',
            ),
            const NavigationDestination(
              icon: Icon(Icons.search, size: 24),
              selectedIcon: Icon(Icons.search, size: 24),
              label: 'Search',
            ),
            const NavigationDestination(
              icon: Icon(Icons.person_outline, size: 24),
              selectedIcon: Icon(Icons.person, size: 24),
              label: 'Profile',
            ),
          ],
        ),
      ),
    );
  }
}