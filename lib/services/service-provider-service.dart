import 'dart:convert';
import 'dart:io';
import 'package:fixitnow/models/appointment_model.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import '../models/sp-analytics.model.dart';
import '../models/sp-detailed.dart';
import '../models/sp_category-list.dart';
import 'package:mime/mime.dart'; // For determining the MIME type
import 'package:path/path.dart'; // To handle file path functions
import 'package:http/http.dart' as http;
import 'package:mime/mime.dart';  // For MIME type handling
import 'package:http_parser/http_parser.dart';  // For specifying content type

class CategoryServiceProviderService {
  final String baseUrl = "http://10.0.2.2:8000/api"; // Use for Android emulator

  final FlutterSecureStorage storage = FlutterSecureStorage();

  Future<String?> _getToken() async {
    return await storage.read(key: 'token');
  }

  // Fetch service providers by category
  Future<List<CategoryServiceProviderList>> getServiceProviders(String category,
      double customerLatitude, double customerLongitude) async {

    // Construct the URL
    final url = Uri.parse(
        '$baseUrl/service-providers/$category?latitude=$customerLatitude&longitude=$customerLongitude');
    print("Request URL: $url");  // Log the constructed URL

    final token = await _getToken();
    print("Retrieved token: $token");  // Log the token

    // Check if token is available
    if (token == null) {
      print("No authentication token found");  // Log token issue
      throw Exception('No authentication token found');
    }

    try {
      // Make the HTTP GET request with token
      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token', // Include the token in the header
        },
      );

      // Check for success response
      print("Response status: ${response.statusCode}");  // Log status code
      print("Response body: ${response.body}");  // Log response body

      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        final List<dynamic> providersJson = jsonResponse['data'];

        // Log for debugging
        print("Fetched providers data: $providersJson");

