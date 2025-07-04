import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cdp_app/middleware/auth_middleware.dart';
import 'package:cdp_app/providers/user_provider.dart';

/// A wrapper widget that checks authentication before showing content
class AuthGuard extends ConsumerWidget {
  final Widget child;
  final Widget? fallback;

  const AuthGuard({
    super.key,
    required this.child,
    this.fallback,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isLoggedIn = ref.watch(isUserLoggedInProvider);

    if (!isLoggedIn) {
      // Return fallback or trigger navigation to login
      WidgetsBinding.instance.addPostFrameCallback((_) {
        AuthMiddleware.forceLogout(context, ref,
            reason: 'Please log in to access this feature');
      });

      return fallback ??
          const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
    }

    return child;
  }
}

/// Extension to add authentication protection to any route
extension AuthenticatedRoute on Widget {
  Widget requireAuth({Widget? fallback}) {
    return AuthGuard(
      fallback: fallback,
      child: this,
    );
  }
}

/// Example usage in your navigation:
/// Navigator.push(
///   context,
///   MaterialPageRoute(
///     builder: (context) => SurveyPage(uuid: surveyId).requireAuth(),
///   ),
/// );
