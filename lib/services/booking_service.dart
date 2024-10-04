import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import '../models/appointment_model.dart';

class AppointmentService {

  final String baseUrl = "http://10.0.2.2:8000/api"; // Use for Android emulator
  final FlutterSecureStorage storage = FlutterSecureStorage();

  Future<String?> _getToken() async {
    return await storage.read(key: 'token');
  }

  Future<AppointmentModel> bookAppointment({
    required int serviceProviderId,
    required String startTime,
    String? notes,
    required String serviceType,
    required double latitude, // Ensure latitude is not null (but seems fine based on logs)
    required double longitude, // Ensure longitude is not null (but seems fine based on logs)
  }) async {
    final url = Uri.parse('$baseUrl/book');

    // Get the token
    final token = await _getToken();
    print('Token retrieved: $token');

    // Debug log for the parameters
    print('Service Provider ID: $serviceProviderId');
    print('Start Time: $startTime');
    print('Service Type: $serviceType');
    print('Latitude: $latitude');
    print('Longitude: $longitude');

    if (token == null) {
      throw Exception('No token found');
    }

    // Make the HTTP POST request with the appointment data
    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token', // Include the Bearer token
      },
      body: jsonEncode({
        'serviceprovider_id': serviceProviderId,
        'start_time': startTime,
        'notes': notes,
        'service_type': serviceType,
        'latitude': latitude, // Pass latitude to the backend
        'longitude': longitude, // Pass longitude to the backend
      }),
    );

    // Check for success response
    if (response.statusCode != 201) {
      throw Exception('Failed to book appointment: ${response.body}');
    }

    // Parse the response into an AppointmentModel
    final data = jsonDecode(response.body);
    return AppointmentModel.fromJson(data['appointment']);
  }


  Future<List<AppointmentModel>> getPendingAppointments() async {
    final url = Uri.parse('$baseUrl/appointments/pending');

    // Get the token from secure storage
    final token = await _getToken();

    if (token == null) {
      throw Exception('No token found');
    }

    // Perform the GET request
    final response = await http.get(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json', // Ensure you're expecting JSON
        'Authorization': 'Bearer $token', // Pass the Bearer token
      },
    );

    print('Response from server: ${response.body}');

    if (response.statusCode == 200) {
      final List<dynamic> jsonData = jsonDecode(response.body)['appointments'];
      return jsonData.map((json) => AppointmentModel.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load appointments');
    }
  }


  // Fetch rejected appointments
  Future<List<AppointmentModel>> getRejectedAppointments() async {
    final url = Uri.parse('$baseUrl/appointments/rejected');
    final token = await _getToken();

    if (token == null) {
      throw Exception('No token found');
    }

    final response = await http.get(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json', // Ensure you're expecting JSON
        'Authorization': 'Bearer $token',
      },
    );

    print(
        'Response from server: ${response.body}'); // Debug: print raw response


    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(
          response.body)['rejectedAppointments'];
      print('Parsed appointments data: $data'); // Debug: print parsed data
      return data.map((json) => AppointmentModel.fromJson(json)).toList();
    } else {
      throw Exception(
          'Failed to fetch rejected appointments: ${response.body}');
    }
  }

  // Mark appointment as seen
  Future<void> markAppointmentAsSeen(int appointmentId) async {
    final token = await _getToken();

    if (token == null) {
      throw Exception('No token found');
    }

    final url = Uri.parse('$baseUrl/appointments/mark-seen');
    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({'appointment_id': appointmentId}),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to mark appointment as seen: ${response.body}');
    }
  }

  // Fetch completed appointments
  Future<List<AppointmentModel>> getCompletedAppointments() async {
    final url = Uri.parse('$baseUrl/appointments/completed');
    final token = await _getToken();

    if (token == null) {
      throw Exception('No token found');
    }

    final response = await http.get(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json', // Ensure you're expecting JSON
        'Authorization': 'Bearer $token',
      },
    );

    print('Response from server: ${response.body}'); // Debug: print raw response

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body)['completedAppointments'];
      print('Parsed appointments data: $data'); // Debug: print parsed data
      return data.map((json) => AppointmentModel.fromJson(json)).toList();
    } else {
      throw Exception('Failed to fetch completed appointments: ${response.body}');
    }
  }

  // Fetch ongoing appointments
  Future<List<AppointmentModel>> getOngoingAppointments() async {
    final url = Uri.parse('$baseUrl/appointments/ongoing');
    final token = await _getToken();

    if (token == null) {
      throw Exception('No token found');
    }

    final response = await http.get(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json', // Ensure you're expecting JSON
        'Authorization': 'Bearer $token',
      },
    );

    print('Response from server: ${response.body}'); // Debug: print raw response

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body)['ongoingAppointments'];
      print('Parsed appointments data: $data'); // Debug: print parsed data
      return data.map((json) => AppointmentModel.fromJson(json)).toList();
    } else {
      throw Exception('Failed to fetch ongoing appointments: ${response.body}');
    }
  }

}