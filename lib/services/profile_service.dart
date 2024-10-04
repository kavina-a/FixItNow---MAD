import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../models/serviceprovider_model.dart';

class ProfileService {
  final FlutterSecureStorage storage = FlutterSecureStorage();
  final String baseUrl = "http://10.0.2.2:8000/api"; // Use for Android emulator

  Future<String?> _getToken() async {
    return await storage.read(key: 'token');
  }

// Function to get service provider profile
  Future<ServiceProviderModel> getServiceProviderProfile() async {
    final url = Uri.parse('$baseUrl/profile/serviceprovider');
    final token = await _getToken();

    print('Fetching profile from URL: $url');
    print('Using token: $token');

    final response = await http.get(url, headers: {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
    });

    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');

    if (response.statusCode == 200) {
      return ServiceProviderModel.fromJson(jsonDecode(response.body)['profile']);
    } else {
      throw Exception('Failed to fetch profile: ${response.body}');
    }
  }

  Future<void> updateServiceProviderProfile({
    String? firstName,
    String? lastName,
    String? phoneNumber,
    String? address,
    String? city,
    String? serviceType,
    String? description,
    int? yearsOfExperience,
    File? profileImage,  // Image parameter
  }) async {
    final url = Uri.parse('$baseUrl/service-provider/update/profile');

    print('Updating service provider profile...');

    var request = http.MultipartRequest('PUT', url);

    // Add fields data
    if (firstName != null) request.fields['first_name'] = firstName;
    if (lastName != null) request.fields['last_name'] = lastName;
    if (phoneNumber != null) request.fields['phone_number'] = phoneNumber;
    if (address != null) request.fields['address'] = address;
    if (city != null) request.fields['city'] = city;
    if (yearsOfExperience != null) request.fields['years_of_experience'] = yearsOfExperience.toString();
    if (description != null) request.fields['description'] = description;
    if (serviceType != null) request.fields['service_type'] = serviceType;  // Single string value

    // Add profile image if provided
    if (profileImage != null) {
      print('Adding profile image to the request: ${profileImage.path}');
      print('File Type: ${profileImage.path.split('.').last}');  // Log the file type

      request.files.add(await http.MultipartFile.fromPath(
        'profile_image',
        profileImage.path,
      ));
    }


    // Add headers manually
    request.headers.addAll({
      'Content-Type': 'multipart/form-data',
      'Accept': 'application/json',
    });

    final token = await _getToken();
    request.headers['Authorization'] = 'Bearer $token';

    try {
      // Send the request
      var response = await request.send();
      final responseBody = await response.stream.bytesToString();

      print('Response Status Code: ${response.statusCode}');
      print('Response Body: $responseBody');



      // Check for success response
      if (response.statusCode == 200) {
        print('Profile updated successfully!');
      } else {
        var responseBody = await http.Response.fromStream(response);
        print('Error Response: ${responseBody.body}');
        throw Exception('Failed to update service provider profile. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Exception: $e');
      throw Exception('Update error: $e');
    }
  }


  Future<Map<String, dynamic>> fetchCustomerProfile() async {
    final url = Uri.parse('$baseUrl/profile');
    final token = await _getToken();

    try {
      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body); // Parse the response and return it
      } else {
        throw Exception('Failed to fetch profile: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching profile: $e');
    }
  }


  Future<void> updateCustomerProfile({
    String? firstName,
    String? lastName,
    String? phoneNumber,
    String? address,
    String? city,
  }) async {
    final url = Uri.parse('$baseUrl/customer/profile');


    Map<String, dynamic> profileData = {
      if (firstName != null) 'first_name': firstName,
      if (lastName != null) 'last_name': lastName,
      if (phoneNumber != null) 'phone_number': phoneNumber,
      if (address != null) 'address': address,
      if (city != null) 'city': city,
    };
    final token = await _getToken();

    try {
      final response = await http.put(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode(profileData),
      );

      if (response.statusCode != 200) {
        throw Exception('Failed to update profile: ${response.body}');
      }
    } catch (e) {
      print('Error during updating customer profile: $e');
      throw Exception('Update error: $e');
    }
  }
}
