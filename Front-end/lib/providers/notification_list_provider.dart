import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cdp_app/models/notification_data.dart';
import 'package:cdp_app/services/notification_service.dart';
import 'package:cdp_app/providers/user_provider.dart';

/// Provider for notification state management
final notificationProvider =
    StateNotifierProvider<NotificationNotifier, NotificationState>((ref) {
  return NotificationNotifier(ref);
});

/// Provider for unread notification count
final unreadNotificationCountProvider = Provider<int>((ref) {
  final notificationState = ref.watch(notificationProvider);
  return notificationState.notifications.where((n) => !n.isRead).length;
});

class NotificationState {
  final List<NotificationData> notifications;
  final bool isLoading;
  final String? error;

  NotificationState({
    this.notifications = const [],
    this.isLoading = false,
    this.error,
  });

  NotificationState copyWith({
    List<NotificationData>? notifications,
    bool? isLoading,
    String? error,
  }) {
    return NotificationState(
      notifications: notifications ?? this.notifications,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
    );
  }
}

class NotificationNotifier extends StateNotifier<NotificationState> {
  final Ref ref;

  NotificationNotifier(this.ref) : super(NotificationState());

  /// Fetch notifications for the current user
  Future<void> fetchNotifications() async {
    final userId = ref.read(userIdProvider);

    if (userId == null) {
      state = state.copyWith(
        error: 'User not logged in',
        isLoading: false,
      );
      return;
    }

    state = state.copyWith(isLoading: true, error: null);

    try {
      final notifications =
          await NotificationService.fetchNotifications(userId);

      // Sort notifications: unread first, then by date (newest first)
      notifications.sort((a, b) {
        if (a.isRead != b.isRead) {
          return a.isRead ? 1 : -1; // Unread first
        }
        return b.createdAt.compareTo(a.createdAt); // Newest first
      });

      state = state.copyWith(
        notifications: notifications,
        isLoading: false,
        error: null,
      );
    } catch (e) {
      state = state.copyWith(
        error: e.toString(),
        isLoading: false,
      );
    }
  }

  /// Resort notifications by read status and date
  void _resortNotifications() {
    final sorted = List<NotificationData>.from(state.notifications);
    sorted.sort((a, b) {
      if (a.isRead != b.isRead) {
        return a.isRead ? 1 : -1; // Unread first
      }
      return b.createdAt.compareTo(a.createdAt); // Newest first
    });

    state = state.copyWith(notifications: sorted);
  }

  /// Mark a notification as read
  Future<bool> markAsRead(String notificationId) async {
    final userId = ref.read(userIdProvider);
    if (userId == null) return false;

    final success =
        await NotificationService.markAsRead(userId, notificationId);

    if (success) {
      // Update local state
      final updatedNotifications = state.notifications.map((notification) {
        if (notification.notificationId == notificationId) {
          return NotificationData(
            userId: notification.userId,
            notificationId: notification.notificationId,
            isRead: true,
            createdAt: notification.createdAt,
            updatedAt: DateTime.now(),
            notification: notification.notification,
          );
        }
        return notification;
      }).toList();

      state = state.copyWith(notifications: updatedNotifications);
      _resortNotifications();
    }

    return success;
  }

  /// Mark a notification as unread
  Future<bool> markAsUnread(String notificationId) async {
    final userId = ref.read(userIdProvider);
    if (userId == null) return false;

    final success =
        await NotificationService.markAsUnread(userId, notificationId);

    if (success) {
      // Update local state
      final updatedNotifications = state.notifications.map((notification) {
        if (notification.notificationId == notificationId) {
          return NotificationData(
            userId: notification.userId,
            notificationId: notification.notificationId,
            isRead: false,
            createdAt: notification.createdAt,
            updatedAt: DateTime.now(),
            notification: notification.notification,
          );
        }
        return notification;
      }).toList();

      state = state.copyWith(notifications: updatedNotifications);
      _resortNotifications();
    }

    return success;
  }

  /// Delete a notification
  Future<bool> deleteNotification(String notificationId) async {
    final userId = ref.read(userIdProvider);
    if (userId == null) return false;

    final success =
        await NotificationService.deleteNotification(userId, notificationId);

    if (success) {
      // Remove from local state
      final updatedNotifications = state.notifications
          .where(
              (notification) => notification.notificationId != notificationId)
          .toList();

      state = state.copyWith(notifications: updatedNotifications);
    }

    return success;
  }

  /// Toggle read status of a notification
  Future<bool> toggleReadStatus(String notificationId) async {
    print('=== Toggle Read Status Debug ===');
    print(
        'Received Notification ID: "$notificationId" (length: ${notificationId.length})');

    if (notificationId.isEmpty) {
      print('❌ ERROR: Empty notification ID passed to toggleReadStatus');
      return false;
    }

    final notification = state.notifications.firstWhere(
      (n) => n.notificationId == notificationId,
      orElse: () => throw Exception('Notification not found'),
    );

    print('Found notification: ${notification.notification.title}');
    print(
        'Stored notification ID: "${notification.notificationId}" (length: ${notification.notificationId.length})');
    print('Current read status: ${notification.isRead}');
    print('Will call: ${notification.isRead ? "markAsUnread" : "markAsRead"}');

    if (notification.isRead) {
      return await markAsUnread(notificationId);
    } else {
      return await markAsRead(notificationId);
    }
  }

  /// Mark all notifications as read
  Future<void> markAllAsRead() async {
    final userId = ref.read(userIdProvider);
    if (userId == null) return;

    final success = await NotificationService.markAllAsRead(userId);

    if (success) {
      // Update local state - mark all notifications as read
      final updatedNotifications = state.notifications.map((notification) {
        return NotificationData(
          userId: notification.userId,
          notificationId: notification.notificationId,
          isRead: true,
          createdAt: notification.createdAt,
          updatedAt: DateTime.now(),
          notification: notification.notification,
        );
      }).toList();

      state = state.copyWith(notifications: updatedNotifications);
    }
  }

  /// Clear all notifications (delete all)
  Future<void> clearAllNotifications() async {
    final userId = ref.read(userIdProvider);
    if (userId == null) return;

    final notificationIds =
        state.notifications.map((n) => n.notificationId).toList();

    for (final notificationId in notificationIds) {
      await deleteNotification(notificationId);
    }
  }

  /// Refresh notifications (alias for fetchNotifications)
  Future<void> refresh() => fetchNotifications();
}
