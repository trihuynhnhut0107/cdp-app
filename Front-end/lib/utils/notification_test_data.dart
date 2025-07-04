import 'package:cdp_app/models/notification_data.dart';

class NotificationTestData {
  /// Test data that matches your API response structure
  static Map<String, dynamic> get sampleApiResponse => {
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
          },
          {
            "user_id": "58211fc7-7a06-4444-a9f9-073dca0df119",
            "notification_id": "64c35fb0-eac7-4d25-925b-6791319d6571",
            "is_read": true,
            "createdAt": "2025-06-13T08:20:15.123Z",
            "updatedAt": "2025-06-14T09:15:30.456Z",
            "Notification": {
              "title": "Profile Updated",
              "message":
                  "Your profile information has been successfully updated.",
              "type": "info"
            }
          },
          {
            "user_id": "58211fc7-7a06-4444-a9f9-073dca0df119",
            "notification_id": "74c35fb0-eac7-4d25-925b-6791319d6572",
            "is_read": false,
            "createdAt": "2025-06-12T15:45:22.789Z",
            "updatedAt": "2025-06-12T15:45:22.789Z",
            "Notification": {
              "title": "System Alert",
              "message":
                  "Scheduled maintenance will occur tonight from 2-4 AM.",
              "type": "alert"
            }
          }
        ]
      };

  /// Parse the sample API response into NotificationData objects
  static List<NotificationData> get sampleNotifications {
    final response = NotificationResponse.fromJson(sampleApiResponse);
    return response.notifications;
  }

  /// Test the JSON parsing
  static bool testJsonParsing() {
    try {
      final notifications = sampleNotifications;

      print('✅ Successfully parsed ${notifications.length} notifications');

      for (final notification in notifications) {
        print(
            '📧 ${notification.notification.title} - ${notification.isRead ? "Read" : "Unread"}');
        print('   Type: ${notification.notification.type}');
        print('   Created: ${notification.createdAt}');
        print('   Message: ${notification.notification.message}');
        print('');
      }

      return true;
    } catch (e) {
      print('❌ Error parsing JSON: $e');
      return false;
    }
  }
}
