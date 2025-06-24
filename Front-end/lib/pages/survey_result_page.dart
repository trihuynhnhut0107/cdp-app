// Import this for jsonEncode()
import 'dart:convert';
import 'dart:math';
import 'package:cdp_app/pages/main_screen.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/user_provider.dart';
import '../components/gradient_button.dart';
import '../components/star_rating.dart';

class SurveyResultPage extends ConsumerStatefulWidget {
  final String surveyId;

  const SurveyResultPage({super.key, required this.surveyId});

  @override
  ConsumerState<SurveyResultPage> createState() => _SurveyResultPageState();
}

class _SurveyResultPageState extends ConsumerState<SurveyResultPage> {
  bool _isLoading = true;
  String? _surveyName;
  List<Map<String, dynamic>> _questions = [];
  String? _error;

  @override
  void initState() {
    super.initState();
    // Don't fetch here, fetch in build after getting userId
  }

  Future<void> _fetchSurveyResult(String userId) async {
    setState(() {
      _isLoading = true;
      _error = null;
    });
    try {
      final url = Uri.parse(
          'http://10.0.2.2:8000/answer/?survey_id=${widget.surveyId}&user_id=$userId');
      final response = await http.get(url);
      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = jsonDecode(response.body);
        setState(() {
          _surveyName =
              data['metadata']['survey_name']['survey_name'] ?? 'Survey Result';
          _questions = (data['metadata']['questions'] as List)
              .map((q) => q as Map<String, dynamic>)
              .toList();
          _isLoading = false;
        });
      } else {
        setState(() {
          _error = 'Failed to fetch survey result.';
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _error = 'Error: \\${e.toString()}';
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final userId = ref.watch(userIdProvider);
    if (userId == null) {
      return Scaffold(
        appBar: AppBar(title: Text('Survey Results')),
        body: Center(child: Text('User not logged in.')),
      );
    }
    // Fetch only once per userId
    if (_isLoading && _error == null && _questions.isEmpty) {
      _fetchSurveyResult(userId);
    }
    return Scaffold(
      appBar: AppBar(title: Text(_surveyName ?? 'Survey Results')),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : _error != null
              ? Center(child: Text(_error!))
              : Stack(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(
                          left: 16.0, right: 16.0, bottom: 80.0, top: 16.0),
                      child: ListView.builder(
                        itemCount: _questions.length,
                        itemBuilder: (context, index) {
                          final q = _questions[index];
                          final answerData = q['answer'];
                          final isRating =
                              answerData is num || answerData == null;
                          final answers = !isRating && answerData is List
                              ? answerData
                                  .map((a) =>
                                      a['option_content'] ?? a['answer'] ?? '')
                                  .where((s) =>
                                      s != null && s.toString().isNotEmpty)
                                  .toList()
                              : [];
                          final isOpen = !isRating &&
                              (answerData is List) &&
                              answerData.isNotEmpty &&
                              answerData[0]['answer'] != null;
                          final isMulti = !isRating &&
                              (answerData is List) &&
                              answerData.length > 1 &&
                              !isOpen;
                          final isSingle = !isRating &&
                              (answerData is List) &&
                              answerData.length == 1 &&
                              !isOpen;
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
                                    q['question'] ?? '',
                                    style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black),
                                  ),
                                  SizedBox(height: 8.0),
                                  if (isRating)
                                    AbsorbPointer(
                                      child: EmojiRatingBar(
                                        question: '',
                                        initialRating: (answerData is num)
                                            ? answerData.toDouble()
                                            : 0.0,
                                        isVertical: false,
                                        onRatingUpdate: (_) {},
                                      ),
                                    )
                                  else if (isSingle)
                                    Row(
                                      children: [
                                        Icon(Icons.radio_button_checked,
                                            color: Colors.black),
                                        SizedBox(width: 8),
                                        Text(
                                          answers[0],
                                          style: TextStyle(
                                              fontSize: 16,
                                              color: Colors.black),
                                        ),
                                        SizedBox(width: 8),
                                        Text('(Single choice)',
                                            style: TextStyle(
                                                fontSize: 14,
                                                color: Colors.black54)),
                                      ],
                                    )
                                  else if (isMulti)
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        ...answers.map((ans) => Row(
                                              children: [
                                                Icon(Icons.check_box,
                                                    color: Colors.black),
                                                SizedBox(width: 8),
                                                Text(ans,
                                                    style: TextStyle(
                                                        fontSize: 16,
                                                        color: Colors.black)),
                                              ],
                                            )),
                                        SizedBox(height: 4),
                                        Text('(Multiple choice)',
                                            style: TextStyle(
                                                fontSize: 14,
                                                color: Colors.black54)),
                                      ],
                                    )
                                  else if (isOpen)
                                    Row(
                                      children: [
                                        Icon(Icons.edit, color: Colors.black),
                                        SizedBox(width: 8),
                                        Expanded(
                                          child: Text(
                                            answers[0],
                                            style: TextStyle(
                                                fontSize: 16,
                                                color: Colors.black),
                                          ),
                                        ),
                                        SizedBox(width: 8),
                                        Text('(Open answer)',
                                            style: TextStyle(
                                                fontSize: 14,
                                                color: Colors.black54)),
                                      ],
                                    )
                                  else
                                    Text('No answer',
                                        style: TextStyle(
                                            fontSize: 16, color: Colors.black)),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    Positioned(
                      left: 0,
                      right: 0,
                      bottom: 0,
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: GradientButton(
                          onPressed: () {
                            Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => MainScreen()),
                              (Route<dynamic> route) =>
                                  false, // Remove all previous routes
                            );
                          },
                          text: 'Back to Survey Home',
                        ),
                      ),
                    ),
                  ],
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
