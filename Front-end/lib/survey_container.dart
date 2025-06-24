import 'package:cdp_app/components/star_rating.dart';
import 'package:cdp_app/models/survey_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:cdp_app/components/question_module.dart';
import 'package:cdp_app/providers/survey_provider.dart';

class SurveyContainer extends ConsumerStatefulWidget {
  final SurveyData surveyData;

  const SurveyContainer({super.key, required this.surveyData});

  @override
  ConsumerState<SurveyContainer> createState() => _SurveyContainerState();
}

class _SurveyContainerState extends ConsumerState<SurveyContainer> {
  final PageController _pageController = PageController();

  @override
  Widget build(BuildContext context) {
    final surveyData = widget.surveyData;

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Column(
        children: [
          Expanded(
            child: PageView.builder(
              controller: _pageController,
              itemCount: surveyData.questions.length,
              itemBuilder: (context, index) {
                final surveyQuestion = surveyData.questions[index];

                return Consumer(
                  builder: (context, ref, child) {
                    final selections = ref.watch(selectionProvider);
                    final selectedData = selections[index];
                    final int selectedIndex = selectedData?.optionIndex ?? -1;

                    // Render question based on type
                    return _buildQuestionWidget(
                      question: surveyQuestion,
                      selectedIndex: selectedIndex,
                      onSelection:
                          (int selectedIndex, List<String> optionList) {
                        ref.read(selectionProvider.notifier).updateSelection(
                              questionIndex: index,
                              questionID: surveyQuestion.id,
                              questionType: surveyQuestion.questionType,
                              optionIndex: selectedIndex,
                              optionList: optionList,
                            );
                      },
                      index: index, // Pass index to _buildQuestionWidget
                    );
                  },
                );
              },
            ),
          ),
          SmoothPageIndicator(
            controller: _pageController,
            count: surveyData.questions.length,
            effect: JumpingDotEffect(
              verticalOffset: 5.0,
              activeDotColor: Theme.of(context).colorScheme.primary,
            ),
          ),
        ],
      ),
    );
  }

  // Dynamic widget builder for different question types
  Widget _buildQuestionWidget({
    required Question question,
    required int selectedIndex,
    required Function(int, List<String>) onSelection,
    required int index, // <-- add index parameter
  }) {
    switch (question.questionType) {
      case 'selection':
        return SelectionQuestion(
          question: question.questionContent,
          options: question.options,
          selection: selectedIndex,
          onSelection: (int index) {
            final optionId = question.options[index].id;
            onSelection(index, [optionId]);
          },
        );
      case 'multiple':
        // Get all selected indexes for this question
        final selections = ref.watch(selectionProvider);
        final selectedData = selections[index];
        final selectedIndexes = selectedData?.optionList != null
            ? selectedData!.optionList!
                .map((id) => question.options.indexWhere((opt) => opt.id == id))
                .where((i) => i != -1)
                .toList()
            : <int>[];
        return MultipleSelectionQuestion(
          question: question.questionContent,
          options: question.options,
          selectedIndexes: selectedIndexes,
          onSelection: (List<int> indexes) {
            // Always send the full list of selected option IDs to the provider
            final optionIds =
                indexes.map((i) => question.options[i].id).toList();
            onSelection(
                -1, optionIds); // -1 for optionIndex, optionIds for optionList
          },
        );
      case 'open':
        // No need to get current answer, just update provider on answer
        return OpenQuestion(
          question: question.questionContent,
          onAnswer: (String answer) {
            ref.read(selectionProvider.notifier).updateSelection(
                  questionIndex: index,
                  questionID: question.id,
                  questionType: question.questionType,
                  answer: answer.trim().isNotEmpty ? answer : null,
                );
          },
        );
      case 'rating':
        // Get the current rating value for this question, or default to 0
        final selections = ref.watch(selectionProvider);
        final selectedData = selections[index];
        final double initialRating = selectedData?.score != null &&
                selectedData!.score! >= 1 &&
                selectedData.score! <= 5
            ? selectedData.score!.toDouble()
            : 0.0;
        return EmojiRatingBar(
          question: question.questionContent, // Pass question text
          initialRating: initialRating,
          isVertical: false, // or true if you want vertical
          onRatingUpdate: (double rating) {
            ref.read(selectionProvider.notifier).updateSelection(
                  questionIndex: index,
                  questionID: question.id,
                  questionType: question.questionType,
                  score: rating.round(), // Store as 1-based score
                );
          },
        );
      default:
        return const PlaceholderWidget();
    }
  }
}

// Placeholder for unsupported question types
class PlaceholderWidget extends StatelessWidget {
  const PlaceholderWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text('Question type not supported yet.'),
    );
  }
}
