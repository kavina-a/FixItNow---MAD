class AnalyticsModel {
  final int completedAppointments;
  final int rejectedAppointments;  // New field for rejected appointments
  final double averageRating;  // Nullable rating
  final int totalReviews;
  final List<WeeklyForecast> monthlyForecast;  // New field for the weekly forecast

  AnalyticsModel({
    required this.completedAppointments,
    required this.rejectedAppointments,
    required this.averageRating,
    required this.totalReviews,
    required this.monthlyForecast,
  });

  // Factory method to create an instance from JSON
  factory AnalyticsModel.fromJson(Map<String, dynamic> json) {
    var forecastJson = json['monthly_forecast'] as List<dynamic>? ?? [];
    List<WeeklyForecast> forecastList = forecastJson.map((item) {
      return WeeklyForecast.fromJson(item);
    }).toList();

    return AnalyticsModel(
      completedAppointments: json['completed_appointments'] != null
          ? json['completed_appointments']
          : 0,  // Default to 0 if null
      rejectedAppointments: json['rejected_appointments'] != null
          ? json['rejected_appointments']
          : 0,  // Default to 0 if null
      averageRating: (json['average_rating'] ?? 0.0).toDouble(),  // Default to 0.0 if null
      totalReviews: json['total_reviews'] != null
          ? json['total_reviews']
          : 0,  // Default to 0 if null
      monthlyForecast: forecastList,
    );
  }
}

class WeeklyForecast {
  final String weekStart;
  final String weekEnd;
  final int totalAppointments;

  WeeklyForecast({
    required this.weekStart,
    required this.weekEnd,
    required this.totalAppointments,
  });

  factory WeeklyForecast.fromJson(Map<String, dynamic> json) {
    return WeeklyForecast(
      weekStart: json['week_start'] ?? '',
      weekEnd: json['week_end'] ?? '',
      totalAppointments: json['totalAppointments'] ?? 0,  // Default to 0 if null
    );
  }
}
