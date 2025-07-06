import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cdp_app/providers/notification_list_provider.dart';
import 'package:cdp_app/models/notification_data.dart';
import 'package:cdp_app/pages/survey_page.dart';

class NotificationPage extends ConsumerStatefulWidget {
  const NotificationPage({super.key});

  @override
  ConsumerState<NotificationPage> createState() => _NotificationPageState();
}

class _NotificationPageState extends ConsumerState<NotificationPage> {
  bool _hasInitialized = false;

  @override
  void initState() {
    super.initState();
    // Fetch notifications when the page is first initialized
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        ref.read(notificationProvider.notifier).fetchNotifications();
        _hasInitialized = true;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final notificationState = ref.watch(notificationProvider);
    final unreadCount = ref.watch(unreadNotificationCountProvider);

    // Only fetch notifications if not yet initialized and page is empty and not currently loading
    if (!_hasInitialized &&
        notificationState.notifications.isEmpty &&
        !notificationState.isLoading &&
        notificationState.error == null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted && !_hasInitialized) {
          ref.read(notificationProvider.notifier).fetchNotifications();
          _hasInitialized = true;
        }
      });
    }

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header with refresh button and unread count
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Notifications',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      if (unreadCount > 0) ...[
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.primary,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            '$unreadCount unread',
                            style:
                                Theme.of(context).textTheme.bodySmall?.copyWith(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w600,
                                    ),
                          ),
                        ),
                        const SizedBox(width: 8),
                      ],
                      Text(
                        '${notificationState.notifications.length} total',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: Colors.grey,
                            ),
                      ),
                    ],
                  ),
                ],
              ),
              Row(
                children: [
                  // Mark all as read button
                  if (unreadCount > 0)
                    TextButton.icon(
                      onPressed: () {
                        ref.read(notificationProvider.notifier).markAllAsRead();
                      },
                      icon: const Icon(Icons.done_all, size: 16),
                      label: const Text('Mark all read'),
                    ),

                  // Refresh button
                  IconButton(
                    onPressed: () {
                      ref.read(notificationProvider.notifier).refresh();
                    },
                    icon: Icon(
                      Icons.refresh,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Content area
          Expanded(
            child: _buildContent(context, ref, notificationState),
          ),
        ],
      ),
    );
  }

  Widget _buildContent(
      BuildContext context, WidgetRef ref, NotificationState state) {
    if (state.isLoading && state.notifications.isEmpty) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 16),
            Text('Loading notifications...'),
          ],
        ),
      );
    }

    if (state.error != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: 64,
              color: Colors.red,
            ),
            const SizedBox(height: 16),
            Text(
              'Error loading notifications',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32.0),
              child: Text(
                state.error!,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Colors.red,
                    ),
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: () {
                ref.read(notificationProvider.notifier).fetchNotifications();
              },
              icon: const Icon(Icons.refresh),
              label: const Text('Retry'),
            ),
          ],
        ),
      );
    }

    if (state.notifications.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.notifications_none,
              size: 64,
              color: Colors.grey,
            ),
            const SizedBox(height: 16),
            Text(
              'No notifications',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: Colors.grey,
                  ),
            ),
            const SizedBox(height: 8),
            Text(
              'You\'re all caught up!',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Colors.grey,
                  ),
            ),
            const SizedBox(height: 16),
            TextButton.icon(
              onPressed: () {
                ref.read(notificationProvider.notifier).refresh();
              },
              icon: const Icon(Icons.refresh),
              label: const Text('Check for new notifications'),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: () => ref.read(notificationProvider.notifier).refresh(),
      child: Stack(
        children: [
          ListView.builder(
            itemCount: state.notifications.length,
            itemBuilder: (context, index) {
              final notification = state.notifications[index];

              // Debug logging to verify notification IDs
              print('Notification ${index + 1}:');
              print(
                  '  ID: "${notification.notificationId}" (length: ${notification.notificationId.length})');
              print(
                  '  User ID: "${notification.userId}" (length: ${notification.userId.length})');
              print('  Title: ${notification.notification.title}');
              print('  Read: ${notification.isRead}');
              print('  Created: ${notification.createdAt}');
              print('---');

              // Validate notification ID before creating the card
              if (notification.notificationId.isEmpty) {
                print(
                    '⚠️  WARNING: Empty notification ID for notification: ${notification.notification.title}');
              }

              return NotificationCard(
                notification: notification,
                onTap: () async {
                  // Store context reference before async operations
                  final navigatorContext = context;

                  // Debug: Check notification ID before attempting to mark as read
                  print('🔍 OnTap Debug:');
                  print('  Notification ID: "${notification.notificationId}"');
                  print('  ID Length: ${notification.notificationId.length}');
                  print('  Is Read: ${notification.isRead}');

                  // Always mark notification as read when tapped (if not already read)
                  if (!notification.isRead) {
                    // Additional check for empty notification ID
                    if (notification.notificationId.isEmpty) {
                      print(
                          '❌ ERROR: Cannot mark notification as read - empty notification ID');
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Error: Notification has no ID'),
                          backgroundColor: Colors.red,
                        ),
                      );
                      return;
                    }

                    final success = await ref
                        .read(notificationProvider.notifier)
                        .markAsRead(notification.notificationId);

                    if (!success) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content:
                                Text('Failed to mark notification as read')),
                      );
                    }
                  }

                  // Navigate to survey page if notification has survey_id
                  if (notification.notification.surveyId != null) {
                    Navigator.push(
                      navigatorContext,
                      MaterialPageRoute(
                        builder: (context) => SurveyPage(
                          uuid: notification.notification.surveyId!,
                        ),
                      ),
                    );
                  }
                  // For non-survey notifications, no additional action needed since we already marked as read
                },
                onToggleRead: () =>
                    _toggleNotificationRead(ref, context, notification),
                onDelete: () => _deleteNotification(ref, context, notification),
              );
            },
          ),

          // Loading overlay when refreshing
          if (state.isLoading && state.notifications.isNotEmpty)
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: SizedBox(
                height: 3,
                child: LinearProgressIndicator(
                  backgroundColor: Colors.transparent,
                ),
              ),
            ),
        ],
      ),
    );
  }

  // Helper method to toggle notification read status
  Future<void> _toggleNotificationRead(WidgetRef ref, BuildContext context,
      NotificationData notification) async {
    final wasRead = notification.isRead;
    final success = await ref
        .read(notificationProvider.notifier)
        .toggleReadStatus(notification.notificationId);

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(wasRead ? 'Marked as unread' : 'Marked as read'),
          duration: const Duration(seconds: 1),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to update notification status')),
      );
    }
  }

  // Helper method to delete notification
  Future<void> _deleteNotification(WidgetRef ref, BuildContext context,
      NotificationData notification) async {
    final success = await ref
        .read(notificationProvider.notifier)
        .deleteNotification(notification.notificationId);

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Notification deleted')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to delete notification')),
      );
    }
  }
}

