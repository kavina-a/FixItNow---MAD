import 'package:fixitnow/screens/widgets/styles.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';  // Import the intl package for formatting
import 'package:permission_handler/permission_handler.dart';
import 'package:url_launcher/url_launcher.dart'; // Import the url_launcher package for calling
import '../../../models/appointment_model.dart'; // Import your AppointmentModel
import '../../../services/booking_service.dart'; // Import the API service

class ActivityOngoingList extends StatefulWidget {
  const ActivityOngoingList({super.key});

  @override
  _ActivityOngoingListState createState() => _ActivityOngoingListState();
}

class _ActivityOngoingListState extends State<ActivityOngoingList> {
  late Future<List<AppointmentModel>> _ongoingAppointments;

  @override
  void initState() {
    super.initState();
    _ongoingAppointments = AppointmentService().getOngoingAppointments(); // Fetch ongoing appointments
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<AppointmentModel>>(
      future: _ongoingAppointments,
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
          return SizedBox.shrink(); // No ongoing appointments
        }

        final ongoingAppointments = snapshot.data!;

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            children: ongoingAppointments.map((appointment) {
              return Column(
                children: [
                  ongoing(
                    'Ongoing Booking',
                    appointment.serviceType,
                    'asset/workerpic1.jpg', // Replace with actual image if available
                    appointment.serviceProviderName ?? 'Unknown', // Service Provider's name
                    appointment.startTime, // Start time from API
                    'Still Ongoing', // Status
                    context,
                    appointment.serviceproviderphoneNumber, // Pass the phone number here
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

      // Format to something like "23rd September, 12:00 PM"
      return DateFormat('d MMMM, h:mm a').format(parsedDate);
    } catch (e) {
      // In case of an error (invalid date), return the original string
      return dateTime;
    }
  }

  void _makePhoneCall(String phoneNumber) async {
    // Check and request permission to make phone calls
    var status = await Permission.phone.status;
    if (!status.isGranted) {
      // Request permission if it's not granted
      status = await Permission.phone.request();


      if (!status.isGranted) {
        // If the permission is still denied, show a message
        print('Phone call permission denied');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Phone call permission is required to make a call.')),
        );
        return; // Exit if permission is denied
      }
    }

    final Uri phoneUri = Uri(scheme: 'tel', path: phoneNumber);
    print("Attempting to call: $phoneNumber with URI: $phoneUri");  // Debugging print
    print('Phone URI: $phoneUri');
    print('Can launch: ${await canLaunchUrl(phoneUri)}');


    // Check if the 'tel:' scheme can be launched
    if (await canLaunchUrl(phoneUri)) {
      await launchUrl(phoneUri);
    } else {
      print('Could not launch phone URI: $phoneUri');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Cannot make phone call. Please check your device settings.')),
      );
    }
  }



  // This is the widget that displays each ongoing appointment
  Widget ongoing(
      String title,
      String serviceType,
      String imagePath,
      String name,
      String arrivalTime,
      String completedTime,
      BuildContext context,
      String? phoneNumber, // Add phone number parameter
      ) {
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
              color: TextStyles.primaryColor.withOpacity(0.3),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(12.0),
                topRight: Radius.circular(12.0),
              ),
            ),
            padding: EdgeInsets.all(12.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Title Section
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 16.0, // Increase font size
                    fontWeight: FontWeight.bold, // Make title bold
                    color: Theme.of(context).brightness == Brightness.dark ? Colors.white : Colors.black, // Adjust color based on theme
                  ),
                ),

                if (phoneNumber != null) ...[
                  Divider(height: 20, thickness: 0.3),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ElevatedButton.icon(
                        icon: Icon(Icons.call),
                        label: Text('Call'),
                        onPressed: () => _makePhoneCall(phoneNumber), // Trigger phone call
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Service Provider Name and Service Type
                Row(
                  children: [
                    CircleAvatar(
                      radius: 25,
                      backgroundImage: AssetImage(imagePath), // Placeholder image
                    ),
                    SizedBox(width: 10),
                    Text(
                      '${name} - ${serviceType}', // Display service provider's name and service type
                      style: TextStyle(
                        fontWeight: FontWeight.bold, // Make the name and service type bold
                        fontSize: 16.0, // Increase font size
                        color: Theme.of(context).brightness == Brightness.dark ? Colors.white : Colors.black87, // Adjust color based on theme
                      ),
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
          SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Arrival Time:', // Bold the label
                  style: TextStyle(
                    fontWeight: FontWeight.bold, // Bold label
                    fontSize: 14.0,
                  ),
                ),
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

// Completed Time Section
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Completed Time:', // Bold the label
                  style: TextStyle(
                    fontWeight: FontWeight.bold, // Bold label
                    fontSize: 14.0,
                  ),
                ),
                Expanded(
                  child: Text(
                    completedTime, // Completed time text
                    textAlign: TextAlign.right,
                    style: TextStyles.bodyMedium,
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
