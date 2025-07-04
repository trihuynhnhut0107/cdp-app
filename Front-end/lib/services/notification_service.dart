import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:cdp_app/models/notification_data.dart';

class NotificationService {
  static const String baseUrl = 'http://10.0.2.2:8000';

  /// Fetch notifications for a specific user
  static Future<List<NotificationData>> fetchNotifications(
      String userId) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/notification/$userId'),
        headers: {'Content-Type': 'application/json'},
      );

      print('Notification API Response: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);
        print('Parsed JSON: $jsonData');

        final notificationResponse = NotificationResponse.fromJson(jsonData);
        print(
            'Parsed notifications count: ${notificationResponse.notifications.length}');

        return notificationResponse.notifications;
      } else {
        throw Exception(
            'Failed to fetch notifications: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      print('Error fetching notifications: $e');
      throw Exception('Error fetching notifications: $e');
    }
  }

  /// Mark a notification as read
  static Future<bool> markAsRead(String userId, String notificationId) async {
    try {
      // Validate inputs before making API call
      if (userId.isEmpty) {
        print('❌ ERROR: User ID is empty');
        return false;
      }

      if (notificationId.isEmpty) {
        print('❌ ERROR: Notification ID is empty');
        return false;
      }

      final url = '$baseUrl/notification/$userId/$notificationId/read';
      print('Marking notification as read: $url');
      print('User ID: "$userId" (length: ${userId.length})');
      print(
          'Notification ID: "$notificationId" (length: ${notificationId.length})');

      final response = await http.patch(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
      );

      print('Mark as read response: ${response.statusCode}');
      print('Mark as read response body: ${response.body}');

      if (response.statusCode == 200) {
        return true;
      } else {
        print(
            'Failed to mark as read: ${response.statusCode} - ${response.body}');
        return false;
      }
    } catch (e) {
      print('Error marking notification as read: $e');
      return false;
    }
  }

  /// Mark a notification as unread
  static Future<bool> markAsUnread(String userId, String notificationId) async {
    try {
      final url = '$baseUrl/notification/$userId/$notificationId/unread';
      print('Marking notification as unread: $url');
      print('User ID: $userId');
      print('Notification ID: $notificationId');

      final response = await http.patch(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
      );

      print('Mark as unread response: ${response.statusCode}');
      print('Mark as unread response body: ${response.body}');

      if (response.statusCode == 200) {
        return true;
      } else {
        print(
            'Failed to mark as unread: ${response.statusCode} - ${response.body}');
        return false;
      }
    } catch (e) {
      print('Error marking notification as unread: $e');
      return false;
    }
  }

  /// Mark all notifications as read for a user
  static Future<bool> markAllAsRead(String userId) async {
    try {
      final response = await http.patch(
        Uri.parse('$baseUrl/notification/$userId/read-all'),
        headers: {'Content-Type': 'application/json'},
      );

      return response.statusCode == 200;
    } catch (e) {
      print('Error marking all notifications as read: $e');
      return false;
    }
  }

  /// Delete a notification
  static Future<bool> deleteNotification(
      String userId, String notificationId) async {
    try {
      final url = '$baseUrl/notification/$userId/$notificationId';
      print('Deleting notification: $url');
      print('User ID: $userId');
      print('Notification ID: $notificationId');

      final response = await http.delete(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
      );

      print('Delete response: ${response.statusCode}');
      print('Delete response body: ${response.body}');

      if (response.statusCode == 200) {
        return true;
      } else {
        print(
            'Failed to delete notification: ${response.statusCode} - ${response.body}');
        return false;
      }
    } catch (e) {
      print('Error deleting notification: $e');
      return false;
    }
  }
}