        // Parse the JSON into the model and return the list
        return providersJson.map((json) =>
            CategoryServiceProviderList.fromJson(json)).toList();
      } else {
        // Log and throw an exception in case of error
        print('Error: ${response.statusCode} - ${response.body}');
        throw Exception('Failed to load service providers');
      }
    } catch (e) {
      print("Exception caught: $e");  // Log any caught exception
      throw Exception('Error during fetching service providers: $e');
    }
  }



  Future<ServiceProviderDetail> getServiceProviderDetails(int id,
      double latitude, double longitude) async {
    final token = await _getToken();

    // Log the token and ensure it's retrieved
    print('Token retrieved: $token');
    if (token == null) {
      print('Error: No token available');
      throw Exception('No authentication token found');
    }

    final url = Uri.parse(
        '$baseUrl/service-provider/$id?latitude=$latitude&longitude=$longitude');

    // Log the URL, latitude, and longitude to check if everything is correct
    print('Requesting URL: $url');
    print('Latitude: $latitude, Longitude: $longitude');
    print('Service Provider ID: $id');

    try {
      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token', // Include the token in the header
        },
      );

      // Log the response status, headers, and body for full debugging
      print('Response status code: ${response.statusCode}');
      print('Response headers: ${response.headers}');
      print('Response body: ${response.body}'); // Log the raw response body

      // Handle success response
      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        // Log the parsed JSON data to make sure it's correct
        print('Parsed data: $data');

        // Convert the response to a ServiceProviderDetail object
        return ServiceProviderDetail.fromJson(data);
      } else if (response.statusCode == 500) {
        // Log and handle 500 Internal Server Error
        print('Internal server error (500): ${response.body}');
        throw Exception('Server error: ${response.body}');
      } else {
        // Handle other non-200 responses
        print('Error occurred: Status code ${response.statusCode}');
        print('Response body: ${response.body}');
        throw Exception(
            'Failed to fetch service provider details: ${response.statusCode}');
      }
    } catch (e) {
      // Catch any exception and log it
      print('Exception caught: $e');
      rethrow; // Rethrow the exception to propagate it upwards
    }
  }


  // Fetch availability status from the server
  Future<bool> getAvailability() async {
    final url = Uri.parse('$baseUrl/service-provider/getavailability');
    final token = await _getToken();

    if (token == null) {
      throw Exception('No authentication token found');
    }

    final response = await http.get(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      return jsonResponse['availability'];
    } else {
      print('Error: ${response.statusCode} - ${response.body}');
      throw Exception('Failed to fetch availability status');
    }
  }

  // Update availability status on the server
  Future<void> updateAvailability(bool availability) async {
    final url = Uri.parse('$baseUrl/service-provider/updateavailability');
    final token = await _getToken();

    if (token == null) {
      throw Exception('No authentication token found');
    }

    final response = await http.patch(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: json.encode({'availability': availability}),
    );

    if (response.statusCode == 200) {
      print('Availability updated successfully');
    } else {
      print('Error: ${response.statusCode} - ${response.body}');
      throw Exception('Failed to update availability status');
    }
  }


  Future<void> toggleAvailability(bool isAvailable) async {
    final url = Uri.parse('$baseUrl/service-provider/toggle-availability');
    final token = await _getToken(); // Assume a method to get the token

    if (token == null) {
      throw Exception('No token found');
    }

    final response = await http.put(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json', // Ensure you're expecting JSON
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({
        'availability': isAvailable ? 'available' : 'unavailable',
      }),
    );

    print(
        'Response from server: ${response.body}'); // Debug: print raw response

    if (response.statusCode == 200) {
      print('Availability toggled successfully');
    } else {
      throw Exception('Failed to toggle availability: ${response.body}');
    }
  }


  Future<List<AppointmentModel>> getRequestAppointments() async {
    final url = Uri.parse('$baseUrl/appointments/request');

    // Retrieve the token (assuming you have a _getToken function to get the token)
    final token = await _getToken();

    if (token == null) {
      throw Exception('No authentication token found');
    }

    // Perform the HTTP GET request with the Authorization header
    final response = await http.get(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    // Check if the response was successful
    if (response.statusCode == 200) {
      // Parse the response JSON
      final jsonResponse = json.decode(response.body);
      print('Response JSON: $jsonResponse'); // Print the full response JSON


      // Extract the appointments array
      final List<dynamic> appointmentData = jsonResponse['appointments'];

      // Map the list of JSON objects into a list of ServiceProviderDetail objects
      return appointmentData.map((json) => AppointmentModel.fromJson(json))
          .toList();
    } else {
      print('Error: ${response.statusCode} - ${response.body}');
      throw Exception('Failed to load pending appointments');
    }
  }

  Future<void> updateAppointmentStatus(int appointmentId, String status,
      {String? declineReason}) async {
    final url = Uri.parse(
        '$baseUrl/appointments/$appointmentId/update'); // Use appointmentId to build the correct URL
    final token = await _getToken(); // Assume you have this method to get the token

    if (token == null) {
      throw Exception('No authentication token found');
    }
    print('Request URL: $url');
    print('Token: $token');
    print('Request Body: ${jsonEncode({
      'status': status,
      'decline_reason': declineReason ?? '',
    })}');

    print(declineReason);

    final response = await http.put(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({
        'status': status,
        'declined_reason': declineReason ?? '',
        // Include decline_reason if declining
      }),


    );
    print('Response status code: ${response.statusCode}');
    print('Response body: ${response.body}');
    if (response.statusCode != 200) {
      throw Exception('Failed to update appointment status');
    }
  }


  Future<
      List<AppointmentModel>> getOngoingAppointmentsForServiceProvider() async {
    final url = Uri.parse('$baseUrl/service-provider/appointments/ongoing');
    final token = await _getToken(); // Assuming you have a method to get the auth token

    if (token == null) {
      throw Exception('No token found');
    }

    final response = await http.get(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json', // Ensure you're expecting JSON
        'Authorization': 'Bearer $token', // Include the token in the header
      },
    );

    if (response.statusCode == 200) {
      // Parse the response body
      final List<dynamic> jsonResponse = json.decode(
          response.body)['ongoingAppointments'];

      // Map the JSON response to a list of AppointmentModel objects
      return jsonResponse.map((json) => AppointmentModel.fromJson(json))
          .toList();
    } else {
      // Handle errors
      throw Exception('Failed to load ongoing appointments');
    }
  }


  // Function to complete an appointment with an optional proof image
  Future<void> completeAppointment(int appointmentId,
      {File? proofImage}) async {
    final url = Uri.parse('$baseUrl/appointments/$appointmentId/complete');
    final token = await _getToken(); // Assuming you have a method to get the auth token

    if (token == null) {
      throw Exception('No token found');
    }

    var headers = {
      'Authorization': 'Bearer $token',
      'Accept': 'application/json',
    };

    // Create a multipart request to send the image if provided
    var request = http.MultipartRequest('POST', url);
    request.headers.addAll(headers);

    // If an image is provided, attach it to the request
    if (proofImage != null) {
      final mimeType = lookupMimeType(proofImage.path) ?? 'image/jpeg';
      final mimeTypeData = mimeType.split('/');

      request.files.add(await http.MultipartFile.fromPath(
        'proof',
        proofImage.path,
        contentType: MediaType(mimeTypeData[0], mimeTypeData[1]),
      ));
    }

    // Send the request and capture the response
    var response = await request.send();


    // Convert the streamed response to a standard HTTP response
    var responseBody = await http.Response.fromStream(response);
    print('Response body: ${responseBody.body}');


    if (responseBody.statusCode == 200) {
      final responseData = jsonDecode(responseBody.body);
      print('Appointment completion success: $responseData');
    } else {
      throw Exception('Failed to complete appointment: ${responseBody.body}');
    }
  }

  Future<AnalyticsModel> getServiceProviderAnalytics() async {
    try {
      print('Fetching token...');
      final token = await _getToken();
      print('Token fetched: $token');

      final url = Uri.parse('$baseUrl/analytics');
      print('URL: $url');

      print('Sending GET request to fetch analytics...');
      final response = await http.get(url, headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      });

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        print('Successfully fetched analytics data.');
        // Parse the JSON response and return the AnalyticsModel
        return AnalyticsModel.fromJson(jsonDecode(response.body));
      } else {
        print('Failed to load analytics data. Status code: ${response
            .statusCode}');
        throw Exception('Failed to load analytics data: ${response.body}');
      }
    } catch (e) {
      print('Error occurred while fetching analytics: $e');
      throw Exception('Error fetching analytics: $e');
    }
  }
}