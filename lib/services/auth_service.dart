import 'dart:convert';
import 'dart:io';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import '../models/ServiceProviderLoginModel.dart';
import '../models/customer_model.dart';
import '../models/serviceprovider_model.dart';
import '../models/user_model.dart';  // Import the UserModel

class AuthService {
  final FlutterSecureStorage storage = FlutterSecureStorage();
  final String baseUrl = "http://10.0.2.2:8000/api"; // Use for Android emulator


  Future<UserModel> registerCustomer({

    //The method accepts user registration details,
    // sends them to the backend, and returns a UserModel object
    // if the registration is successful

    required String email,
    required String password,
    required String firstName,
    required String lastName,
    required String phoneNumber,
    required String address,
    required String city,

  }) async {
    final url = Uri.parse('$baseUrl/register-customer');

    // Create a map to represent the user registration data
    // Key value pair so when a user enters data it assigns and is sent
    Map<String, dynamic> userData = {
      'email': email,
      'password': password,
      'first_name': firstName,
      'last_name': lastName,
      'phone_number': phoneNumber,
      'address': address,
      'city': city,
    };

    try {
      // Send POST request with the user registration data
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode(userData), // Send the user data as JSON
      );

      if (response.statusCode == 201) {
        // Parse the response body into a UserModel
        return UserModel.fromJson(jsonDecode(response.body)['user']);
      } else {
        // Print error details for debugging
        print('Failed with status code: ${response.statusCode}');
        print('Response body: ${response.body}');
        throw Exception(
            'Failed to register customer with status code: ${response
                .statusCode}');
      }
    } catch (e) {
      // Catch any other errors that might occur
      print('Error during registration: $e');
      throw Exception('Registration error: $e');
    }
  }
  Future<Map<String, dynamic>> loginUser({
    required String email,
    required String password,
  }) async {
    final url = Uri.parse('$baseUrl/login');

    Map<String, dynamic> loginData = {
      'email': email,
      'password': password,
    };

    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode(loginData),
      );

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        // Parse the user data
        final user = UserModel.fromJson(data['user']);
        final String token = data['token'];

        await storeTokenSecurely(token); // Storing the token
        print('Token stored: $token');

        // Check the role of the user and parse the appropriate profile
        if (user.role == 'customer') {
          final customer = CustomerModel.fromJson(data['profile']);
          return {
            'user': user,
            'profile': customer,
            'token': token,
          };
        } else if (user.role == 'service_provider') {
          final serviceProvider = ServiceProviderLoginModel.fromJson(data['profile']);
          return {
            'user': user,
            'profile': serviceProvider,
            'token': token,
          };
        } else {
          throw Exception('Unknown role: ${user.role}');
        }
      } else {
        throw Exception('Failed to log in with status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error during login: $e');
      throw Exception('Login error: $e');
    }
  }

  Future<void> storeTokenSecurely(String token) async {
    await storage.write(key: 'token', value: token);
  }


  Future<UserModel> registerServiceProvider({
    required String email,
    required String password,
    required String firstName,
    required String lastName,
    required String phoneNumber,
    required String address,
    required String city,
    required List<String> serviceType,
    required int yearsOfExperience,
    required String description,
    required List<String> languages,
    File? profileImage,  // Add profile image as a parameter
  }) async {
    final url = Uri.parse('$baseUrl/register/service-provider');

    print('Registering service provider...');
    print('URL: $url');
    print('Email: $email');
    print('First Name: $firstName');
    print('Last Name: $lastName');
    print('Years of Experience: $yearsOfExperience');
    print('Service Types: $serviceType');
    print('Languages: $languages');

    var request = http.MultipartRequest('POST', url);

    // Add user data fields
    request.fields['email'] = email;
    request.fields['password'] = password;
    request.fields['first_name'] = firstName;
    request.fields['last_name'] = lastName;
    request.fields['phone_number'] = phoneNumber;
    request.fields['address'] = address;
    request.fields['city'] = city;
    request.fields['years_of_experience'] = yearsOfExperience.toString();
    request.fields['description'] = description;

    // Add service_type as multiple form-data fields
    for (String type in serviceType) {
      request.fields['service_type[]'] = type;
    }

    // Add languages as multiple form-data fields
    for (String lang in languages) {
      request.fields['languages[]'] = lang;
    }

    // Add profile image if selected
    if (profileImage != null) {
      print('Adding profile image to the request: ${profileImage.path}');
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

    try {
      // Send the request
      var response = await request.send();

      // Check for success response
      if (response.statusCode == 201) {
        var responseBody = await http.Response.fromStream(response);
        final data = jsonDecode(responseBody.body);
        return UserModel.fromJson(data['user']);
      } else {
        var responseBody = await http.Response.fromStream(response);
        print('Error Response: ${responseBody.body}');
        throw Exception('Failed to register service provider. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Exception: $e');
      throw Exception('Registration error: $e');
    }
  }
}