class AppointmentModel {
  final int? id;
  final int customerId;
  final int serviceProviderId;
  final String? serviceProviderName; // Nullable to handle cases where it's not used
  final String startTime;
  final String? notes;
  final String? customerphoneNumber;
  final String? serviceproviderphoneNumber;
  final String serviceType;
  final String status;
  final String paymentStatus;
  final double latitude;
  final double longitude;
  final String? customerName;
  final bool? rejectionSeen;
  final String? declinedReason;
  final String? proofImage; // Add proof image path
  final String? completedAt; // Add completed at timestamp
  final bool? hasReview; // Add this field to capture if a review exists
  final String? proofImageUrl; // This is the full URL for the proof image
  final String? location;
  final String? spProfileImage; // Add proof image path



  AppointmentModel({
    this.id,
    required this.customerId,
    required this.serviceProviderId,
    this.serviceProviderName, // Nullable
    required this.startTime,
    this.notes,
    this.customerphoneNumber,
    this.serviceproviderphoneNumber,
    this.hasReview,
    required this.serviceType,
    required this.status,
    required this.paymentStatus,
    required this.latitude, // Include latitude in constructor
    required this.longitude, // Include longitude in constructor
    this.customerName,
    this.rejectionSeen,
    this.declinedReason,
    this.proofImage, // Initialize proof image
    this.completedAt, // Initialize completed at timestamp
    this.proofImageUrl, // Full URL for proof image
    this.location,
    this.spProfileImage
  });

  // Factory method to create an instance of the model from a JSON object
  factory AppointmentModel.fromJson(Map<String, dynamic> json) {
    final baseUrl = "http://10.0.2.2:8000"; // Base URL for your API

    // Parse the values
    return AppointmentModel(
      id: json['id'] ?? 0,
      customerId: json['customer_id'] ?? 0,
      serviceProviderId: json['serviceprovider_id'] ?? 0,
      serviceProviderName: json['service_provider_name'],
      startTime: json['start_time'] ?? '',
      notes: json['notes'],
      customerphoneNumber: json['customer_phone'],
      serviceproviderphoneNumber: json['service_provider_phone'],
      hasReview: (json['has_review'] == true), // Convert to bool
      serviceType: json['service_type'] ?? '',
      status: json['status'] ?? 'pending',
      paymentStatus: json['payment_status'] ?? 'unpaid',
      latitude: (json['latitude'] ?? 0).toDouble(),
      longitude: (json['longitude'] ?? 0).toDouble(),
      customerName: json['customer_name'],
      rejectionSeen: (json['rejection_seen'] == 1), // Convert int (1 or 0) to bool
      declinedReason: json['declined_reason'],
      proofImage: json['proof_image'], // Original proof image path
      completedAt: json['completed_at'], // Completed_at timestamp
      // Construct the full proof image URL
      proofImageUrl: json['proof_image'] != null ? "$baseUrl/storage/${json['proof_image']}" : null,
      location: json['location'],
      spProfileImage: json['service_provider_profile_image'],


    );
  }
}
