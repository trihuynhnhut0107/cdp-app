import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cdp_app/pages/notification_page.dart';
import 'package:cdp_app/pages/profile_page.dart';
import 'package:cdp_app/pages/settings_page.dart';
import 'package:cdp_app/pages/survey_home_page.dart';
import 'package:cdp_app/providers/notification_list_provider.dart';

class MainScreen extends ConsumerStatefulWidget {
  const MainScreen({super.key});

  @override
  ConsumerState<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends ConsumerState<MainScreen> {
  int _selectedIndex = 0;

  // Create page instances once to avoid recreation
  late final List<Widget> _pages;
  late final List<Map<String, dynamic>> _pageData;

  @override
  void initState() {
    super.initState();

    // Create pages once and reuse them
    _pages = [
      const SurveyHomePage(),
      const NotificationPage(),
      const ProfilePage(),
      const SettingsPage(),
    ];

    _pageData = [
      {"icon": Icons.list, "label": "Surveys"},
      {"icon": Icons.notifications, "label": "Notifications"},
      {"icon": Icons.person, "label": "Profile"},
      {"icon": Icons.settings, "label": "Settings"},
    ];
  }

  void _onItemTapped(int index) {
    setState(() => _selectedIndex = index);
  }

  Widget _buildNotificationIcon(int unreadCount) {
    if (unreadCount == 0) {
      return Icon(Icons.notifications);
    }

    return Badge(
      label: Text(
        unreadCount > 99 ? '99+' : unreadCount.toString(),
        style: const TextStyle(
          color: Colors.white,
          fontSize: 10,
          fontWeight: FontWeight.bold,
        ),
      ),
      backgroundColor: Colors.red,
      child: Icon(Icons.notifications),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final unreadCount = ref.watch(unreadNotificationCountProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Home"),
        backgroundColor: colorScheme.primary,
      ),
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        type: BottomNavigationBarType.fixed,
        items: _pageData.asMap().entries.map((entry) {
          final index = entry.key;
          final pageData = entry.value;

          return BottomNavigationBarItem(
            icon: index == 1 // Notifications tab
                ? _buildNotificationIcon(unreadCount)
                : Icon(pageData["icon"]),
            label: pageData["label"],
          );
        }).toList(),
        selectedItemColor: colorScheme.primary,
        unselectedItemColor: colorScheme.onSurfaceVariant,
        showUnselectedLabels: true,
      ),
    );
  }
}
