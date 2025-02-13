import 'package:cdp_app/pages/home_page.dart';
import 'package:cdp_app/pages/login_page.dart';
import 'package:flutter/material.dart';

class LandingPage extends StatelessWidget {
  const LandingPage({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Scaffold(
      backgroundColor: colorScheme.primary,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.flutter_dash_outlined,
              size: 150,
            ),
            const Text(
              "Welcome to our survey app!",
              style: TextStyle(
                fontSize: 25,
                fontFamily: 'Playfair',
                fontWeight: FontWeight.w700,
                fontStyle: FontStyle.normal,
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => LoginPage()));
              },
              child: const Text("Get started!"),
            ),
          ],
        ),
      ),
    );
  }
}
