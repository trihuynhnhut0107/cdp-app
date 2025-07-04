import 'dart:convert';

import 'package:cdp_app/models/survey_info.dart';
import 'package:http/http.dart' as http;

class SurveyListService {
  static const String baseURL = 'http://10.0.2.2:8000';

  Future<List<SurveyInfo>> fetchSurveyList({String? userId}) async {
    final headers = <String, String>{};
    if (userId != null) {
      headers['user_id'] = userId;
    }
    final response = await http.get(
      Uri.parse('$baseURL/survey'),
      headers: headers,
    );

    if (response.statusCode == 200) {
      Map<String, dynamic> jsonResponse =
          jsonDecode(response.body); // Decode entire JSON
      List<dynamic> metadataList =
          jsonResponse['metadata']; // Extract metadata array
      List<SurveyInfo> result =
          metadataList.map((json) => SurveyInfo.fromJson(json)).toList();
      return result;
    } else {
      throw Exception('Failed to load survey list');
    }
  }
}
