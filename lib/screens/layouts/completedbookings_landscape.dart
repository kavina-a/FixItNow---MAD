import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // For date formatting
import '../../../models/appointment_model.dart'; // Import AppointmentModel
import '../../../services/booking_service.dart'; // Import Appointment Service
import '../../services/ratings&reviews-service.dart'; // Import Rating and Review Service
import 'package:fixitnow/screens/widgets/styles.dart';
import '../activity/widgets/activity_appbar.dart'; // Styles (custom for your app)

class CompletedBookingsLandscape extends StatefulWidget {
  const CompletedBookingsLandscape({Key? key}) : super(key: key);

  @override
  _CompletedBookingsLandscapeState createState() => _CompletedBookingsLandscapeState();
}

class _CompletedBookingsLandscapeState extends State<CompletedBookingsLandscape> {
  late Future<List<AppointmentModel>> _completedAppointments;

  @override
  void initState() {
    super.initState();
    _completedAppointments = AppointmentService()
        .getCompletedAppointments(); // Fetch completed appointments
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const ActivityAppBar(), // AppBar added here
          Expanded(
            child: FutureBuilder<List<AppointmentModel>>(
              future: _completedAppointments,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(
                      child: Text('No completed bookings available'));
                }

                final completedAppointments = snapshot.data!;

                return GridView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 1, // Display 2 items per row in landscape
                    crossAxisSpacing: 16.0,
                    mainAxisSpacing: 16.0,
                    childAspectRatio: 2.5, // Adjust to your preference
                  ),
                  itemCount: completedAppointments.length,
                  itemBuilder: (context, index) {
                    final appointment = completedAppointments[index];
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10.0),
                      child: completedList(
                        'Completed Booking',
                        appointment.spProfileImage,
                        appointment.serviceType,
                        appointment.serviceProviderName ?? 'Unknown',
                        _formatDateTime(appointment.startTime),
                        _formatDateTime(appointment.completedAt ?? ''),
                        context,
                        appointment.id ?? 0,
                        appointment.serviceProviderId ?? 0,
                        appointment.hasReview ?? false,
                        appointment.proofImage,
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  // Helper function to format the date and time in a user-friendly format
  String _formatDateTime(String dateTime) {
    try {
      // Parse the input date string
      DateTime parsedDate = DateTime.parse(dateTime);
      // Format to something like "24th June, 2:00 PM"
      return DateFormat('d MMMM, h:mm a').format(parsedDate);
    } catch (e) {
      // In case of an error (invalid date), return the original string
      return dateTime;
    }
  }

  Widget completedList(String title,
      String? spProfileImage,
      String serviceType,
      String name,
      String arrivalTime,
      String completedTime,
      BuildContext context,
      int appointmentId, // Appointment ID for the rating
      int serviceProviderId, // Service provider ID for the rating
      bool hasReview, // Check if a review has been submitted
      String? proofImageUrl, // Add proof image URL as a parameter
      ) {
    Color borderColor = Theme
        .of(context)
        .colorScheme
        .onSurface
        .withOpacity(0.5);
    Color backgroundColor = Theme
        .of(context)
        .colorScheme
        .primary
        .withOpacity(0.3);

    return Container(
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(12.0),
        border: Border.all(
          color: borderColor,
          width: 1.0,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            decoration: BoxDecoration(
              color: Colors.lightGreen.withOpacity(0.3),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(12.0),
                topRight: Radius.circular(12.0),
              ),
            ),
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  title,
                  style: TextStyles.customTextStyle,
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(
                horizontal: 16.0, vertical: 12.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      radius: 45,
                      backgroundColor: Colors.white38.withOpacity(0.1),
                      backgroundImage: spProfileImage != null &&
                          spProfileImage.isNotEmpty
                          ? NetworkImage(spProfileImage) as ImageProvider
                          : const AssetImage('assets/default_image.png'),
                      onBackgroundImageError: (error, stackTrace) {
                        print('Error loading profile image: $error');
                      },
                    ),
                    const SizedBox(width: 10),
                    Text(
                      '$name - $serviceType',
                      // Display service provider's name and service type
                      style: TextStyles.bodyLarge,
                    ),
                  ],
                ),
                Row(
                  children: [
                    // Check if proofImageUrl is non-null and non-empty
                    if (proofImageUrl != null && proofImageUrl.isNotEmpty)
                      IconButton(
                        icon: const Icon(Icons.image),
                        onPressed: () {
                          _showProofImage(context,
                              proofImageUrl); // Show the image when button is pressed
                        },
                      ),
                    // Icon to Add Review, only shown if the user hasn't submitted a review
                    IconButton(
                      icon: const Icon(Icons.rate_review),
                      onPressed: hasReview
                          ? null // Disable the button if review is already submitted
                          : () {
                        _showRatingReviewDialog(context, appointmentId,
                            serviceProviderId); // Show the review dialog
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(
                horizontal: 16.0, vertical: 12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 8),
                const Divider(height: 1, thickness: 0.3),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Arrival Time:'),
                      Expanded(
                        child: Text(
                          _formatDateTime(arrivalTime),
                          // Use formatted time here
                          textAlign: TextAlign.right,
                          style: TextStyles.bodyMedium,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 8),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Completed Time'),
                      Expanded(
                        child: Text(
                          completedTime,
                          textAlign: TextAlign.right,
                          style: TextStyles.bodyMedium,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Function to show the rating and review dialog
  void _showRatingReviewDialog(BuildContext context, int appointmentId,
      int serviceProviderId) {
    final TextEditingController _reviewController = TextEditingController();
    int _rating = 5; // Default rating value

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Add Rating and Review'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('Rate the service:'),
              DropdownButton<int>(
                value: _rating,
                items: [1, 2, 3, 4, 5].map((value) {
                  return DropdownMenuItem<int>(
                    value: value,
                    child: Text(value.toString()),
                  );
                }).toList(),
                onChanged: (value) {
                  _rating = value!;
                },
              ),
              TextField(
                controller: _reviewController,
                decoration: const InputDecoration(
                    labelText: 'Write your review (Optional)'),
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Submit'),
              onPressed: () async {
                try {
                  await RatingsAndReviewsService().addRatingAndReview(
                    serviceProviderId: serviceProviderId,
                    appointmentId: appointmentId,
                    rating: _rating,
                    review: _reviewController.text,
                  );
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content: Text('Review submitted successfully!')),
                  );
                  Navigator.of(context).pop(); // Close the dialog
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Failed to submit review: $e')),
                  );
                }
              },
            ),
          ],
        );
      },
    );
  }

  void _showProofImage(BuildContext context, String proofImageUrl) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          contentPadding: EdgeInsets.zero,
          content: Column(
            mainAxisSize: MainAxisSize.min,
            // Prevents the dialog from expanding too much
            children: [
              // Constrain the size of the image
              Container(
                constraints: BoxConstraints(
                  maxWidth: MediaQuery
                      .of(context)
                      .size
                      .width * 2, // 90% of screen width
                  maxHeight: MediaQuery
                      .of(context)
                      .size
                      .height * 0.5, // 50% of screen height
                ),
                child: Image.network(
                  proofImageUrl,
                  fit: BoxFit
                      .contain, // Ensure the image fits within the container
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              child: const Text('Close'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}

