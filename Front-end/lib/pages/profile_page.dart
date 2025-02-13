import 'package:cdp_app/pages/login_page.dart';
import 'package:flutter/material.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Column(
      children: [
        Container(
          padding: EdgeInsets.all(20),
          alignment: Alignment.center,
          color: colorScheme.primary.withOpacity(0.1),
          child: Column(
            children: [
              CircleAvatar(
                radius: 50,
              ),
              SizedBox(height: 10),
              Text(
                "John Doe",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              Text(
                "johndoe@example.com",
                style: TextStyle(color: Colors.grey),
              ),
            ],
          ),
        ),
        Expanded(
          child: ListView(
            children: [
              _buildListTile(Icons.person, "Edit Profile", context, onTap: () {
                // Handle Edit Profile
                print('Edit Profile tapped');
              }),
              _buildListTile(Icons.lock, "Change Password", context, onTap: () {
                // Handle Change Password
                print('Change Password tapped');
              }),
              _buildListTile(Icons.notifications, "Notifications", context,
                  onTap: () {
                // Handle Notifications
                print('Notifications tapped');
              }),
              _buildListTile(Icons.logout, "Logout", context, onTap: () {
                // Handle Logout
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => LoginPage()),
                  (Route<dynamic> route) => false, // Remove all previous routes
                );
              }, isLogout: true),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildListTile(IconData icon, String title, BuildContext context,
      {bool isLogout = false, required void Function() onTap}) {
    final colorScheme = Theme.of(context).colorScheme;

    return ListTile(
      leading: Icon(icon, color: isLogout ? Colors.red : colorScheme.primary),
      title: Text(title,
          style: TextStyle(color: isLogout ? Colors.red : Colors.black)),
      trailing: Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
      onTap: onTap,
    );
  }
}