class NotificationCard extends StatelessWidget {
  final NotificationData notification;
  final VoidCallback? onTap;
  final VoidCallback onToggleRead;
  final VoidCallback onDelete;

  const NotificationCard({
    super.key,
    required this.notification,
    this.onTap,
    required this.onToggleRead,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isRead = notification.isRead;

    return Card(
      margin: const EdgeInsets.only(bottom: 12.0),
      elevation: isRead ? 1 : 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
        side: BorderSide(
          color: isRead
              ? Colors.transparent
              : colorScheme.primary.withOpacity(0.2),
          width: isRead ? 0 : 2,
        ),
      ),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12.0),
          color: isRead ? null : colorScheme.primary.withOpacity(0.03),
          border: !isRead
              ? Border(
                  left: BorderSide(
                    color: colorScheme.primary,
                    width: 4,
                  ),
                )
              : null,
        ),
        child: InkWell(
          borderRadius: BorderRadius.circular(12.0),
          onTap: onTap ??
              onToggleRead, // Use onTap if provided, otherwise default to onToggleRead
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header with read indicator and actions
                Row(
                  children: [
                    // Read/Unread indicator
                    Container(
                      width: 12,
                      height: 12,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: isRead
                            ? Colors.grey.withOpacity(0.5)
                            : colorScheme.primary,
                        border: Border.all(
                          color: isRead ? Colors.grey : colorScheme.primary,
                          width: isRead ? 1 : 2,
                        ),
                      ),
                      child: isRead
                          ? Icon(
                              Icons.check,
                              size: 8,
                              color: Colors.grey,
                            )
                          : null,
                    ),
                    const SizedBox(width: 12),

                    // Type badge
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: _getTypeColor(notification.notification.type)
                            .withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        notification.notification.type.toUpperCase(),
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          color: _getTypeColor(notification.notification.type),
                        ),
                      ),
                    ),

                    const Spacer(),

                    // Time ago
                    Text(
                      _formatTimeAgo(notification.createdAt),
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Colors.grey,
                          ),
                    ),

                    // More actions menu
                    PopupMenuButton<String>(
                      onSelected: (value) {
                        switch (value) {
                          case 'toggle':
                            onToggleRead();
                            break;
                          case 'delete':
                            onDelete();
                            break;
                        }
                      },
                      itemBuilder: (context) => [
                        PopupMenuItem(
                          value: 'toggle',
                          child: Row(
                            children: [
                              Icon(
                                isRead
                                    ? Icons.mark_email_unread
                                    : Icons.mark_email_read,
                                size: 16,
                              ),
                              const SizedBox(width: 8),
                              Text(isRead ? 'Mark as Unread' : 'Mark as Read'),
                            ],
                          ),
                        ),
                        const PopupMenuItem(
                          value: 'delete',
                          child: Row(
                            children: [
                              Icon(Icons.delete, size: 16, color: Colors.red),
                              SizedBox(width: 8),
                              Text('Delete',
                                  style: TextStyle(color: Colors.red)),
                            ],
                          ),
                        ),
                      ],
                      child: Icon(
                        Icons.more_vert,
                        color: Colors.grey,
                        size: 16,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 12),

                // Title with navigation hint for survey notifications
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        notification.notification.title,
                        style: Theme.of(context)
                            .textTheme
                            .titleMedium
                            ?.copyWith(
                              fontWeight:
                                  isRead ? FontWeight.normal : FontWeight.bold,
                              color: isRead ? Colors.grey[700] : null,
                            ),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2,
                      ),
                    ),
                    // Show navigation icon for survey notifications
                    if (notification.notification.surveyId != null) ...[
                      const SizedBox(width: 8),
                      Icon(
                        Icons.arrow_forward_ios,
                        size: 16,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ],
                  ],
                ),

                const SizedBox(height: 8),

                // Message
                Text(
                  notification.notification.message,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: isRead ? Colors.grey[600] : Colors.grey[800],
                      ),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 3,
                ),

                // Survey action hint
                if (notification.notification.surveyId != null) ...[
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(
                        Icons.touch_app,
                        size: 14,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        'Tap to view survey',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: Theme.of(context).colorScheme.primary,
                              fontWeight: FontWeight.w500,
                            ),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  Color _getTypeColor(String type) {
    switch (type.toLowerCase()) {
      case 'survey':
        return Colors.blue;
      case 'alert':
        return Colors.red;
      case 'info':
        return Colors.green;
      case 'warning':
        return Colors.orange;
      default:
        return Colors.grey;
    }
  }

  String _formatTimeAgo(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inDays > 7) {
      return '${dateTime.day}/${dateTime.month}';
    } else if (difference.inDays > 0) {
      return '${difference.inDays}d ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours}h ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes}m ago';
    } else {
      return 'Just now';
    }
  }
}
