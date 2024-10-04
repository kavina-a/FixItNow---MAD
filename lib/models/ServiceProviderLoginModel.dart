class ServiceProviderLoginModel {
  final int id;
  final String firstName;
  final String lastName;
  final String phoneNumber;
  final String address;
  final String city;
  final List<String> serviceType;
  final int? yearsOfExperience; // Nullable field
  final bool availability;
  final String description;
  final List<String> languages;
  final String? profileImage; // Nullable field

  ServiceProviderLoginModel({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.phoneNumber,
    required this.address,
    required this.city,
    required this.serviceType,
    this.yearsOfExperience, // Nullable
    required this.availability,
    required this.description,
    required this.languages,
    this.profileImage, // Nullable
  });

  factory ServiceProviderLoginModel.fromJson(Map<String, dynamic> json) {
    return ServiceProviderLoginModel(
      id: json['id'], // Use `id` from the profile
      firstName: json['first_name'],
      lastName: json['last_name'],
      phoneNumber: json['phone_number'],
      address: json['address'],
      city: json['city'],
      serviceType: List<String>.from(json['service_type'] ?? []), // Handle empty or null serviceType
      yearsOfExperience: json['years_of_experience'], // Can be null
      availability: json['availability'],
      description: json['description'],
      languages: List<String>.from(json['languages'] ?? []), // Handle empty or null languages
      profileImage: json['profile_image'], // Can be null
    );
  }

  // Convert back to JSON, if necessary
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'first_name': firstName,
      'last_name': lastName,
      'phone_number': phoneNumber,
      'address': address,
      'city': city,
      'service_type': serviceType,
      'years_of_experience': yearsOfExperience,
      'availability': availability,
      'description': description,
      'languages': languages,
      'profile_image': profileImage,
    };
  }
}
