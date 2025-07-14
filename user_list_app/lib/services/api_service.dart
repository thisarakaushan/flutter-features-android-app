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
  Future<List<User>> fetchUsers(int page) async {
    final response = await http.get(
      Uri.parse('$baseUrl/users?page=$page'),
      headers: headers,
    );

    if (response.statusCode == 200) {
      // Parse the JSON response
      final Map<String, dynamic> data = jsonDecode(response.body);
      // Extract the list of users from the response
      final List<dynamic> usersJson = data['data'];
      // Convert the list of JSON objects to a list of User models
      return usersJson.map((json) => User.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load users: ${response.statusCode}');
    }
  }
}
