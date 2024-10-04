class ServiceProviderAvailability {
  bool isAvailable;

  ServiceProviderAvailability({required this.isAvailable});

  // Factory method to create a ServiceProvider from JSON
  factory ServiceProviderAvailability.fromJson(Map<String, dynamic> json) {
    return ServiceProviderAvailability(
      isAvailable: json['isAvailable'],
    );
  }

  // Method to convert ServiceProvider object to JSON
  Map<String, dynamic> toJson() {
    return {
      'isAvailable': isAvailable,
    };
  }
}
