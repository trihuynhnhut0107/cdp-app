# Authentication Middleware Implementation with Socket Reconnection

This implementation adds robust authentication middleware to your Flutter app that automatically redirects users to the login screen when:

1. The app returns from background and the user session is lost
2. The session has expired (24-hour timeout by default)
3. The user_id is no longer available in the provider

**🆕 Socket Reconnection**: When the app returns from background and the user session is valid, the middleware automatically re-establishes the socket connection to ensure real-time functionality continues seamlessly.

## Files Added/Modified

### 1. `lib/middleware/auth_middleware.dart`

Contains the core authentication logic with methods for:

- `checkAuthenticationOnResume()` - Called when app resumes from background
- `_reconnectSocket()` - **NEW**: Re-establishes socket connection for valid sessions
- `_disconnectSocket()` - **NEW**: Safely disconnects socket during logout
- `validateSession()` - Validates current session status
- `forceLogout()` - Forces logout with socket cleanup and optional reason
- Session timeout management (24 hours by default)

### 2. `lib/services/socket_service.dart` (Enhanced)

Added new methods for better socket management:

- `isConnected` - Boolean getter for connection status
- `connectionStatus` - String getter for detailed status
- `reconnect()` - Reconnect if disconnected
- `disconnect()` - Safe disconnect method
- `forceReconnect()` - Force reconnection with new user ID

### 3. `lib/providers/user_provider.dart` (Enhanced)

Added additional providers:

- `sessionTimestampProvider` - Tracks when user logged in
- `isUserLoggedInProvider` - Boolean check for login status
- `setUserSession()` - Helper to set user session with timestamp
- `clearUserSession()` - Helper to clear user session completely

### 4. `lib/main.dart` (Modified)

- Changed `MyApp` from `StatelessWidget` to `ConsumerStatefulWidget`
- Added `WidgetsBindingObserver` to monitor app lifecycle
- Automatically checks authentication and reconnects socket when app resumes from background

### 5. `lib/widgets/auth_guard.dart` (Optional)

Provides a reusable widget to protect routes that require authentication

### 6. `lib/pages/auth_test_page.dart` (Test/Debug)

Enhanced test page showing:

- User session status
- **Socket connection status** (Connected/Disconnected)
- Test buttons for socket reconnection scenarios

## How It Works

1. **App Lifecycle Monitoring**: The main app widget monitors `AppLifecycleState.resumed` events
2. **Session Validation**: When the app resumes, it checks if the user session is still valid
3. **Socket Reconnection**: If session is valid, automatically re-establishes socket connection
4. **Automatic Redirect**: If session is invalid/expired, user is redirected to login screen with socket cleanup
5. **Session Extension**: Valid sessions are automatically extended on app resume

## Socket Reconnection Flow

```
App Resumes from Background
         ↓
Check User Session Valid?
         ↓
    [Valid] ───→ Check Socket Connected?
         ↓                ↓
    [Invalid]        [Connected] ───→ Continue
         ↓                ↓
   Redirect to      [Disconnected]
   Login Screen           ↓
         ↓           Force Reconnect
   Disconnect           Socket
    Socket               ↓
                    Continue with
                   Fresh Connection
```

## Configuration

### Session Timeout

You can modify the session timeout in `auth_middleware.dart`:

```dart
static const Duration _sessionTimeout = Duration(hours: 24); // Change as needed
```

### Socket Connection Settings

The socket service automatically uses the user ID for reconnection. You can modify connection parameters in `socket_service.dart`:

```dart
socket = io.io(
  'http://10.0.2.2:8000', // Your server URL
  io.OptionBuilder()
      .setTransports(['websocket'])
      .enableAutoConnect()
      .setQuery({'userId': userId})
      .build(),
);
```

### Public Routes

Add routes that don't require authentication:

```dart
static bool requiresAuthentication(String routeName) {
  const publicRoutes = ['/login', '/signup', '/landing'];
  return !publicRoutes.contains(routeName);
}
```

## Usage Examples

### Basic Protection (Automatic)

The middleware automatically protects your app when returning from background. No additional code needed.

### Manual Session Check

```dart
// Check if session is valid before performing sensitive operations
final isValid = await AuthMiddleware.validateSession(ref);
if (!isValid) {
  // Handle invalid session
  AuthMiddleware.forceLogout(context, ref, reason: 'Session expired');
}
```

### Protecting Individual Routes

