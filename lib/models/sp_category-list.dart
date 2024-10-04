class CategoryServiceProviderList {
  final int id;
  final String firstName;
  final String lastName;
  final String? profileImage;  // Nullable profile image
  final List<String> serviceType;
  final String distance;  // Distance field
  final String estimatedTime;  // Estimated time field

  CategoryServiceProviderList({
    required this.id,
    required this.firstName,
    required this.lastName,
    this.profileImage,  // Nullable
    required this.serviceType,
    required this.distance,  // Include distance in the constructor
    required this.estimatedTime,  // Include estimated time in the constructor
  });

  // Factory constructor to handle the JSON parsing
  factory CategoryServiceProviderList.fromJson(Map<String, dynamic> json) {
    return CategoryServiceProviderList(
      id: json['id'],
      firstName: json['first_name'],
      lastName: json['last_name'],
      profileImage: json['profile_image'],  // Nullable, so handled safely
      serviceType: List<String>.from(json['service_type']),  // Directly from JSON as a list
      distance: json['distance'],  // Parse distance from JSON
      estimatedTime: json['estimated_time'],  // Parse estimated time from JSON
    );
  }
}
