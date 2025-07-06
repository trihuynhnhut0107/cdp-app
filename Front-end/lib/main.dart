import 'package:cdp_app/color_palette.dart';
import 'package:cdp_app/pages/login_page.dart';
import 'package:cdp_app/middleware/auth_middleware.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(
    ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends ConsumerStatefulWidget {
  const MyApp({super.key});

  @override
  ConsumerState<MyApp> createState() => _MyAppState();
}

class _MyAppState extends ConsumerState<MyApp> with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);

    if (state == AppLifecycleState.resumed) {
      // App has come back from background, check authentication
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted && context.mounted) {
          AuthMiddleware.checkAuthenticationOnResume(context, ref);
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          colorScheme: ColorScheme(
            brightness: Brightness.light,

            // Primary Colors
            primary: primaryBase, // Sand Yellow
            onPrimary: textPrimary, // Text on Primary
            primaryContainer: primaryLight, // Light Sand Yellow
            onPrimaryContainer: textPrimary, // Text on Primary Container

            // Secondary Colors
            secondary: analogousGreen, // Soft Green - Supporting Color
            onSecondary: textPrimary, // Text on Secondary
            secondaryContainer: surfaceColor, // Soft Cream Surface
            onSecondaryContainer: textSecondary, // Text on Secondary Container

            // Surface and Background
            surface: backgroundColor, // Very Light Cream Background
            onSurface: textPrimary, // Primary Text
            surfaceContainerHighest: surfaceColor, // Soft Surface Variant
            onSurfaceVariant: textSecondary, // Secondary Text

            // Accent and Error
            error: accentColor, // Soft Red for Errors
            onError: backgroundColor, // Light background on Error

            // Additional Utilities
            outline: primaryDark, // Outline/Border Color (Deep Sand Yellow)
            shadow: shadowColor, // Shadow Color
          ),
          useMaterial3: true,
        ),
        home: LoginPage());
  }
}
