import 'package:cdp_app/providers/notification_provider.dart'
    as notification_provider;
import 'package:socket_io_client/socket_io_client.dart' as io;

class SocketService {
  late io.Socket socket;

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
    });

    socket.on("notification", (data) {
      notification_provider.NotificationProvider()
          .showSimpleNotification(title: data['title'], body: data['message']);
    });

    socket.onDisconnect((_) => print("Disconnected from Socket.io"));
  }

  void dispose() {
    socket.dispose();
  }
}
