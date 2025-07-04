import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cdp_app/providers/user_provider.dart';
import 'package:cdp_app/providers/socket_provider.dart';
import 'package:cdp_app/pages/login_page.dart';

class AuthMiddleware {
  static const Duration _sessionTimeout =
      Duration(hours: 24); // 24 hour session timeout

  static void checkAuthenticationOnResume(
    BuildContext context,
    WidgetRef ref,
  ) {
    // Check if user session is still valid
    final userId = ref.read(userIdProvider);
    final sessionTimestamp = ref.read(sessionTimestampProvider);

    if (userId == null) {
      // User session is lost, redirect to login
      _redirectToLogin(context, ref);
      return;
    }

    // Check if session has expired
    if (sessionTimestamp != null && _isSessionExpired(sessionTimestamp)) {
      // Session expired, clear it and redirect to login
      clearUserSession(ref);
      _redirectToLogin(context, ref);
      return;
    }

    // Update session timestamp to extend the session
    ref.read(sessionTimestampProvider.notifier).state = DateTime.now();

    // Re-establish socket connection if user session is valid
    _reconnectSocket(ref, userId);
  }

  /// Re-establish socket connection when app resumes from background
  static void _reconnectSocket(WidgetRef ref, String userId) {
    try {
      final socketService = ref.read(socketServiceProvider);

      // Check if socket is already connected
      if (socketService.isConnected) {
        print("Socket already connected for user: $userId");
        return;
      }

      // Force reconnection to ensure fresh connection with current user ID
      socketService.forceReconnect(userId);
      print("Socket reconnected for user: $userId");
    } catch (e) {
      print("Failed to reconnect socket: $e");
      // Socket reconnection failure is not critical for app functionality
      // Log the error but don't disrupt the user experience
    }
  }

  static bool _isSessionExpired(DateTime sessionTimestamp) {
    final now = DateTime.now();
    final difference = now.difference(sessionTimestamp);
    return difference > _sessionTimeout;
  }

  static void _redirectToLogin(BuildContext context, WidgetRef ref) {
    // Disconnect socket before redirecting
    _disconnectSocket(ref);

    // Show a snackbar to inform the user
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Session expired. Please log in again.'),
        duration: Duration(seconds: 3),
      ),
    );

    // Clear the navigation stack and go to login page
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (context) => const LoginPage()),
      (Route<dynamic> route) => false,
    );
  }

  /// Check if authentication is required for a specific route
  static bool requiresAuthentication(String routeName) {
    const publicRoutes = ['/login', '/signup', '/landing'];
    return !publicRoutes.contains(routeName);
  }

  /// Enhanced session validation with additional security checks
  static Future<bool> validateSession(WidgetRef ref) async {
    final userId = ref.read(userIdProvider);
    final sessionTimestamp = ref.read(sessionTimestampProvider);

    if (userId == null || sessionTimestamp == null) {
      return false;
    }

    // Check if session has expired
    if (_isSessionExpired(sessionTimestamp)) {
      clearUserSession(ref);
      return false;
    }

    // You can add additional validation here:
    // - Check token expiration
    // - Verify with backend
    // - Check biometric authentication

    return true;
  }

  /// Force logout and redirect to login screen
  static void forceLogout(BuildContext context, WidgetRef ref,
      {String? reason}) {
    // Disconnect socket before clearing session
    _disconnectSocket(ref);

    clearUserSession(ref);

    if (reason != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(reason),
          duration: const Duration(seconds: 3),
        ),
      );
    }

    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (context) => const LoginPage()),
      (Route<dynamic> route) => false,
    );
  }

  /// Disconnect socket connection when logging out
  static void _disconnectSocket(WidgetRef ref) {
    try {
      final socketService = ref.read(socketServiceProvider);
      socketService.disconnect();
      print("Socket disconnected during logout");
    } catch (e) {
      print("Failed to disconnect socket: $e");
    }
  }
}
