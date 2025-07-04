# Notification System Documentation

## API Integration

The notification system is now properly configured to work with your API endpoint `http://localhost:8000/notification/:id`.

### API Response Structure

Your API returns notifications in this format:

```json
{
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
}
```

### Features Implemented

1. **Notification Fetching**: Automatically fetches notifications from your API when the page loads
2. **Read/Unread Status**:
   - Visual indicators for read vs unread notifications
   - Unread notifications are sorted to the top
   - Badge on main screen shows unread count
3. **Interactive Actions**:
   - Tap notification to toggle read/unread status
   - Menu actions for mark as read/unread and delete
   - Mark all as read functionality
   - Pull-to-refresh
4. **Visual Design**:
   - Different styling for read vs unread notifications
   - Color-coded notification types (survey, alert, info, warning)
   - Loading states and error handling
   - Time ago formatting

### Notification States

- **Unread**: Bold text, colored border, colored indicator dot
- **Read**: Normal text, grey indicator with checkmark
- **Types**: Color-coded badges (survey=blue, alert=red, info=green, warning=orange)

### API Endpoints Expected

The notification service expects these endpoints to be available:

1. `GET /notification/:userId` - Fetch notifications
2. `PATCH /notification/:userId/:notificationId/read` - Mark as read
3. `PATCH /notification/:userId/:notificationId/unread` - Mark as unread
4. `DELETE /notification/:userId/:notificationId` - Delete notification
5. `PATCH /notification/:userId/read-all` - Mark all as read (optional)

### Data Models

The app uses these data models that map to your API structure:

- `NotificationData`: Main notification object
- `NotificationContent`: Nested notification content (title, message, type)
- `NotificationResponse`: API response wrapper

### Usage

1. Navigate to the notification page
2. Notifications are automatically fetched and sorted (unread first, then by date)
3. Tap any notification to toggle its read status
4. Use the three-dot menu for additional actions
5. Pull down to refresh notifications
6. Use "Mark all read" button to mark all as read at once

### Error Handling

- Network errors are displayed with retry options
- Failed API calls show toast messages
- Loading states are shown during operations
- Graceful handling of malformed API responses

### Testing

You can test the notification parsing using the test data in `lib/utils/notification_test_data.dart` which contains sample data matching your API structure.
