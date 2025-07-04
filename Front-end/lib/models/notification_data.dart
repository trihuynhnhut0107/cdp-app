class NotificationData {
  final String userId;
  final String notificationId;
  final bool isRead;
  final DateTime createdAt;
  final DateTime updatedAt;
  final NotificationContent notification;

  NotificationData({
    required this.userId,
    required this.notificationId,
    required this.isRead,
    required this.createdAt,
    required this.updatedAt,
    required this.notification,
  });

  factory NotificationData.fromJson(Map<String, dynamic> json) {
    // Debug the raw JSON data
    print('🔍 Parsing notification JSON:');
    print('  Raw user_id: "${json['user_id']}"');
    print('  Raw notification_id: "${json['notification_id']}"');
    print('  Raw is_read: ${json['is_read']}');
    print('  Raw createdAt: "${json['createdAt']}"');
    print('  Raw Notification: ${json['Notification']}');

    // Extract notification ID from the nested Notification object
    String notificationId = '';
    if (json['Notification'] != null && json['Notification']['id'] != null) {
      notificationId = json['Notification']['id'];
      print('✅ Found notification ID in Notification.id: "$notificationId"');
    } else if (json['notification_id'] != null) {
      notificationId = json['notification_id'];
      print('✅ Found notification ID in notification_id: "$notificationId"');
    } else {
      print('❌ WARNING: No notification ID found in either location');
    }

    if (notificationId.isEmpty) {
      print('⚠️  WARNING: notification_id is empty in JSON response');
    }

    // Extract user_id (fallback to empty string if not provided)
    String userId = json['user_id'] ?? '';
    if (userId.isEmpty) {
      print('⚠️  INFO: user_id not provided in API response');
    }

    return NotificationData(
      userId: userId,
      notificationId: notificationId,
      isRead: json['is_read'] ?? false,
      createdAt:
          DateTime.parse(json['createdAt'] ?? DateTime.now().toIso8601String()),
      updatedAt:
          DateTime.parse(json['updatedAt'] ?? DateTime.now().toIso8601String()),
      notification: NotificationContent.fromJson(json['Notification'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'user_id': userId,
      'notification_id': notificationId,
      'is_read': isRead,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'Notification': notification.toJson(),
    };
  }
}

class NotificationContent {
  final String title;
  final String message;
  final String type;
  final String? surveyId; // Optional survey ID for survey-related notifications

  NotificationContent({
    required this.title,
    required this.message,
    required this.type,
    this.surveyId,
  });

  factory NotificationContent.fromJson(Map<String, dynamic> json) {
    return NotificationContent(
      title: json['title'] ?? '',
      message: json['message'] ?? '',
      type: json['type'] ?? 'info',
      surveyId: json['survey_id'], // Parse survey_id if present
    );
  }

  Map<String, dynamic> toJson() {
    final map = {
      'title': title,
      'message': message,
      'type': type,
    };
    if (surveyId != null) {
      map['survey_id'] = surveyId!;
    }
    return map;
  }
}

class NotificationResponse {
  final String message;
  final int status;
  final List<NotificationData> notifications;

  NotificationResponse({
    required this.message,
    required this.status,
    required this.notifications,
  });

  factory NotificationResponse.fromJson(Map<String, dynamic> json) {
    List<NotificationData> notificationList = [];

    // Handle the 'metadata' field which contains the notifications array
    if (json['metadata'] != null && json['metadata'] is List) {
      notificationList = (json['metadata'] as List)
          .map((notif) => NotificationData.fromJson(notif))
          .toList();
    }

    return NotificationResponse(
      message: json['message'] ?? '',
      status: json['status'] ?? 200,
      notifications: notificationList,
    );
  }
}
