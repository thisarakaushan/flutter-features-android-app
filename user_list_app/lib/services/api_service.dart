// Models
import '../models/user_model.dart';

// Packages
import 'package:http/http.dart' as http;
import 'dart:convert';

// Constants
import '../utils/constants.dart';

class ApiService {
  // Fetch users from the API
  /// [page] is the page number to fetch users from.
  // Future<List<User>> fetchUsers(int page) async {
  // Get both users (list of User objects) and totalPages.
  Future<Map<String, dynamic>> fetchUsers(int page) async {
    final response = await http.get(
      Uri.parse('$baseUrl/users?page=$page'),
      headers: headers,
    );

    if (response.statusCode == 200) {
      // Parse the JSON response
      final Map<String, dynamic> data = jsonDecode(response.body);
      // Extract the list of users from the response
      final List<dynamic> usersJson = data['data'];
      // final List<dynamic> usersJson = data['data'] ?? [];

      // Check if there are more pages
      // final int totalPages = data['total_pages'] ?? 1;
      final int totalPages = data['total_pages'] as int;

      // Convert the list of JSON objects to a list of User models
      // return usersJson.map((json) => User.fromJson(json)).toList();
      final List<User> users = usersJson
          .map((json) => User.fromJson(json))
          .toList();
      return {'users': users, 'total_pages': totalPages};
    } else {
      throw Exception('Failed to load users: ${response.statusCode}');
    }
  }
}
