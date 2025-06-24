import 'package:cdp_app/pages/login_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';

Future<String> loadSvgAsString() async {
  return await rootBundle.loadString('assets/icons/logo.svg');
}

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
            // Using FutureBuilder to load and modify the SVG
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
            const SizedBox(height: 40),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const LoginPage()),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: colorScheme.secondary,
                foregroundColor: colorScheme.onSecondary,
                padding:
                    const EdgeInsets.symmetric(horizontal: 40, vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              child: const Text(
                'Get Started',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Extension method to convert Color to hex string
// extension ColorExtension on Color {
//   String toHex() => '#${(value & 0xFFFFFF).toRadixString(16).padLeft(6, '0')}';
// }
