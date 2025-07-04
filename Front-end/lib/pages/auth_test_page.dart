import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cdp_app/providers/user_provider.dart';
import 'package:cdp_app/providers/socket_provider.dart';
import 'package:cdp_app/middleware/auth_middleware.dart';

/// Example widget demonstrating how to test the authentication middleware
class AuthMiddlewareTestPage extends ConsumerWidget {
  const AuthMiddlewareTestPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isLoggedIn = ref.watch(isUserLoggedInProvider);
    final userId = ref.watch(userIdProvider);
    final sessionTimestamp = ref.watch(sessionTimestampProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Auth Middleware Test'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Authentication Status:',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 16),

            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          isLoggedIn ? Icons.check_circle : Icons.cancel,
                          color: isLoggedIn ? Colors.green : Colors.red,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          isLoggedIn ? 'Logged In' : 'Not Logged In',
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text('User ID: ${userId ?? "None"}'),
                    Text(
                        'Session Started: ${sessionTimestamp?.toString() ?? "None"}'),
                    if (sessionTimestamp != null)
                      Text(
                        'Session Age: ${DateTime.now().difference(sessionTimestamp).inMinutes} minutes',
                      ),

                    // Socket connection status
                    const SizedBox(height: 8),
                    Builder(
                      builder: (context) {
                        try {
                          final socketService = ref.read(socketServiceProvider);
                          final isSocketConnected = socketService.isConnected;
                          return Row(
                            children: [
                              Icon(
                                isSocketConnected ? Icons.wifi : Icons.wifi_off,
                                color: isSocketConnected
                                    ? Colors.green
                                    : Colors.red,
                                size: 16,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                'Socket: ${socketService.connectionStatus}',
                                style: TextStyle(
                                  color: isSocketConnected
                                      ? Colors.green
                                      : Colors.red,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          );
                        } catch (e) {
                          return const Text('Socket: Error reading status');
                        }
                      },
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24),

            Text(
              'Test Actions:',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 16),

            // Test buttons
            ElevatedButton(
              onPressed: () {
                // Simulate session loss
                ref.read(userIdProvider.notifier).state = null;
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Simulated session loss')),
                );
              },
              child: const Text('Simulate Session Loss'),
            ),

            const SizedBox(height: 8),

            ElevatedButton(
              onPressed: () {
                // Simulate expired session
                ref.read(sessionTimestampProvider.notifier).state =
                    DateTime.now().subtract(const Duration(days: 2));
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Simulated expired session')),
                );
              },
              child: const Text('Simulate Expired Session'),
            ),

            const SizedBox(height: 8),

            ElevatedButton(
              onPressed: () async {
                final isValid = await AuthMiddleware.validateSession(ref);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      isValid ? 'Session is valid' : 'Session is invalid',
                    ),
                  ),
                );
              },
              child: const Text('Validate Session'),
            ),

            const SizedBox(height: 8),

            ElevatedButton(
              onPressed: () {
                AuthMiddleware.forceLogout(
                  context,
                  ref,
                  reason: 'Manual logout test',
                );
              },
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              child: const Text('Force Logout'),
            ),

            const SizedBox(height: 8),

            ElevatedButton(
              onPressed: () {
                // Test socket reconnection
                final userId = ref.read(userIdProvider);
                if (userId != null) {
                  AuthMiddleware.checkAuthenticationOnResume(context, ref);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content: Text(
                            'Simulated app resume - checking auth and reconnecting socket')),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content: Text('No user session to reconnect')),
                  );
                }
              },
              child: const Text('Test Socket Reconnection'),
            ),

            const SizedBox(height: 8),

            ElevatedButton(
              onPressed: () {
                // Manual socket disconnect test
                try {
                  final socketService = ref.read(socketServiceProvider);
                  socketService.disconnect();
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content: Text('Socket manually disconnected')),
                  );
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Error disconnecting socket: $e')),
                  );
                }
              },
              child: const Text('Disconnect Socket'),
            ),

            const SizedBox(height: 24),

            const Card(
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'How to Test:',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 8),
                    Text('1. Log in normally to establish a session'),
                    Text('2. Use "Simulate Session Loss" button'),
                    Text('3. Put the app in background (home button)'),
                    Text('4. Return to the app - should redirect to login'),
                    SizedBox(height: 8),
                    Text('Alternative:'),
                    Text('1. Use "Simulate Expired Session" button'),
                    Text('2. Put app in background and return'),
                    Text('3. Should redirect to login with timeout message'),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
