// Test your exact API response structure
import 'package:cdp_app/models/notification_data.dart';

void testApiResponse() {
  // Updated API response to match actual server response structure
  final testResponse = {
    "message": "User notifications fetched successfully",
    "status": 200,
    "metadata": [
      {
        "is_read": false,
        "createdAt": "2025-06-29T16:25:50.584Z",
        "updatedAt": "2025-06-29T16:25:50.584Z",
        "Notification": {
          "id": "6ebd2430-ce09-44b1-b5d0-e946e7aadbe7",
          "title": "New survey!",
          "message": "Default is now available!",
          "type": "survey",
          "survey_id": "74d40cc3-1d4e-4505-8ad1-2a83957ce8fb",
          "createdAt": "2025-06-29T16:25:50.580Z"
        }
      },
      {
        "is_read": true,
        "createdAt": "2025-06-29T15:15:20.123Z",
        "updatedAt": "2025-06-29T16:30:15.456Z",
        "Notification": {
          "id": "abc123-def4-5678-90ab-cdef12345678",
          "title": "System Update",
          "message": "The system has been updated with new features.",
          "type": "info",
          "createdAt": "2025-06-29T15:15:20.120Z"
        }
      }
    ]
  };

  print('=== Testing Expected API Response ===');
  final metadata = testResponse['metadata'] as List;
  final firstNotification = metadata[0] as Map<String, dynamic>;

  print('Expected notification_id: "${firstNotification['notification_id']}"');
  print('Expected user_id: "${firstNotification['user_id']}"');

  // Test parsing
  try {
    final parsed = NotificationData.fromJson(firstNotification);
    print('Parsed notification_id: "${parsed.notificationId}"');
    print('Parsed user_id: "${parsed.userId}"');
  } catch (e) {
    print('Error parsing: $e');
  }
}
