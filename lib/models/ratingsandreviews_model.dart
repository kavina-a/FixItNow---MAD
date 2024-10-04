class RatingsAndReviewsModel {
  final int? id;
  final int? customerId;
  final int? serviceProviderId;
  final int? appointmentId;
  final int? rating;
  final String review; // Make review nullable
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final String? customerName;  // New field for customer's name
  final String? appointmentLocation;  // New field for appointment location


  RatingsAndReviewsModel({
    this.id,
    this.customerId,
    this.serviceProviderId,
    this.appointmentId,
    this.rating,
    required this.review, // Now review is nullable
    this.createdAt,
    this.updatedAt,
    this.customerName,
    this.appointmentLocation
  });

  // Factory method to create an instance of the model from a JSON object
  factory RatingsAndReviewsModel.fromJson(Map<String, dynamic> json) {
    return RatingsAndReviewsModel(
      id: json['id'],
      customerId: json['customer_id'],
      serviceProviderId: json['serviceprovider_id'],
      appointmentId: json['appointment_id'],
      rating: json['rating'],
      review: json['review'], // Nullable
      createdAt: json['created_at'] != null ? DateTime.parse(json['created_at']) : null,
      updatedAt: json['updated_at'] != null ? DateTime.parse(json['updated_at']) : null,
      customerName: json['customer_name'], // Nullable
      appointmentLocation: json['appointment_location'], // Nullable

    );
  }

  // Method to convert model to JSON for sending to the server
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'customer_id': customerId,
      'serviceprovider_id': serviceProviderId,
      'appointment_id': appointmentId,
      'rating': rating,
      'review': review, // Ensure this is nullable
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }
}
