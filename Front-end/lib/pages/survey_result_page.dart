// Import this for jsonEncode()
import 'dart:math';
import 'package:flutter/material.dart';

class SurveyResultPage extends StatelessWidget {
  final List<Map<String, dynamic>> surveyList;

  const SurveyResultPage({super.key, required this.surveyList});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    // Default survey results for debugging
    final List<Map<String, dynamic>> defaultSurveyList = [
      {
        'type': "selection",
        'question': "Please answer to the first question",
        'options': ["Answer 1", "Answer 2", "Answer 3"],
        'selection': 1, // Assume user selects Answer 2
      },
      {
        'type': "selection",
        'question': "Please answer to the second question",
        'options': ["Answer 1", "Answer 2", "Answer 3"],
        'selection': 0, // Assume user selects Answer 1
      },
      {
        'type': "selection",
        'question': "Please answer to the third question",
        'options': ["Answer 1", "Answer 2", "Answer 3", "Answer 4"],
        'selection': 2, // Assume user selects Answer 3
      },
    ];

    // If surveyList is empty, use the default list for debugging
    final List<Map<String, dynamic>> finalSurveyList =
        surveyList.isNotEmpty ? surveyList : defaultSurveyList;

    return Scaffold(
      appBar: AppBar(title: Text("Survey Results")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView.builder(
          itemCount: finalSurveyList.length,
          itemBuilder: (context, index) {
            final surveyItem = finalSurveyList[index];
            return Card(
              color: colorScheme.primary,
              margin: EdgeInsets.symmetric(vertical: 8.0),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "${surveyItem['question']}",
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 8.0),
                    Text(
                      "Your Answer: ${surveyItem['selection'] == -1 ? 'No answer selected' : surveyItem['options'][surveyItem['selection']]}",
                      style: TextStyle(fontSize: 16),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

Color getRandomColor() {
  final random = Random();
  return Color.fromRGBO(
    random.nextInt(256), // Red channel (0-255)
    random.nextInt(256), // Green channel (0-255)
    random.nextInt(256), // Blue channel (0-255)
    1.0, // Alpha channel (opacity, 1.0 is fully opaque)
  );
}
