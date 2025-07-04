import 'dart:convert';

class SurveyData {
  final Survey survey;
  final List<Question> questions;

  SurveyData({required this.survey, required this.questions});

  factory SurveyData.fromJson(Map<String, dynamic> json) {
    return SurveyData(
      survey: Survey.fromJson(json['survey']),
      questions:
          (json['questions'] as List).map((q) => Question.fromJson(q)).toList(),
    );
  }
}

class Survey {
  final String id;
  final String surveyName;
  final int questionQuantity;

  Survey(
      {required this.id,
      required this.surveyName,
      required this.questionQuantity});

  factory Survey.fromJson(Map<String, dynamic> json) {
    return Survey(
      id: json['id'],
      surveyName: json['survey_name'],
      questionQuantity: json['question_quantity'],
    );
  }
}

class Question {
  final String id;
  final String questionContent;
  final int optionsQuantity;
  final String questionType;
  final List<Option> options;

  Question(
      {required this.id,
      required this.questionContent,
      required this.optionsQuantity,
      required this.questionType,
      required this.options});

  factory Question.fromJson(Map<String, dynamic> json) {
    final q = json['question'];
    return Question(
      id: q['id'],
      questionContent: q['question_content'],
      optionsQuantity: q['options_quantity'],
      questionType: q['question_type'],
      options:
          (json['options'] as List).map((o) => Option.fromJson(o)).toList(),
    );
  }
}

class Option {
  final String id;
  final String optionContent;

  Option({required this.id, required this.optionContent});

  factory Option.fromJson(Map<String, dynamic> json) {
    return Option(
      id: json['id'],
      optionContent: json['option_content'],
    );
  }
}

SurveyData parseMetadata(String jsonStr) {
  final parsed = jsonDecode(jsonStr);
  return SurveyData.fromJson(parsed['metadata']);
}
