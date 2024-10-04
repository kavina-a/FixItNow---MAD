import 'package:fixitnow/screens/widgets/styles.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // Import for date formatting
import '../../../models/appointment_model.dart'; // Import your AppointmentModel
import '../../../services/booking_service.dart'; // Import the API service

class ActivityCompletedList extends StatefulWidget {
  const ActivityCompletedList({super.key});

  @override
  _ActivityCompletedListState createState() => _ActivityCompletedListState();
}

class _ActivityCompletedListState extends State<ActivityCompletedList> {
  late Future<List<AppointmentModel>> _completedAppointments;

  @override
  void initState() {
    super.initState();
    _completedAppointments = AppointmentService().getCompletedAppointments(); // Fetch completed appointments
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<AppointmentModel>>(
      future: _completedAppointments,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(),
          );
        } else if (snapshot.hasError) {
          return Center(
            child: Text('Error: ${snapshot.error}'),
          );
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return SizedBox.shrink(); // No completed appointments
        }

        final completedAppointments = snapshot.data!;

        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 60, horizontal: 24),
          child: Column(
            children: completedAppointments.map((appointment) {
              return Column(
                children: [
                  completedList(
                    'Completed Booking',
                    appointment.serviceType,
                    appointment.spProfileImage ?? 'null',  // Placeholder image, replace with actual if available
                    appointment.serviceProviderName ?? 'Unknown',  // Service Provider's name
                    appointment.startTime,  // Start time
                    'need to figure out backend',  // Placeholder for end time, replace with real data
                    context,
                  ),
                  SizedBox(height: 40),
                ],
              );
            }).toList(),
          ),
        );
      },
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

  // This is the widget that displays each completed appointment
  Widget completedList(
      String title,
      String serviceType,
      String imagePath,
      String name,
      String arrivalTime,
      String completedTime,
      BuildContext context) {
    Color borderColor = Theme.of(context).colorScheme.onSurface.withOpacity(0.5);
    Color backgroundColor = Theme.of(context).colorScheme.primary.withOpacity(0.3);

    return Container(
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(12.0), // Rounded corners
        border: Border.all(
          color: borderColor, // Border color
          width: 1.0, // Border width
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            decoration: BoxDecoration(
              color: Colors.lightGreen.withOpacity(0.3),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(12.0),
                topRight: Radius.circular(12.0),
              ),
            ),
            padding: EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  title,
                  style: TextStyles.customTextStyle,
                ),
                // Text(
                //   amount,
                //   style: TextStyles.customTextStyle,
                // ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      radius: 45,
                      backgroundColor: Colors.white38.withOpacity(0.1),
                      backgroundImage: imagePath.isNotEmpty
                          ? NetworkImage(imagePath) as ImageProvider
                          : const AssetImage('assets/default_image.png'),
                      onBackgroundImageError: (error, stackTrace) {
                        print('Error loading profile image: $error');
                      },
                    ),

                    SizedBox(width: 10),
                    Text(
                      '$name - $serviceType',  // Display service provider's name and service type
                      style: TextStyles.bodyLarge,
                    ),
                  ],
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
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
                          _formatDateTime(arrivalTime), // Use formatted time here
                          textAlign: TextAlign.right,
                          style: TextStyles.bodyMedium,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 8),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Completed Time'),
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
}
