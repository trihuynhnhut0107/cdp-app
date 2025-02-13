// Import this for jsonEncode()
import 'dart:math';
import 'package:cdp_app/components/gradient_button.dart';
import 'package:cdp_app/pages/survey_completion_page.dart';
import 'package:cdp_app/survey_container.dart';
import 'package:flutter/material.dart';

class SurveyPage extends StatelessWidget {
  const SurveyPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text("Survey Screen")),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                "A quick survey about your habits.",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
            ),
            Container(
              child: Flexible(
                  fit: FlexFit.tight,
                  child: SurveyContainer(surveyList: surveyList)),
            ),
            Padding(
                padding: const EdgeInsets.all(16.0),
                child: GradientButton(
                  onPressed: () {
                    // // Convert the surveyList to a JSON string
                    // String surveyListString = jsonEncode(surveyList);

                    // // Show the surveyList in SnackBar
                    // ScaffoldMessenger.of(context).showSnackBar(
                    //   SnackBar(content: Text(surveyListString)),
                    // );
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => SurveyCompletionScreen()));
                  },
                  text: "Submit",
                )),
          ],
        ));
  }
}

List<Map<String, dynamic>> surveyList = [
  {
    'type': "selection",
    'question': "Please answer to the first question",
    'options': ["Answer 1", "Answer 2", "Answer 3"],
    'selection': -1,
  },
  {
    'type': "selection",
    'question': "Please answer to the second question",
    'options': ["Answer 1", "Answer 2", "Answer 3"],
    'selection': -1,
  },
  {
    'type': "multiple",
    'question': "This is a multiple selection question",
    'options': ["Answer 1", "Answer 2", "Answer 3", "Answer 4"],
    'selection': [],
  },
  {
    'type': "selection",
    'question': "Please answer to the third question",
    'options': ["Answer 1", "Answer 2", "Answer 3", "Answer 4"],
    'selection': -1,
  },
  {
    'type': "open",
    'question': "Type anything in here",
  },
];

Color getRandomColor() {
  final random = Random();
  return Color.fromRGBO(
    random.nextInt(256), // Red channel (0-255)
    random.nextInt(256), // Green channel (0-255)
    random.nextInt(256), // Blue channel (0-255)
    1.0, // Alpha channel (opacity, 1.0 is fully opaque)
  );
}
