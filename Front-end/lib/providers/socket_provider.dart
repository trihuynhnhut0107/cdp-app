import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cdp_app/services/socket_service.dart';
import 'package:cdp_app/providers/notification_provider.dart';

final socketServiceProvider = Provider<SocketService>((ref) {
  final notifProvider = ref.read(notificationProvider);
  return SocketService(notificationProvider: notifProvider);
});
