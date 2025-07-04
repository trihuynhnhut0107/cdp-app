import 'package:cdp_app/models/survey_data.dart';
import 'package:cdp_app/pages/survey_completion_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:cdp_app/components/gradient_button.dart';
import 'package:cdp_app/survey_container.dart';
import 'package:cdp_app/providers/survey_provider.dart';

class APIService {
  static const String _baseURL = "http://10.0.2.2:8000/survey";

  Future<SurveyData> fetchSurvey(String uuid) async {
    final response = await http.get(Uri.parse("$_baseURL/$uuid"));

    if (response.statusCode == 200) {
      return parseMetadata(response.body);
    } else {
      throw Exception("Failed to load survey");
    }
  }
}

class SurveyPage extends ConsumerStatefulWidget {
  final String uuid;
  const SurveyPage({super.key, required this.uuid});

  @override
  ConsumerState<SurveyPage> createState() => _SurveyPageState();
}

class _SurveyPageState extends ConsumerState<SurveyPage> {
  Future<SurveyData> fetchSurveyData() {
    return APIService().fetchSurvey(widget.uuid);
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // Set the survey id in the provider and clear previous record if changed
    ref.read(selectionProvider.notifier).setSurvey(widget.uuid);
    return Scaffold(
      appBar: AppBar(title: const Text("Survey Screen")),
      body: FutureBuilder<SurveyData>(
        future: fetchSurveyData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          } else if (!snapshot.hasData) {
            return const Center(child: Text("No survey data available"));
          }

          final surveyData = snapshot.data!;

          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  surveyData.survey.surveyName,
                  style: const TextStyle(
                      fontSize: 24, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 2,
                ),
              ),
              Expanded(
                child: SurveyContainer(surveyData: surveyData),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: GradientButton(
                  onPressed: () async {
                    try {
                      final wasSuccessful = await ref
                          .read(selectionProvider.notifier)
                          .submitSurveyAnswers(ref);

                      if (!context.mounted) {
                        return;
                      } // Prevent errors if widget is unmounted

                      if (wasSuccessful) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => SurveyCompletionScreen(
                              surveyId: widget.uuid,
                            ),
                          ),
                        );
                      }
                    } catch (e) {
                      if (!context.mounted) {
                        return;
                      } // Check context before showing Snackbar

                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(e.toString()),
                        ),
                      );
                    }
                  },
                  text: "Submit",
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
