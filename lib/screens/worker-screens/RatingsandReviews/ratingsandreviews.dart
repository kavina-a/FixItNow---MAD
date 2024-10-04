import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../../models/ratingsandreviews_model.dart';
import '../../../services/ratings&reviews-service.dart';
import '../../widgets/styles.dart'; // Assuming the TextStyles.primaryColor is defined here.
import 'package:intl/intl.dart';

class ServiceProviderRatingsAndReviewsScreen extends StatefulWidget {
  const ServiceProviderRatingsAndReviewsScreen({super.key});

  @override
  _ServiceProviderRatingsAndReviewsScreenState createState() => _ServiceProviderRatingsAndReviewsScreenState();
}

class _ServiceProviderRatingsAndReviewsScreenState extends State<ServiceProviderRatingsAndReviewsScreen> {
  late Future<List<RatingsAndReviewsModel>> _ratingsAndReviews;

  @override
  void initState() {
    super.initState();
    _ratingsAndReviews = RatingsAndReviewsService().getMyRatingsAndReviews();
  }

  String _formatDateTime(String dateTime) {
    try {
      // Parse the input date string
      DateTime parsedDate = DateTime.parse(dateTime);

      // Format to something like "2nd 12PM"
      String day = DateFormat('d').format(parsedDate);
      String suffix = _getDaySuffix(int.parse(day));
      String formattedTime = DateFormat('h a').format(parsedDate); // "12 PM"

      return '$day$suffix $formattedTime';
    } catch (e) {
      // In case of an error (invalid date), return the original string
      return dateTime;
    }
  }

// Helper function to get day suffix (st, nd, rd, th)
  String _getDaySuffix(int day) {
    if (day >= 11 && day <= 13) {
      return 'th';
    }
    switch (day % 10) {
      case 1:
        return 'st';
      case 2:
        return 'nd';
      case 3:
        return 'rd';
      default:
        return 'th';
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Ratings & Reviews'),
      ),
      body: FutureBuilder<List<RatingsAndReviewsModel>>(
        future: _ratingsAndReviews,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(
              child: Text('No ratings or reviews yet.'),
            );
          }

          final ratingsAndReviews = snapshot.data!;

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: ratingsAndReviews.length,
            itemBuilder: (context, index) {
              final review = ratingsAndReviews[index];

              return _buildReviewCard(review);
            },
          );
        },
      ),
    );
  }



  // Build a custom review card
  Widget _buildReviewCard(RatingsAndReviewsModel review) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      margin: const EdgeInsets.symmetric(vertical: 12),
      // Set card color based on theme (dark or light)
      color: Theme.of(context).brightness == Brightness.dark
          ? Colors.grey[850] // Dark mode - darker grey
          : Colors.grey[200], // Light mode - lighter grey
      child: Padding(
        padding: const EdgeInsets.all(25),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(review),
            const SizedBox(height: 8),
            _buildRatingRow(review),
            const SizedBox(height: 12),
            _buildReviewText(review),
          ],
        ),
      ),
    );
  }


  // Header with customer name and review date
  Widget _buildHeader(RatingsAndReviewsModel review) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'Customer - ${review.customerName ?? 'Unknown Customer'}', // Display the customer name
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        Row(
          children: [
            const Icon(Icons.calendar_today, size: 16, color: Colors.grey), // Date emoji icon
            const SizedBox(width: 4), // Space between icon and date
            Text(
              _formatDateTime(review.createdAt.toString()), // Display the formatted date
              style: const TextStyle(
                color: Colors.grey,
                fontSize: 12,
              ),
            ),

          ],
        ),
      ],
    );
  }

  // Row with rating and location
  Widget _buildRatingRow(RatingsAndReviewsModel review) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // Display rating with star icons
        Row(
          children: [
            const Icon(Icons.star, color: Colors.orangeAccent, size: 18),
            const SizedBox(width: 4),
            Text(
              review.rating.toString(), // Rating value
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ],
        ),

        // Location details with location icon
        Row(
          children: [
            const Icon(Icons.location_on, size: 16, color: Colors.grey), // Location emoji icon
            const SizedBox(width: 4), // Space between icon and location
            Text(
              review.appointmentLocation ?? 'Unknown Location', // Display appointment location
              style: TextStyle(
                color: TextStyles.primaryColor.withOpacity(0.7), // Using faded primary color
                fontSize: 14,
              ),
            ),
          ],
        ),
      ],
    );
  }

  // Display the review text
  Widget _buildReviewText(RatingsAndReviewsModel review) {
    return Text(
      review.review.isNotEmpty ? review.review : 'No review message provided.',
      style: TextStyle(
        fontSize: 14,
        color: Theme.of(context).brightness == Brightness.dark
            ? Colors.white // White for dark mode
            : Colors.black87, // Black for light mode
      ),
    );
  }
}
