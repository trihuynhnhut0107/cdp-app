import 'package:cdp_app/pages/main_screen.dart';
import 'package:cdp_app/pages/signup_page.dart';
import 'package:cdp_app/providers/socket_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cdp_app/providers/user_provider.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

Future<String> loadSvgAsString() async {
  return await rootBundle.loadString('assets/icons/logo.svg');
}

class LoginPage extends ConsumerWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;

    // email and password controllers
    final TextEditingController emailController = TextEditingController();
    final TextEditingController passwordController = TextEditingController();

    return Scaffold(
      backgroundColor: colorScheme.surface,
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Logo or App Icon
              // Icon(
              //   Icons.flutter_dash,
              //   size: 100,
              //   color: colorScheme.primary,
              // ),
              FutureBuilder<String>(
                future: loadSvgAsString(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    // Replace the colors in the SVG string
                    String svgString = snapshot.data!;
                    svgString = svgString.replaceAll(
                        '.background-color { color: #f5f5f5; }',
                        '.background-color { color: #FF0000; }' // Bright red for visibility
                        );

                    svgString = svgString.replaceAll(
                        '.item-color { color: #4285F4; }',
                        '.item-color { color: #00FF00; }' // Bright green for visibility
                        );

                    // Convert the modified string back to SvgPicture
                    return SizedBox(
                      height: 150,
                      width: 150,
                      child: SvgPicture.string(
                        svgString,
                        semanticsLabel: 'Survey App Logo',
                      ),
                    );
                  }
                  return const CircularProgressIndicator();
                },
              ),
              const SizedBox(height: 30),

              // Welcome Text
              Text(
                'Welcome Back',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: colorScheme.onSurface,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                'Login to continue',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 40),

              // email TextField
              TextField(
                controller: emailController,
                cursorColor: colorScheme.onPrimary,
                decoration: InputDecoration(
                  labelText: 'email',
                  labelStyle: TextStyle(
                      color: colorScheme.onPrimary), // Change label color
                  prefixIcon: Icon(Icons.person, color: colorScheme.onPrimary),
                  filled: true,
                  fillColor: colorScheme.surfaceContainerHighest,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(
                      color: colorScheme.onPrimary,
                      width: 2,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // Password TextField
              TextField(
                controller: passwordController,
                obscureText: true,
                cursorColor: colorScheme.onPrimary,
                decoration: InputDecoration(
                  labelText: 'Password',
                  labelStyle: TextStyle(
                      color: colorScheme.onPrimary), // Change label color
                  prefixIcon: Icon(Icons.lock, color: colorScheme.onPrimary),
                  suffixIcon: Icon(Icons.visibility_off,
                      color: colorScheme.onSurfaceVariant),
                  filled: true,
                  fillColor: colorScheme.secondaryContainer,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(
                      color: colorScheme.onPrimary,
                      width: 2,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 10),

              // Forgot Password
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () {
                    // Forgot password logic
                  },
                  child: Text(
                    'Forgot Password?',
                    style: TextStyle(color: colorScheme.onSurfaceVariant),
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Login Button
              ElevatedButton(
                onPressed: () async {
                  // Example login logic
                  final email = emailController.text.trim();
                  final password = passwordController.text.trim();
                  if (email.isEmpty || password.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                          content: Text('Please enter email and password')),
                    );
                    return;
                  }
                  try {
                    // Replace with your actual login API call
                    final response = await http.post(
                      Uri.parse('http://10.0.2.2:8000/authentication/login'),
                      headers: {'Content-Type': 'application/json'},
                      body: jsonEncode({'email': email, 'password': password}),
                    );
                    if (response.statusCode == 200) {
                      final data = jsonDecode(response.body);
                      final userId = data['metadata']?['user']?['id'];
                      if (userId != null) {
                        ref.read(userIdProvider.notifier).state = userId;
                        final socketService = ref.read(socketServiceProvider);
                        socketService
                            .initSocket(userId); // userId from user_provider
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(builder: (context) => MainScreen()),
                          (Route<dynamic> route) =>
                              false, // Remove all previous routes
                        );
                      } else {
                        throw Exception('User ID not found in response');
                      }
                    } else {
                      final error =
                          jsonDecode(response.body)['error'] ?? 'Login failed';
                      throw Exception(error);
                    }
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Login error: \\${e.toString()}')),
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: colorScheme.primary,
                  foregroundColor: colorScheme.onPrimary,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'Login',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 30),

              // Signup Option
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Don't have an account?",
                    style: TextStyle(color: colorScheme.onSurfaceVariant),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => SignupPage(),
                        ),
                      );
                    },
                    child: Text(
                      'Sign Up',
                      style: TextStyle(
                        color: colorScheme.primary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
