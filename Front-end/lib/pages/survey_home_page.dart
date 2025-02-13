import 'package:flutter/material.dart';
import 'package:cdp_app/components/gradient_button.dart';
import 'package:cdp_app/pages/survey_page.dart';

class SurveyHomePage extends StatefulWidget {
  const SurveyHomePage({super.key});

  @override
  _SurveyHomePageState createState() => _SurveyHomePageState();
}

class _SurveyHomePageState extends State<SurveyHomePage> {
  get colorScheme => Theme.of(context).colorScheme;

  // Dummy data for surveys with categories
  final List<Map<String, String>> surveys = [
    {
      "title": "Survey 1",
      "description": "A quick survey about your habits.",
      "details": "This survey focuses on daily routines and habits.",
      "category": "Health"
    },
    {
      "title": "Survey 2",
      "description": "Share your thoughts on technology.",
      "details": "Explore your preferences for emerging technologies.",
      "category": "Technology"
    },
    {
      "title": "Survey 3",
      "description": "Your opinion matters on education.",
      "details": "Help us improve learning methodologies.",
      "category": "Education"
    },
    {
      "title": "Survey 4",
      "description": "Help us improve our services.",
      "details": "We want to provide better services for you.",
      "category": "Customer Service"
    },
    {
      "title": "Survey 5",
      "description": "A fun survey about hobbies!",
      "details": "Discover what hobbies are most popular.",
      "category": "Lifestyle"
    },
  ];

  // Selected category and search query
  String selectedCategory = "All";
  String searchQuery = "";

  @override
  Widget build(BuildContext context) {
    // Filter surveys by category and search query
    List<Map<String, String>> filteredSurveys = surveys.where((survey) {
      bool matchesCategory =
          selectedCategory == "All" || survey["category"] == selectedCategory;
      bool matchesSearch =
          survey["title"]!.toLowerCase().contains(searchQuery.toLowerCase());
      return matchesCategory && matchesSearch;
    }).toList();

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          // Row with Category Bar and Search Icon
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Horizontal Scrollable Category Bar
              Expanded(
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: <String>[
                      'All',
                      'Health',
                      'Technology',
                      'Education',
                      'Customer Service',
                      'Lifestyle'
                    ].map((category) {
                      return Padding(
                        padding: const EdgeInsets.only(right: 8.0),
                        child: ChoiceChip(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                                50), // More pronounced rounded corners
                          ),
                          selectedColor: colorScheme.primary,
                          label: Text(category),
                          selected: selectedCategory == category,
                          onSelected: (selected) {
                            setState(() {
                              selectedCategory = category;
                            });
                          },
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ),
              // Search Icon
              IconButton(
                icon: const Icon(Icons.search),
                onPressed: () {
                  showSearch(
                    context: context,
                    delegate: SurveySearchDelegate(),
                  );
                },
              ),
            ],
          ),
          const SizedBox(height: 16),
          // List of Surveys
          Expanded(
            child: ListView.builder(
              itemCount: filteredSurveys.length,
              itemBuilder: (context, index) {
                final survey = filteredSurveys[index];
                return Padding(
                  padding: const EdgeInsets.only(bottom: 16.0),
                  child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    elevation: 4,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Survey Title
                          Text(
                            survey["title"]!,
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: colorScheme.primary,
                            ),
                          ),
                          const SizedBox(height: 8),

                          // Survey Description
                          Text(
                            survey["description"]!,
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.grey[700],
                            ),
                          ),
                          const SizedBox(height: 8),

                          // Survey Details
                          Text(
                            survey["details"]!,
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[600],
                            ),
                          ),
                          const SizedBox(height: 16),

                          // Button to Access Survey
                          Center(
                            child: GradientButton(
                              text: "Start survey",
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => SurveyPage(),
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class SurveySearchDelegate extends SearchDelegate {
  final List<Map<String, String>> surveys = [
    {
      "title": "Survey 1",
      "description": "A quick survey about your habits.",
      "details": "This survey focuses on daily routines and habits.",
      "category": "Health"
    },
    {
      "title": "Survey 2",
      "description": "Share your thoughts on technology.",
      "details": "Explore your preferences for emerging technologies.",
      "category": "Technology"
    },
    {
      "title": "Survey 3",
      "description": "Your opinion matters on education.",
      "details": "Help us improve learning methodologies.",
      "category": "Education"
    },
    {
      "title": "Survey 4",
      "description": "Help us improve our services.",
      "details": "We want to provide better services for you.",
      "category": "Customer Service"
    },
    {
      "title": "Survey 5",
      "description": "A fun survey about hobbies!",
      "details": "Discover what hobbies are most popular.",
      "category": "Lifestyle"
    },
  ];

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    final results = surveys.where((survey) {
      // Check if either title or description contains the search query (case insensitive)
      return survey['title']!.toLowerCase().contains(query.toLowerCase()) ||
          survey['description']!.toLowerCase().contains(query.toLowerCase());
    }).toList();

    return ListView.builder(
      itemCount: results.length,
      itemBuilder: (context, index) {
        final survey = results[index];
        return ListTile(
          title: Text(survey['title']!),
          subtitle: Text(survey['description']!),
          onTap: () {
            // Navigate to the Survey Page when tapped
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => SurveyPage(),
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final suggestions = surveys.where((survey) {
      // Check if either title or description contains the search query (case insensitive)
      return survey['title']!.toLowerCase().contains(query.toLowerCase()) ||
          survey['description']!.toLowerCase().contains(query.toLowerCase());
    }).toList();

    return ListView.builder(
      itemCount: suggestions.length,
      itemBuilder: (context, index) {
        final survey = suggestions[index];
        return ListTile(
          title: Text(survey['title']!),
          subtitle: Text(survey['description']!),
          onTap: () {
            // Navigate to the Survey Page when tapped
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => SurveyPage(),
              ),
            );
          },
        );
      },
    );
  }
}
