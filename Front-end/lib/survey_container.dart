import 'package:cdp_app/question_module.dart';
import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart'; // Import the smooth_page_indicator package

class SurveyContainer extends StatefulWidget {
  final List<Map<String, dynamic>> surveyList;
  const SurveyContainer({super.key, required this.surveyList});

  @override
  State<SurveyContainer> createState() => _SurveyContainerState();
}

class _SurveyContainerState extends State<SurveyContainer> {
  get colorScheme => Theme.of(context).colorScheme;
  final PageController _pageController = PageController();
  int _currentPage = 0;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(), // Dismiss keyboard on tap
      child: Column(
        children: [
          Expanded(
            child: PageView(
              controller: _pageController,
              onPageChanged: (int page) {
                FocusScope.of(context)
                    .unfocus(); // Dismiss keyboard on page change
                setState(() {
                  _currentPage = page;
                });
              },
              children: widget.surveyList.map((surveyQuestion) {
                switch (surveyQuestion['type']) {
                  case "selection":
                    return SelectionQuestion(
                      question: surveyQuestion['question'],
                      options: surveyQuestion['options'],
                      color: surveyQuestion['color'] ?? const Color(0x800000FF),
                      selection: surveyQuestion['selection'] ?? -1,
                      onSelection: (int selection) {
                        setState(() {
                          surveyQuestion['selection'] = selection;
                        });
                      },
                    );
                  case "multiple":
                    return MultipleSelectionQuestion(
                      question: surveyQuestion['question'],
                      options: surveyQuestion['options'],
                      maxSelections: surveyQuestion['max_selection'] ?? 2,
                      selection:
                          List<int>.from(surveyQuestion['selection'] ?? []),
                      onSelection: (List<int> newSelection) {
                        setState(() {
                          surveyQuestion['selection'] = newSelection;
                        });
                      },
                    );
                  case "open":
                    return OpenQuestion(
                      question: surveyQuestion['question'],
                      characterLimit: surveyQuestion['characterLimit'] ?? 100,
                    );
                  default:
                    return const Center(
                      child: Text("Unsupported question type"),
                    );
                }
              }).toList(),
            ),
          ),
          SmoothPageIndicator(
            controller: _pageController, // Sync with PageView
            count: widget.surveyList.length, // Number of pages
            effect: JumpingDotEffect(
              verticalOffset: 5.0,
              activeDotColor: colorScheme.primary,
              dotColor: colorScheme.secondary,
            ),
          ),
        ],
      ),
    );
  }
}
