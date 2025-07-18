import 'package:cdp_app/pages/survey_result_page.dart';
import 'package:cdp_app/pages/main_screen.dart';
import 'package:flutter/material.dart';
import 'package:cdp_app/color_palette.dart';

class SurveyCompletionScreen extends StatelessWidget {
  final String surveyId;
  const SurveyCompletionScreen({super.key, required this.surveyId});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(color: backgroundColor),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.celebration,
                  size: 80, color: colorScheme.primary), // Celebration Icon
              SizedBox(height: 20),
              Text(
                "🎉 Thank You! 🎉",
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: colorScheme.primary,
                ),
              ),
              SizedBox(height: 10),
              Text(
                "Your feedback helps us improve!",
                style: TextStyle(fontSize: 18, color: colorScheme.primary),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 30),
              ElevatedButton.icon(
                onPressed: () {
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => MainScreen()),
                    (Route<dynamic> route) =>
                        false, // Remove all previous routes
                  );
                },
                icon: Icon(
                  Icons.home,
                  color: textPrimary,
                ),
                label: Text("Return to Home"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: colorScheme.primary,
                  foregroundColor: textPrimary,
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                ),
              ),
              SizedBox(
                height: 16,
              ),
              ElevatedButton.icon(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              SurveyResultPage(surveyId: surveyId)));
                },
                icon: Icon(
                  Icons.bar_chart_rounded,
                  color: textPrimary,
                ),
                label: Text("Review the result"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: colorScheme.primary,
                  foregroundColor: textPrimary,
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
