import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cdp_app/models/user_model.dart';
import 'package:cdp_app/services/user_service.dart';

/// Holds the current logged-in user's ID (null if not logged in)
final userIdProvider = StateProvider<String?>((ref) => null);

/// Session timestamp provider to track when user logged in
final sessionTimestampProvider = StateProvider<DateTime?>((ref) => null);

/// Provider to check if user session is active
final isUserLoggedInProvider = Provider<bool>((ref) {
  final userId = ref.watch(userIdProvider);
  return userId != null;
});

/// Provider for user data
final userDataProvider = StateProvider<UserModel?>((ref) => null);

/// Provider that fetches user data when user ID changes
final userDataFutureProvider = FutureProvider<UserModel?>((ref) async {
  final userId = ref.watch(userIdProvider);
  if (userId == null) return null;

  final userData = await UserService.getUserById(userId);
  if (userData != null) {
    // Update the user data state provider
    ref.read(userDataProvider.notifier).state = userData;
  }
  return userData;
});

/// Clear user session (logout)
void clearUserSession(WidgetRef ref) {
  ref.read(userIdProvider.notifier).state = null;
  ref.read(sessionTimestampProvider.notifier).state = null;
  ref.read(userDataProvider.notifier).state = null;
}

/// Set user session (login)
void setUserSession(WidgetRef ref, String userId) {
  ref.read(userIdProvider.notifier).state = userId;
  ref.read(sessionTimestampProvider.notifier).state = DateTime.now();
}
