import 'package:cdp_app/pages/home_page.dart';
import 'package:cdp_app/pages/main_screen.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Access the global color scheme
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          width: double.infinity,
          height:
              MediaQuery.of(context).size.height, // Ensure full screen height
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Colors.cyanAccent, // Gradient Start
                colorScheme.primary, // Gradient End
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              // Logo and Title Section
              Column(
                children: [
                  Center(
                    child: Icon(
                      Icons.flutter_dash_outlined,
                      size: 120,
                      color: colorScheme.onPrimary, // Use onPrimary color
                    ),
                  ),
                  SizedBox(height: 16),
                  Center(
                    child: Text(
                      "Login Page",
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: colorScheme.onPrimary, // Use onPrimary color
                      ),
                    ),
                  ),
                ],
              ),

              // Input Fields Section
              Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 32.0),
                    child: Column(
                      children: [
                        TextField(
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: colorScheme.surface, // Use surface color
                            hintText: 'Username',
                            hintStyle: TextStyle(color: colorScheme.onSurface),
                            contentPadding: EdgeInsets.symmetric(
                                vertical: 16.0, horizontal: 20.0),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30.0),
                              borderSide: BorderSide.none,
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30.0),
                              borderSide: BorderSide(
                                  color: colorScheme.primary, width: 2.0),
                            ),
                          ),
                        ),
                        SizedBox(height: 16),
                        TextField(
                          obscureText: true,
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: colorScheme.surface, // Use surface color
                            hintText: 'Password',
                            hintStyle: TextStyle(color: colorScheme.onSurface),
                            contentPadding: EdgeInsets.symmetric(
                                vertical: 16.0, horizontal: 20.0),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30.0),
                              borderSide: BorderSide.none,
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30.0),
                              borderSide: BorderSide(
                                  color: colorScheme.primary, width: 2.0),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(builder: (context) => MainScreen()),
                        (Route<dynamic> route) =>
                            false, // Remove all previous routes
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: colorScheme.primary,
                      foregroundColor: colorScheme.onSecondary,
                      padding: EdgeInsets.symmetric(
                          vertical: 16.0, horizontal: 32.0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30.0),
                      ),
                      elevation: 5,
                    ),
                    child: Text(
                      "Submit",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),

              // Spacer Section (Adjusted to maintain spacing)
              SizedBox(height: MediaQuery.of(context).size.height * (2 / 9)),
            ],
          ),
        ),
      ),
    );
  }
}
