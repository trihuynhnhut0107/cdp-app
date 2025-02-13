import 'package:flutter/material.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool _darkMode = false;
  bool _notifications = true;
  String _selectedLanguage = "English";

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return ListView(
      padding: EdgeInsets.all(16),
      children: [
        _buildSectionTitle("Preferences"),
        _buildSwitchTile(
            title: "Dark Mode",
            icon: Icons.dark_mode,
            value: _darkMode,
            onChanged: (val) => setState(() => _darkMode = val),
            color: colorScheme.primary),
        _buildSwitchTile(
            title: "Notifications",
            icon: Icons.notifications,
            value: _notifications,
            onChanged: (val) => setState(() => _notifications = val),
            color: colorScheme.primary),
        _buildSectionTitle("General"),
        ListTile(
          leading: Icon(Icons.language, color: colorScheme.primary),
          title: Text("Language"),
          trailing: DropdownButton<String>(
            value: _selectedLanguage,
            items: ["English", "Spanish", "French", "German"].map((lang) {
              return DropdownMenuItem(value: lang, child: Text(lang));
            }).toList(),
            onChanged: (val) => setState(() => _selectedLanguage = val!),
          ),
        ),
        ListTile(
          leading: Icon(Icons.account_circle, color: colorScheme.primary),
          title: Text("Account Settings"),
          trailing: Icon(Icons.arrow_forward_ios),
          onTap: () {
            // Navigate to Account Settings page (placeholder action)
          },
        ),
      ],
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 10),
      child: Text(
        title,
        style: TextStyle(
            fontSize: 16, fontWeight: FontWeight.bold, color: Colors.grey[700]),
      ),
    );
  }

  Widget _buildSwitchTile(
      {required String title,
      required IconData icon,
      required bool value,
      required Function(bool) onChanged,
      required Color color}) {
    return SwitchListTile(
      title: Text(title),
      secondary: Icon(icon, color: color),
      value: value,
      onChanged: onChanged,
    );
  }
}