```dart
// Using the AuthGuard widget
Navigator.push(
  context,
  MaterialPageRoute(
    builder: (context) => AuthGuard(
      child: SurveyPage(uuid: surveyId),
    ),
  ),
);

// Or using the extension method
Navigator.push(
  context,
  MaterialPageRoute(
    builder: (context) => SurveyPage(uuid: surveyId).requireAuth(),
  ),
);
```

### Manual Logout

```dart
// Force logout with custom reason
AuthMiddleware.forceLogout(context, ref,
  reason: 'Security policy requires re-authentication');
```

## Additional Security Enhancements

You can enhance the middleware further by:

1. **Server-side Session Validation**: Add API calls to verify session validity
2. **Biometric Authentication**: Require biometric verification on app resume
3. **Device Fingerprinting**: Detect if app is running on a different device
4. **Background Time Tracking**: Track how long app was in background

### Example Server Validation

```dart
static Future<bool> validateSessionWithServer(String userId) async {
  try {
    final response = await http.get(
      Uri.parse('$baseUrl/auth/validate'),
      headers: {'Authorization': 'Bearer $token'},
    );
    return response.statusCode == 200;
  } catch (e) {
    return false;
  }
}
```

## Testing

To test the middleware:

1. **Background Test**:

   - Open the app and log in
   - Put app in background (home button)
   - Manually clear the userIdProvider (simulate session loss)
   - Return to app - should redirect to login

2. **Session Timeout Test**:

   - Modify session timeout to a short duration (e.g., 30 seconds)
   - Log in and wait for timeout
   - Put app in background and return - should redirect to login

3. **Normal Flow Test**:
   - Log in normally
   - Put app in background and return quickly
   - Should remain logged in with extended session

## Testing Socket Reconnection

To test the socket reconnection functionality:

1. **Normal Reconnection Test**:

   - Log in to the app
   - Put app in background (home button)
   - Return to app - socket should automatically reconnect
   - Check the test page to see socket status

2. **Session Loss with Socket Cleanup Test**:

   - Log in to the app
   - Use the test page to simulate session loss
   - Put app in background and return
   - Should redirect to login and disconnect socket

3. **Manual Socket Test**:
   - Use the test page "Disconnect Socket" button
   - Use "Test Socket Reconnection" button
   - Observe socket status changes in real-time

### Test Page Usage

The `AuthMiddlewareTestPage` provides real-time monitoring:

```dart
// Navigate to test page (for debugging)
Navigator.push(
  context,
  MaterialPageRoute(builder: (context) => AuthMiddlewareTestPage()),
);
```

**Test buttons available**:

- **Simulate Session Loss**: Clears user ID to test redirect
- **Simulate Expired Session**: Sets old timestamp to test timeout
- **Test Socket Reconnection**: Manually triggers auth check and socket reconnection
- **Disconnect Socket**: Manually disconnects socket for testing
- **Validate Session**: Checks current session validity

## Benefits of Socket Reconnection

1. **Seamless Real-time Experience**: Users don't miss notifications when returning to app
2. **Automatic Recovery**: No manual intervention needed for socket reconnection
3. **Resource Efficient**: Only reconnects when necessary (user session is valid)
4. **Error Resilient**: Socket connection failures don't crash the app
5. **Clean Logout**: Sockets are properly disconnected during logout/session expiry

## Security Considerations

The socket reconnection feature enhances security by:

1. **Session Validation**: Only reconnects sockets for valid user sessions
2. **Clean Disconnection**: Ensures sockets are disconnected during logout
3. **Fresh Connections**: Uses `forceReconnect()` to establish fresh connections
4. **Error Handling**: Gracefully handles socket connection failures

## Advanced Usage

### Custom Socket Validation

You can add additional socket validation before reconnection:

```dart
static void _reconnectSocket(WidgetRef ref, String userId) {
  try {
    final socketService = ref.read(socketServiceProvider);

    // Custom validation before reconnection
    if (!_shouldReconnectSocket(userId)) {
      return;
    }

    if (socketService.isConnected) {
      print("Socket already connected for user: $userId");
      return;
    }

    socketService.forceReconnect(userId);
  } catch (e) {
    print("Failed to reconnect socket: $e");
  }
}
```

### Server-Side Socket Validation

You can enhance security by validating socket connections server-side:

```dart
// In your socket service initialization
socket.on('connect', (_) {
  // Send authentication token to server for validation
  socket.emit('authenticate', {'token': userToken});
});

socket.on('authentication_failed', (_) {
  // Handle authentication failure
  AuthMiddleware.forceLogout(context, ref,
    reason: 'Socket authentication failed');
});
```
