import 'dart:convert';

class ServiceProviderModel {
  final int id;
  final int userId;
  final String firstName;
  final String lastName;
  final String phoneNumber;
  final String address;
  final String city;
  final List<String> serviceType; // Change to List<String>
  final int yearsOfExperience;
  final bool availability;
  final String description;
  final List<String> languages; // Change to List<String>
  final String profileImage;

  ServiceProviderModel({
    required this.id,
    required this.userId,
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
    required this.profileImage,
  });

  factory ServiceProviderModel.fromJson(Map<String, dynamic> json) {
    return ServiceProviderModel(
      id: json['id'],
      userId: json['user_id'],
      firstName: json['first_name'],
      lastName: json['last_name'],
      phoneNumber: json['phone_number'],
      address: json['address'],
      city: json['city'],
      // Decode the service_type string into a List<String>
      serviceType: List<String>.from(jsonDecode(json['service_type'])),
      yearsOfExperience: json['years_of_experience'],
      availability: json['availability'],
      description: json['description'],
      // Decode the languages string into a List<String>
      languages: List<String>.from(jsonDecode(json['languages'])),
      profileImage: json['profile_image'],
    );
  }
}
