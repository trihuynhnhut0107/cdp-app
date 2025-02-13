import 'package:flutter/material.dart';
import 'package:cdp_app/pages/notification_page.dart';
import 'package:cdp_app/pages/profile_page.dart';
import 'package:cdp_app/pages/settings_page.dart';
import 'package:cdp_app/pages/survey_home_page.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  late List<Map<String, dynamic>> _pages;

  @override
  void initState() {
    super.initState();
    _pages = [
      {"page": SurveyHomePage(), "icon": Icons.list, "label": "Surveys"},
      {
        "page": NotificationPage(),
        "icon": Icons.notifications,
        "label": "Notifications"
      },
      {"page": ProfilePage(), "icon": Icons.person, "label": "Profile"},
      {"page": SettingsPage(), "icon": Icons.settings, "label": "Settings"},
    ];
  }

  void _onItemTapped(int index) {
    setState(() => _selectedIndex = index);
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text("My App"),
        backgroundColor: colorScheme.primary,
      ),
      body: _pages[_selectedIndex]["page"],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        backgroundColor: Colors.white,
        selectedItemColor: colorScheme.primary,
        unselectedItemColor: colorScheme.onPrimary,
        type: BottomNavigationBarType.fixed,
        items: _pages
            .map((item) => BottomNavigationBarItem(
                icon: Icon(item["icon"]), label: item["label"]))
            .toList(),
      ),
    );
  }
}
