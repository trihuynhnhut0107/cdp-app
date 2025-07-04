import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:cdp_app/providers/user_provider.dart';

// SelectionData: Stores option(s) and answer for various question types
class SelectionData {
  final int questionIndex;
  final String questionID;
  final String questionType; // "single", "multiple", "open", "rating"
  final int? optionIndex; // For single-choice questions
  final List<String>? optionList; // For multiple-choice questions
  final String? answer; // For open-ended questions
  final int? score; // For rating questions (1-5)

  SelectionData({
    required this.questionIndex,
    required this.questionID,
    required this.questionType,
    this.optionIndex,
    this.optionList,
    this.answer,
    this.score,
  });

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> json = {
      "question_id": questionID,
    };

    if (questionType == "selection") {
      json["option_list"] = optionList != null && optionList!.isNotEmpty
          ? [
              {"option_id": optionList!.first}
            ]
          : [];
    } else if (questionType == "multiple") {
      json["option_list"] = optionList != null && optionList!.isNotEmpty
          ? optionList!.map((optionId) => {"option_id": optionId}).toList()
          : [];
    } else if (questionType == "open") {
      if (answer != null && answer!.trim().isNotEmpty) {
        json["answer"] = answer;
      }
    }
    // Always include score for rating questions, and only score/question_id for rating
    if (questionType == "rating") {
      json.remove("option_list");
      json.remove("answer");
      if (score != null && score! >= 1 && score! <= 5) {
        json["score"] = score;
      }
    }
    return json;
  }
}

// SelectionProvider: Stores selected answers for each question
final selectionProvider =
    StateNotifierProvider<SelectionNotifier, Map<int, SelectionData>>(
  (ref) => SelectionNotifier(),
);

class SelectionNotifier extends StateNotifier<Map<int, SelectionData>> {
  SelectionNotifier() : super({});

  String? _surveyId;

  // Update selection for all question types
  void updateSelection({
    required int questionIndex,
    required String questionID,
    required String questionType,
    int? optionIndex,
    List<String>? optionList,
    String? answer,
    int? score, // Add score for rating
  }) {
    state = {
      ...state,
      questionIndex: SelectionData(
        questionIndex: questionIndex,
        questionID: questionID,
        questionType: questionType,
        optionIndex: optionIndex,
        optionList: optionList,
        answer: answer,
        score: score, // Store score
      ),
    };
  }

  void setSurvey(String uuid) {
    _surveyId = uuid;
  }

  // Remove selection
  void removeSelection(int questionIndex) {
    if (state.containsKey(questionIndex)) {
      final newState = Map<int, SelectionData>.from(state);
      newState.remove(questionIndex);
      state = newState;
    }
  }

  // Reset all selections
  void resetSelections() {
    state = {};
  }

  // Submit Survey Answers (with multiple question types)
  Future<bool> submitSurveyAnswers(WidgetRef ref) async {
    if (state.isEmpty) return false;

    const String apiUrl = "http://10.0.2.2:8000/answer"; // API endpoint
    final headers = {"Content-Type": "application/json"};

    final userId = ref.read(userIdProvider);
    if (userId == null) {
      throw Exception("User ID not found. Please log in again.");
    }
    if (_surveyId == null) {
      throw Exception("Survey ID not set. Please select a survey.");
    }

    final Map<String, dynamic> bodyData = {
      "user_id": userId,
      "survey_id": _surveyId,
      "answers": state.values.map((answer) => answer.toJson()).toList(),
    };

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: headers,
        body: jsonEncode(bodyData),
      );
      debugPrint(response.body);

      if (response.statusCode == 200 || response.statusCode == 201) {
        resetSelections(); // Clear selections after successful submission
        return true; // Success
      } else {
        final errorMessage =
            jsonDecode(response.body)["error"] ?? "Unknown error";
        throw Exception(errorMessage);
      }
    } catch (e) {
      throw Exception("Error submitting answers: \\${e.toString()}");
    }
  }
}
