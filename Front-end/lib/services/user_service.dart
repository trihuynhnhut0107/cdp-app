import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:cdp_app/models/user_model.dart';

class UserService {
  static const String baseUrl = 'http://10.0.2.2:8000';

  static Future<UserModel?> getUserById(String userId) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/user/$userId'),
        headers: {'Content-Type': 'application/json'},
      );

      print('API Response Status: ${response.statusCode}');
      print('API Response Body: ${response.body}');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        // Handle different possible response structures
        Map<String, dynamic> userData;
        if (data is Map<String, dynamic>) {
          // If the response contains metadata or nested structure
          if (data.containsKey('metadata') && data['metadata'] is Map) {
            userData = data['metadata'];
          } else if (data.containsKey('user') && data['user'] is Map) {
            userData = data['user'];
          } else if (data.containsKey('data') && data['data'] is Map) {
            userData = data['data'];
          } else {
            userData = data;
          }
        } else {
          throw Exception('Invalid response format');
        }

        print('Parsed user data: $userData');
        return UserModel.fromJson(userData);
      } else {
        throw Exception('Failed to load user data: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching user data: $e');
      return null;
    }
  }

  /// Test method to verify API connection
  static Future<void> testApiConnection() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/user/test'),
        headers: {'Content-Type': 'application/json'},
      );
      print('Test API Response Status: ${response.statusCode}');
      print('Test API Response Body: ${response.body}');
    } catch (e) {
      print('Error testing API connection: $e');
    }
  }
}
