import 'dart:convert';

import 'package:fixitnow/models/ratingsandreviews_model.dart';

class ServiceProviderDetail {
  final int id;
  final String firstName;
  final String lastName;
  final String phoneNumber;
  final String address;
  final String city;
  final List<String> serviceType;
  final int yearsOfExperience;
  final bool availability;
  final String description;
  final List<String> languages;
  final String? profileImage;

  final String? distance;
  final String? estimatedTime;
  final List<RatingsAndReviewsModel>? ratingsAndReviews; // Nullable field for ratings and reviews


  // Constructor
  ServiceProviderDetail({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.phoneNumber,
    required this.address,
    required this.city,
    required this.serviceType,
    required this.yearsOfExperience,
    required this.availability,
    required this.description,
    required this.languages,
    this.profileImage,
    this.distance,
    this.estimatedTime,
    this.ratingsAndReviews,

  });

  // Factory constructor to create a ServiceProviderDetail from JSON
  factory ServiceProviderDetail.fromJson(Map<String, dynamic> json) {
    // No need to decode arrays since they are already in array format in the API response
    List<String> serviceTypeList = List<String>.from(json['service_type']);
    List<String> languagesList = List<String>.from(json['languages']);

    List<RatingsAndReviewsModel>? ratingsAndReviews;
    if (json['ratings_reviews'] != null) {
      ratingsAndReviews = List<RatingsAndReviewsModel>.from(
        json['ratings_reviews'].map((review) => RatingsAndReviewsModel.fromJson(review)),
      );
    }

    return ServiceProviderDetail(
      id: json['id'],
      firstName: json['first_name'],
      lastName: json['last_name'],
      phoneNumber: json['phone_number'],
      address: json['address'],
      city: json['city'],
      serviceType: serviceTypeList,
      yearsOfExperience: json['years_of_experience'],
      availability: json['availability'],
      description: json['description'],
      languages: languagesList,
      profileImage: json['profile_image'],  // This can be null
      distance: json['distance'],  // Parse distance from response
      estimatedTime: json['estimated_time'],  // Parse estimated time from response
      ratingsAndReviews: ratingsAndReviews, // Parse ratings and reviews

    );
  }
}
