import 'package:cdp_app/providers/notification_provider.dart'
    as notification_provider;
import 'package:socket_io_client/socket_io_client.dart' as io;

class SocketService {
  late io.Socket socket;
  final notification_provider.NotificationProvider notificationProvider;

  SocketService({required this.notificationProvider});

  void initSocket(String userId) {
    socket = io.io(
      'http://10.0.2.2:8000',
      io.OptionBuilder()
          .setTransports(['websocket'])
          .enableAutoConnect()
          .setQuery({'userId': userId})
          .build(),
    );

    socket.onConnect((_) {
      print("Connected to Socket.io");
      print("Socket ID: ${socket.id}");
    });

    // Listen to all events for debugging
    socket.onAny((event, data) {
      print("Received any event: $event with data: $data");
    });

    socket.on("notification", (data) async {
      print("Received notification event: $data");
      try {
        final title = data['title'] ?? 'No Title';
        final message = data['message'] ?? 'No Message';
        print("Showing notification: Title='$title', Message='$message'");
        await notificationProvider.showSimpleNotification(
          title: title,
          body: message,
        );
        print("Notification shown successfully");
      } catch (e) {
        print('Error showing notification: $e');
      }
    });

    socket.onDisconnect((_) => print("Disconnected from Socket.io"));
  }

  void dispose() {
    socket.dispose();
  }

  /// Check if socket is currently connected
  bool get isConnected => socket.connected;

  /// Get current socket connection status
  String get connectionStatus {
    if (socket.connected) {
      return 'Connected';
    } else if (socket.disconnected) {
      return 'Disconnected';
    } else {
      return 'Connecting';
    }
  }

  /// Reconnect socket if disconnected
  void reconnect() {
    if (socket.disconnected) {
      socket.connect();
      print("Attempting to reconnect socket...");
    }
  }

  /// Disconnect socket safely
  void disconnect() {
    if (socket.connected) {
      socket.disconnect();
      print("Socket disconnected");
    }
  }

  /// Force reconnection with new user ID (useful for session restoration)
  void forceReconnect(String userId) {
    // Disconnect existing connection
    if (socket.connected) {
      socket.disconnect();
    }

    // Dispose of the old socket
    socket.dispose();

    // Initialize new socket connection
    initSocket(userId);
    print("Socket force reconnected for user: $userId");
  }
}
