import 'package:cdp_app/components/gradient_button.dart';
import 'package:cdp_app/pages/profile_page.dart';
import 'package:cdp_app/pages/survey_home_page.dart';
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(
        title: Text("Home Page"),
        backgroundColor: colorScheme.primary,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(
            horizontal: 20), // Adds spacing from edges
        child: Column(
          mainAxisAlignment:
              MainAxisAlignment.center, // Centers buttons vertically
          crossAxisAlignment:
              CrossAxisAlignment.stretch, // Makes buttons full width
          children: [
            GradientButton(
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => SurveyHomePage()));
              },
              text: "Survey",
            ),
            SizedBox(height: 15),
            GradientButton(
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => ProfilePage()));
              },
              text: "Profile",
            ),
            SizedBox(height: 15),
            GradientButton(
              onPressed: () {
                // Navigator.push(context,
                //     MaterialPageRoute(builder: (context) => SettingsPage()));
              },
              text: "Settings",
            ), // Adds spacing between buttons
          ],
        ),
      ),
    );
  }
}
