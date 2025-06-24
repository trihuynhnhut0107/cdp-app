import 'package:cdp_app/color_palette.dart';
import 'package:cdp_app/pages/landing_page.dart';
import 'package:provider/provider.dart' as provider;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cdp_app/providers/notification_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final notificationProvider = NotificationProvider();
  await notificationProvider.initNotifications();

  runApp(
    ProviderScope(
      child: provider.MultiProvider(
        providers: [
          provider.ChangeNotifierProvider(create: (_) => notificationProvider),
        ],
        child: MyApp(),
      ),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          colorScheme: ColorScheme(
            brightness: Brightness.light,

            // Primary Colors
            primary: primaryBase, // 60% - Main Cyan
            onPrimary: textPrimary, // Text on Primary
            primaryContainer: primaryLight, // Light Cyan Variant
            onPrimaryContainer: textPrimary, // Text on Primary Container

            // Secondary Colors
            secondary: analogousBlue, // 30% - Supporting Color
            onSecondary: Colors.white, // Text on Secondary
            secondaryContainer: surfaceColor, // Soft Muted Surface
            onSecondaryContainer: textSecondary, // Text on Secondary Container

            // Surface and Background
            surface: backgroundColor, // Very Light Cyan Background
            onSurface: textPrimary, // Primary Text
            surfaceContainerHighest: surfaceColor, // Soft Surface Variant
            onSurfaceVariant: textSecondary, // Secondary Text

            // Accent and Error
            error: accentColor, // Soft Red for Errors
            onError: Colors.white, // Text on Error

            // Additional Utilities
            outline: analogousGreen, // Outline/Border Color
            shadow: shadowColor, // Shadow Color
          ),
          useMaterial3: true,
        ),
        home: LandingPage());
  }
}
