import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class CustomerService {
  final String baseUrl = "http://10.0.2.2:8000/api"; // Example for Android emulator
  final FlutterSecureStorage storage = FlutterSecureStorage();

  Future<List<dynamic>> getTopWorkers() async {
    final url = Uri.parse('$baseUrl/top-workers');
    final token = await _getToken();

    if (token == null) {
      throw Exception('No authentication token found');
    }

    // Make the HTTP GET request with the token
    final response = await http.get(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',  // Include the token in the header
      },
    );

    // Check for success response
    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      print('Full API Response: ${jsonResponse}');  // Log the full response
      final List<dynamic> workersJson = jsonResponse['topWorkers'];

      // Log for debugging
      print("Fetched top workers: $workersJson");

      // Return the raw JSON list
      return workersJson;
    } else {
      // Log and throw an exception in case of error
      print('Error: ${response.statusCode} - ${response.body}');
      throw Exception('Failed to load top workers');
    }
  }

  // Fetch token from secure storage
  Future<String?> _getToken() async {
    return await storage.read(key: 'token');
  }
}
