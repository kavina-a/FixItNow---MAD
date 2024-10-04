import 'package:flutter/material.dart';
import 'package:fixitnow/screens/widgets/styles.dart';
import '../../../models/appointment_model.dart';
import '../../../services/booking_service.dart';
import 'package:intl/intl.dart';


class PendingAppointmentsScreen extends StatefulWidget {
  @override
  _PendingAppointmentsScreenState createState() => _PendingAppointmentsScreenState();
}

class _PendingAppointmentsScreenState extends State<PendingAppointmentsScreen> {
  late Future<List<AppointmentModel>> _pendingAppointments;

  @override
  void initState() {
    super.initState();
    _pendingAppointments = AppointmentService().getPendingAppointments();
  }

  // Helper function to format the date and time in a user-friendly format
  String _formatDateTime(String dateTime) {
    try {
      // Parse the input date string
      DateTime parsedDate = DateTime.parse(dateTime);

      // Format to something like "23rd September, 12:00 PM"
      return DateFormat('d MMMM, h:mm a').format(parsedDate);
    } catch (e) {
      // In case of an error (invalid date), return the original string
      return dateTime;
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<AppointmentModel>>(
      future: _pendingAppointments,
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
          // If there are no pending appointments, return nothing (make it invisible)
          return SizedBox.shrink();
        }

        // If there are pending appointments, display them in the list
        final appointments = snapshot.data!;

        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 60, horizontal: 24),
          child: Column(
            children: appointments.map((appointment) {
              return Column(
                children: [
                  pendingList(
                    'Request Pending',
                    appointment.spProfileImage,  // Placeholder image, you can change this
                    '${appointment.serviceType}',
                    appointment.serviceProviderName ?? 'Unknown Provider',  // Use first_name
                    '4.9',  // Assuming rating, you can adjust this based on your data
                    appointment.startTime,
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

  // This is the widget that displays each pending appointment
  Widget pendingList(
      String title,
      String? imagePath,
      String type,
      String name,
      String rating,
      String arrivalTime,
      ) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12.0), // Rounded corners
        border: Border.all(
          color: Colors.grey.withOpacity(0.5), // Border color
          width: 1.0, // Border width
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            decoration: BoxDecoration(
              color: Colors.deepPurpleAccent.withOpacity(0.6),
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
                      radius: 25,
                      backgroundImage: imagePath != null && imagePath.isNotEmpty
                          ? NetworkImage(imagePath) as ImageProvider
                          : const AssetImage('assets/default_image.png'), // Fallback to a placeholder image
                      onBackgroundImageError: (error, stackTrace) {
                        print('Error loading profile image: $error');
                      },
                    ),
                    SizedBox(width: 10),
                    Text(
                      '${name} - ${type}',  // Display first_name (serviceProviderName)
                      style: TextStyles.bodyLarge,
                    ),
                  ],
                ),
              ],
            ),
          ),
          Divider(
            height: 2,
            thickness: 1,  // Set the thickness of the divider
            color: Colors.grey.withOpacity(0.8),  // Adjust the opacity of the divider color
            indent: 16,  // Add space on the left
            endIndent: 16,  // Add space on the right
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 6.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 8),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Scheduled Time'),
                      Expanded(
                        child: Text(
                          _formatDateTime(arrivalTime), // Use formatted time here
                          textAlign: TextAlign.right,
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
