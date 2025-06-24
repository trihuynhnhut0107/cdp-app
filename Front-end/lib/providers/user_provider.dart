import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Holds the current logged-in user's ID (null if not logged in)
final userIdProvider = StateProvider<String?>((ref) => null);
