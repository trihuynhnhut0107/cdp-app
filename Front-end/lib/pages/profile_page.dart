import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cdp_app/middleware/auth_middleware.dart';
import 'package:cdp_app/providers/user_provider.dart';

class ProfilePage extends ConsumerWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colorScheme = Theme.of(context).colorScheme;
    final userDataAsync = ref.watch(userDataFutureProvider);

    return Column(
      children: [
        Container(
          padding: EdgeInsets.all(20),
          alignment: Alignment.center,
          color: colorScheme.primary.withOpacity(0.1),
          child: userDataAsync.when(
            data: (user) {
              if (user == null) {
                return Column(
                  children: [
                    CircleAvatar(
                      radius: 50,
                      child: Icon(Icons.person, size: 50),
                    ),
                    SizedBox(height: 10),
                    Text(
                      "No user data",
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      "Unable to load profile",
                      style: TextStyle(color: Colors.grey),
                    ),
                  ],
                );
              }

              return Column(
                children: [
                  CircleAvatar(
                    radius: 50,
                    backgroundColor: colorScheme.primary,
                    child: Text(
                      user.name.isNotEmpty ? user.name[0].toUpperCase() : '?',
                      style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                        color: colorScheme.onPrimary,
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    user.name,
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    user.email,
                    style: TextStyle(color: Colors.grey),
                  ),
                  SizedBox(height: 10),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: colorScheme.secondary.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.stars,
                          color: colorScheme.secondary,
                          size: 20,
                        ),
                        SizedBox(width: 5),
                        Text(
                          '${user.point} Points',
                          style: TextStyle(
                            color: colorScheme.secondary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              );
            },
            loading: () => Column(
              children: [
                CircleAvatar(
                  radius: 50,
                  child: CircularProgressIndicator(),
                ),
                SizedBox(height: 10),
                Text(
                  "Loading...",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                Text(
                  "Please wait",
                  style: TextStyle(color: Colors.grey),
                ),
              ],
            ),
            error: (error, stack) => Column(
              children: [
                CircleAvatar(
                  radius: 50,
                  child: Icon(Icons.error, size: 50, color: Colors.red),
                ),
                SizedBox(height: 10),
                Text(
                  "Error",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                Text(
                  "Failed to load profile",
                  style: TextStyle(color: Colors.grey),
                ),
                SizedBox(height: 10),
                ElevatedButton(
                  onPressed: () {
                    ref.invalidate(userDataFutureProvider);
                  },
                  child: Text('Retry'),
                ),
              ],
            ),
          ),
        ),
        Expanded(
          child: RefreshIndicator(
            onRefresh: () async {
              ref.invalidate(userDataFutureProvider);
              await ref.read(userDataFutureProvider.future);
            },
            child: ListView(
              children: [
                _buildListTile(Icons.person, "Edit Profile", context,
                    onTap: () {
                  // Handle Edit Profile
                  print('Edit Profile tapped');
                }),
                _buildListTile(Icons.lock, "Change Password", context,
                    onTap: () {
                  // Handle Change Password
                  print('Change Password tapped');
                }),
                _buildListTile(Icons.notifications, "Notifications", context,
                    onTap: () {
                  // Handle Notifications
                  print('Notifications tapped');
                }),
                _buildListTile(Icons.refresh, "Refresh Profile", context,
                    onTap: () {
                  // Handle Profile Refresh
                  ref.invalidate(userDataFutureProvider);
                }),
                _buildListTile(Icons.logout, "Logout", context, onTap: () {
                  // Handle Logout
                  AuthMiddleware.forceLogout(context, ref,
                      reason: 'You have been logged out successfully');
                }, isLogout: true),
              ],
            ),
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
