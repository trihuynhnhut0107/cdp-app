import 'package:cdp_app/models/notification_data.dart';

class NotificationDebugHelper {
  /// Test parsing the sample API response structure
  static void testApiResponseParsing() {
    print('=== Testing Notification API Response Parsing ===');

    // Your exact API response structure
    final sampleApiResponse = {
      "message": "User notifications fetched successfully",
      "status": 200,
      "metadata": [
        {
          "user_id": "58211fc7-7a06-4444-a9f9-073dca0df119",
          "notification_id": "54c35fb0-eac7-4d25-925b-6791319d6570",
          "is_read": false,
          "createdAt": "2025-06-14T10:33:37.427Z",
          "updatedAt": "2025-06-14T10:33:37.427Z",
          "Notification": {
            "title": "New survey!",
            "message": "Second try Notification is now available!",
            "type": "survey"
          }
        }
      ]
    };

    try {
      final response = NotificationResponse.fromJson(sampleApiResponse);
      print('✅ Successfully parsed API response');
      print('   Message: ${response.message}');
      print('   Status: ${response.status}');
      print('   Notifications count: ${response.notifications.length}');

      if (response.notifications.isNotEmpty) {
        final notification = response.notifications.first;
        print('\n📧 First Notification Details:');
        print('   User ID: ${notification.userId}');
        print('   Notification ID: ${notification.notificationId}');
        print('   Is Read: ${notification.isRead}');
        print('   Title: ${notification.notification.title}');
        print('   Message: ${notification.notification.message}');
        print('   Type: ${notification.notification.type}');
        print('   Created: ${notification.createdAt}');
        print('   Updated: ${notification.updatedAt}');

        // Test the API endpoint URL construction
        print('\n🔗 API Endpoint URLs that would be called:');
        print(
            '   Mark as read: http://localhost:8000/notification/${notification.userId}/${notification.notificationId}/read');
        print(
            '   Mark as unread: http://localhost:8000/notification/${notification.userId}/${notification.notificationId}/unread');
        print(
            '   Delete: http://localhost:8000/notification/${notification.userId}/${notification.notificationId}');
      }
    } catch (e) {
      print('❌ Error parsing API response: $e');
    }
  }

  /// Log all details of a notification for debugging
  static void logNotificationDetails(NotificationData notification,
      {String prefix = ''}) {
    print('${prefix}Notification Details:');
    print('${prefix}  ID: "${notification.notificationId}"');
    print('${prefix}  User ID: "${notification.userId}"');
    print('${prefix}  Read Status: ${notification.isRead}');
    print('${prefix}  Title: "${notification.notification.title}"');
    print('${prefix}  Message: "${notification.notification.message}"');
    print('${prefix}  Type: "${notification.notification.type}"');
    print('${prefix}  Created: ${notification.createdAt}');
    print('${prefix}  Updated: ${notification.updatedAt}');
  }

  /// Test API call URLs for debugging
  static void testApiUrls(String userId, String notificationId) {
    print('=== Testing API URL Construction ===');
    print('User ID: $userId');
    print('Notification ID: $notificationId');
    print('');
    print('Expected API Endpoints:');
    print(
        '1. Mark as read: PATCH http://localhost:8000/notification/$userId/$notificationId/read');
    print(
        '2. Mark as unread: PATCH http://localhost:8000/notification/$userId/$notificationId/unread');
    print(
        '3. Delete: DELETE http://localhost:8000/notification/$userId/$notificationId');
    print('4. Fetch all: GET http://localhost:8000/notification/$userId');
  }

  /// Simulate the API calls to test connectivity (without actually making them)
  static Future<void> testNotificationApiCalls(
      String userId, String notificationId) async {
    print('=== Testing Notification API Calls ===');
    print('NOTE: These are simulated calls to test URL construction');
    print('');

    // Test mark as read
    try {
      print('🔄 Testing mark as read...');
      // final success = await NotificationService.markAsRead(userId, notificationId);
      print(
          '   URL: http://localhost:8000/notification/$userId/$notificationId/read');
      print('   Method: PATCH');
      print('   Headers: Content-Type: application/json');
    } catch (e) {
      print('   Error: $e');
    }

    // Test mark as unread
    try {
      print('🔄 Testing mark as unread...');
      print(
          '   URL: http://localhost:8000/notification/$userId/$notificationId/unread');
      print('   Method: PATCH');
      print('   Headers: Content-Type: application/json');
    } catch (e) {
      print('   Error: $e');
    }

    // Test delete
    try {
      print('🔄 Testing delete...');
      print(
          '   URL: http://localhost:8000/notification/$userId/$notificationId');
      print('   Method: DELETE');
      print('   Headers: Content-Type: application/json');
    } catch (e) {
      print('   Error: $e');
    }
  }
}
