import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cdp_app/utils/notification_debug_helper.dart';
import 'package:cdp_app/providers/notification_list_provider.dart';
import 'package:cdp_app/providers/user_provider.dart';

class NotificationDebugPage extends ConsumerWidget {
  const NotificationDebugPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notificationState = ref.watch(notificationProvider);
    final userId = ref.watch(userIdProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Notification Debug'),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Current user info
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Current User',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    const SizedBox(height: 8),
                    Text('User ID: ${userId ?? "Not logged in"}'),
                    const SizedBox(height: 8),
                    Text(
                        'Notifications loaded: ${notificationState.notifications.length}'),
                    if (notificationState.error != null) ...[
                      const SizedBox(height: 8),
                      Text(
                        'Error: ${notificationState.error}',
                        style: const TextStyle(color: Colors.red),
                      ),
                    ],
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Debug buttons
            Text(
              'Debug Actions',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 12),

            // Test API response parsing
            ElevatedButton.icon(
              onPressed: () {
                NotificationDebugHelper.testApiResponseParsing();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Check console for API parsing test results'),
                  ),
                );
              },
              icon: const Icon(Icons.science),
              label: const Text('Test API Response Parsing'),
            ),

            const SizedBox(height: 8),

            // Fetch notifications
            ElevatedButton.icon(
              onPressed: () {
                ref.read(notificationProvider.notifier).fetchNotifications();
              },
              icon: const Icon(Icons.refresh),
              label: const Text('Fetch Notifications'),
            ),

            const SizedBox(height: 8),

            // Test with sample notification ID
            ElevatedButton.icon(
              onPressed: () {
                if (userId != null) {
                  NotificationDebugHelper.testApiUrls(
                    userId,
                    '54c35fb0-eac7-4d25-925b-6791319d6570', // Sample ID from your API
                  );
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Check console for API URL test results'),
                    ),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Please log in first'),
                    ),
                  );
                }
              },
              icon: const Icon(Icons.link),
              label: const Text('Test API URLs'),
            ),

            const SizedBox(height: 16),

            // Current notifications debug info
            if (notificationState.notifications.isNotEmpty) ...[
              Text(
                'Current Notifications',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: 12),
              Expanded(
                child: ListView.builder(
                  itemCount: notificationState.notifications.length,
                  itemBuilder: (context, index) {
                    final notification = notificationState.notifications[index];
                    return Card(
                      margin: const EdgeInsets.only(bottom: 8),
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Notification ${index + 1}',
                              style: Theme.of(context)
                                  .textTheme
                                  .titleSmall
                                  ?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                            ),
                            const SizedBox(height: 8),
                            Text('ID: "${notification.notificationId}"'),
                            Text('User ID: "${notification.userId}"'),
                            Text('Title: "${notification.notification.title}"'),
                            Text('Type: "${notification.notification.type}"'),
                            Text('Read: ${notification.isRead}'),
                            Text('Created: ${notification.createdAt}'),
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                ElevatedButton(
                                  onPressed: () {
                                    NotificationDebugHelper
                                        .logNotificationDetails(
                                      notification,
                                      prefix: '[DEBUG] ',
                                    );
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text(
                                            'Check console for notification details'),
                                      ),
                                    );
                                  },
                                  child: const Text('Log Details'),
                                ),
                                const SizedBox(width: 8),
                                ElevatedButton(
                                  onPressed: () async {
                                    if (userId != null) {
                                      print(
                                          '=== Testing Toggle Read Status ===');
                                      print(
                                          'Before: ${notification.isRead ? "Read" : "Unread"}');
                                      final success = await ref
                                          .read(notificationProvider.notifier)
                                          .toggleReadStatus(
                                              notification.notificationId);
                                      print('API Call Success: $success');
                                      print(
                                          'After: ${!notification.isRead ? "Read" : "Unread"}');
                                    }
                                  },
                                  child: Text(notification.isRead
                                      ? 'Mark Unread'
                                      : 'Mark Read'),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ] else ...[
              const SizedBox(height: 16),
              const Center(
                child: Text(
                    'No notifications loaded. Fetch notifications to see debug info.'),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
