import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

import '../models/ratingsandreviews_model.dart';

class RatingsAndReviewsService {
  final String baseUrl = "http://10.0.2.2:8000/api"; // Use for Android emulator

  final FlutterSecureStorage storage = FlutterSecureStorage();

  // Helper function to get the token
  Future<String?> _getToken() async {
    return await storage.read(key: 'token');
  }

  // Method to add a rating and review
  Future<RatingsAndReviewsModel> addRatingAndReview({

    required int serviceProviderId,
    required int appointmentId,
    required int rating,
    String? review,

  }) async {
    final url = Uri.parse('$baseUrl/rating-review');

    // Get the token
    final token = await _getToken();
    if (token == null) {
      throw Exception('No token found');
    }

    // Make the HTTP POST request to add rating and review
    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({
        'serviceprovider_id': serviceProviderId,
        'appointment_id': appointmentId,
        'rating': rating,
        'review': review,
      }),
    );

    // Check for success response
    if (response.statusCode != 201) {
      throw Exception('Failed to submit rating and review: ${response.body}');
    }

    // Parse the response into a RatingsAndReviewsModel
    final data = jsonDecode(response.body);
    return RatingsAndReviewsModel.fromJson(data['ratingReview']);
  }

  // Method to get all ratings and reviews for a specific service provider
  Future<List<RatingsAndReviewsModel>> getServiceProviderRatingsAndReviews(
      int serviceProviderId) async {
    final url = Uri.parse(
        '$baseUrl/service-provider/$serviceProviderId/ratings-reviews');

    // Get the token
    final token = await _getToken();
    if (token == null) {
      throw Exception('No token found');
    }

    // Make the HTTP GET request to fetch ratings and reviews
    final response = await http.get(
      url,
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    // Check for success response
    if (response.statusCode != 200) {
      throw Exception('Failed to fetch ratings and reviews: ${response.body}');
    }

    // Parse the response into a list of RatingsAndReviewsModel
    final data = jsonDecode(response.body);
    print(data);

    return (data['ratingReview'] as List)
        .map((reviewJson) => RatingsAndReviewsModel.fromJson(reviewJson))
        .toList();
  }


  Future<List<RatingsAndReviewsModel>> getMyRatingsAndReviews() async {
    final url = Uri.parse('$baseUrl/my-ratings-reviews'); // No ID needed

    // Get the token
    final token = await _getToken();
    if (token == null) {
      print("No token found");
      throw Exception('No token found');
    }

    print("Token found: $token");

    // Make the HTTP GET request to fetch ratings and reviews
    final response = await http.get(
      url,
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    print("Response status code: ${response.statusCode}");
    print("Response body: ${response.body}");

    // Check for success response
    if (response.statusCode != 200) {
      throw Exception('Failed to fetch ratings and reviews: ${response.body}');
    }

    // Parse the response into a list of RatingsAndReviewsModel
    final data = jsonDecode(response.body);

    // Correct key is 'myRatingsReviews'
    if (data['myRatingsReviews'] == null ||
        (data['myRatingsReviews'] as List).isEmpty) {
      print("No ratings found in response");
      return [];
    }

    print("Ratings found: ${data['myRatingsReviews']}");

    return (data['myRatingsReviews'] as List)
        .map((reviewJson) => RatingsAndReviewsModel.fromJson(reviewJson))
        .toList();
  }

}

