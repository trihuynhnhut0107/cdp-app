class SurveyInfo {
  final String id;
  final String surveyName;
  final int questionQuantity;
  final bool answered;

  SurveyInfo(
      {required this.id,
      required this.surveyName,
      required this.questionQuantity,
      required this.answered});

  factory SurveyInfo.fromJson(Map<String, dynamic> json) {
    return SurveyInfo(
      id: json['id'] as String,
      surveyName: json['survey_name'] as String,
      questionQuantity: json['question_quantity'] as int,
      answered: json['answered'] as bool,
    );
  }
}
