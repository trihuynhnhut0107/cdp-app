// import 'package:cdp_app/color_palette.dart';
// import 'package:cdp_app/pages/api_test.dart';
// import 'package:cdp_app/pages/landing_page.dart';
// import 'package:cdp_app/pages/main_screen.dart';
// import 'package:flutter/material.dart';

// void main() {
//   runApp(const MyApp());
// }

// class MyApp extends StatelessWidget {
//   const MyApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Flutter Demo',
//       theme: ThemeData(
//         colorScheme: ColorScheme(
//           brightness: Brightness.light,
//           primary: primaryColor,
//           onPrimary: textColor,
//           primaryContainer: primaryVariant,
//           onPrimaryContainer: Colors.white,
//           secondary: secondaryColor,
//           onSecondary: textColor,
//           secondaryContainer: secondaryVariant,
//           onSecondaryContainer: Colors.white,
//           surface: surfaceColor,
//           onSurface: textColor,
//           error: Colors.redAccent,
//           onError: Colors.white,
//         ),
//         useMaterial3: true,
//       ),
//       // home: LandingPage(),
//       home: ApiTest(),
//     );
//   }
// }
import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Post {
  final int id;
  final String title;
  final String body;

  Post({required this.id, required this.title, required this.body});

  // Factory constructor to parse JSON
  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      id: json['id'],
      title: json['title'],
      body: json['body'],
    );
  }
}

void main() => runApp(const MyApp());

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Post? post; // Store the fetched post

  Future<void> fetchPost() async {
    log("🔵 Fetching post...");

    try {
      final response = await http
          .get(Uri.parse('https://jsonplaceholder.typicode.com/posts'));

      log("🟢 Response Status: ${response.statusCode}");

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          post = Post.fromJson(data);
        });
      } else {
        setState(() {
          post = null;
        });
      }
    } catch (e) {
      log("🔴 Error: $e");
      setState(() {
        post = null;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Post Viewer',
              style: TextStyle(fontWeight: FontWeight.bold)),
          backgroundColor: Colors.deepPurple,
        ),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (post != null) ...[
                  Card(
                    elevation: 5,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15)),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Post ID: ${post!.id}",
                            style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.grey),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            post!.title,
                            style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.deepPurple),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            post!.body,
                            style: const TextStyle(fontSize: 16),
                          ),
                        ],
                      ),
                    ),
                  ),
                ] else ...[
                  const Text(
                    "Press the button to fetch a post",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                  ),
                ],
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: fetchPost,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepPurple,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 24, vertical: 12),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                  ),
                  child: const Text("Fetch Post",
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
