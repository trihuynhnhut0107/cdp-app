import 'package:flutter/material.dart';
import 'package:cdp_app/components/gradient_button.dart';
import 'package:cdp_app/pages/survey_page.dart';
import 'package:cdp_app/pages/survey_result_page.dart';
import 'package:cdp_app/services/survey_list_fetch.dart';
import 'package:cdp_app/models/survey_info.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cdp_app/providers/user_provider.dart';
import 'package:cdp_app/color_palette.dart';

class SurveyHomePage extends ConsumerStatefulWidget {
  const SurveyHomePage({super.key});

  @override
  ConsumerState<SurveyHomePage> createState() => _SurveyHomePageState();
}

class _SurveyHomePageState extends ConsumerState<SurveyHomePage> {
  ColorScheme get colorScheme => Theme.of(context).colorScheme;

  // State for surveys
  late Future<List<SurveyInfo>> _surveyListFuture;
  bool _showOnlyUnanswered = false; // Filter state

  @override
  void initState() {
    super.initState();
    // Don't fetch here, fetch in build with userId
  }

  @override
  Widget build(BuildContext context) {
    final userId = ref.watch(userIdProvider);
    _surveyListFuture = SurveyListService().fetchSurveyList(userId: userId);
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          // Filter toggle
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text('Show only unanswered', style: TextStyle(fontSize: 14)),
              Switch(
                value: _showOnlyUnanswered,
                onChanged: (val) {
                  setState(() {
                    _showOnlyUnanswered = val;
                  });
                },
                activeColor: backgroundColor,
                inactiveThumbColor: textSecondary,
                inactiveTrackColor: surfaceColor,
                trackOutlineColor: WidgetStateProperty.resolveWith<Color?>(
                  (Set<WidgetState> states) {
                    if (states.contains(WidgetState.disabled)) {
                      return primaryBase.withOpacity(.48);
                    }
                    return textSecondary;
                  },
                ),
                activeTrackColor: colorScheme.primary,
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                splashRadius: 16,
              ),
            ],
          ),
          const SizedBox(height: 16),
          // List of Surveys
          Expanded(
            child: FutureBuilder<List<SurveyInfo>>(
              future: _surveyListFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text("Error: ${snapshot.error}"));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(child: Text("No surveys available"));
                }

                // Filter surveys if needed
                final allSurveys = snapshot.data!;
                final surveys = _showOnlyUnanswered
                    ? allSurveys.where((s) => s.answered == false).toList()
                    : allSurveys;

                if (surveys.isEmpty) {
                  return const Center(child: Text("No surveys to display"));
                }

                return ListView.builder(
                  itemCount: surveys.length,
                  itemBuilder: (context, index) {
                    final survey = surveys[index];
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 16.0),
                      child: Card(
                        color: colorScheme.surface,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        elevation: 4,
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Survey Title + Answered badge
                              Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      survey.surveyName,
                                      style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                        color: colorScheme.primary,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 2,
                                    ),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 8, vertical: 4),
                                    decoration: BoxDecoration(
                                      color: survey.answered
                                          ? analogousGreen.withOpacity(0.2)
                                          : primaryLight.withOpacity(0.3),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Row(
                                      children: [
                                        Icon(
                                          survey.answered
                                              ? Icons.check_circle
                                              : Icons.hourglass_empty,
                                          color: survey.answered
                                              ? analogousGreen
                                              : primaryDark,
                                          size: 16,
                                        ),
                                        const SizedBox(width: 4),
                                        Text(
                                          survey.answered
                                              ? 'Answered'
                                              : 'Unanswered',
                                          style: TextStyle(
                                            color: survey.answered
                                                ? analogousGreen
                                                    .withOpacity(0.8)
                                                : primaryDark,
                                            fontSize: 12,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),

                              // Survey Details
                              Text(
                                "Questions: ${survey.questionQuantity}",
                                style: TextStyle(
                                  fontSize: 14,
                                  color: textSecondary,
                                ),
                              ),
                              const SizedBox(height: 16),

                              // Button to Access Survey
                              Center(
                                child: GradientButton(
                                  text: survey.answered
                                      ? "View Result"
                                      : "Start survey",
                                  onPressed: () {
                                    if (survey.answered) {
                                      // Navigate to survey result page
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              SurveyResultPage(
                                                  surveyId: survey.id),
                                        ),
                                      );
                                    } else {
                                      // Navigate to survey page
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              SurveyPage(uuid: survey.id),
                                        ),
                                      );
                                    }
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
