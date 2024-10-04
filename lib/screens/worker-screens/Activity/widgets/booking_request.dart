import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../models/appointment_model.dart';
import '../../../../services/service-provider-service.dart';
import 'package:intl/intl.dart';

import '../../../widgets/styles.dart';

class PendingAppointmentsScreen extends StatefulWidget {
  const PendingAppointmentsScreen({Key? key}) : super(key: key);

  @override
  _PendingAppointmentsScreenState createState() =>
      _PendingAppointmentsScreenState();
}

class _PendingAppointmentsScreenState extends State<PendingAppointmentsScreen> {
  bool isLoading = true;
  bool hasError = false;
  List<AppointmentModel> appointments = [];

  final CategoryServiceProviderService service = CategoryServiceProviderService(); // Create an instance of the service

  @override
  void initState() {
    super.initState();
    _fetchPendingAppointments(); // Fetch pending appointments on load
  }

  // Fetch pending appointments (placeholder, replace with actual fetching logic)
  Future<void> _fetchPendingAppointments() async {
    try {
      appointments = await service.getRequestAppointments();
      setState(() {
        isLoading = false; // Set loading to false after fetching
      });
    } catch (e) {
      setState(() {
        hasError = true;
        isLoading = false;
      });
    }
  }

  String formatArrivalTime(String arrivalTime) {
    try {
      // Parse the incoming string into a DateTime object
      DateTime parsedDate = DateTime.parse(arrivalTime);

      // Format the date and time (e.g., "10th October, 5:51 PM")
      String formattedDate = DateFormat('d MMMM, h:mm a').format(parsedDate);

      return formattedDate;
    } catch (e) {
      // If there's an error, return the original string as fallback
      return arrivalTime;
    }
  }

  // Handle appointment status update
  Future<void> _handleUpdateStatus(int appointmentId, String status,
      {String? declineReason}) async {
    try {
      await service.updateAppointmentStatus(
          appointmentId, status, declineReason: declineReason);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Appointment $status successfully!')),
      );
      _fetchPendingAppointments(); // Refresh the list after status update
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error updating appointment status: $e')),
      );
    }
  }

  // Show Decline Reason Dialog
  void _showDeclineDialog(int appointmentId) {
    List<String> declineReasons = ['Not Available', 'Too Busy', 'Other'];
    String? selectedReason;
    TextEditingController otherReasonController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Text('Decline Reason'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ...declineReasons.map((reason) {
                    return RadioListTile<String>(
                      title: Text(reason),
                      value: reason,
                      groupValue: selectedReason,
                      onChanged: (String? value) {
                        setState(() {
                          selectedReason = value;
                        });
                      },
                    );
                  }).toList(),
                  if (selectedReason == 'Other')
                    TextField(
                      controller: otherReasonController,
                      decoration: const InputDecoration(
                        labelText: 'Other Reason',
                      ),
                    ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context)
                        .pop(); // Close dialog without any action
                  },
                  child: const Text('Cancel'),
                ),
                ElevatedButton(
                  onPressed: () {
                    String declineReason = selectedReason == 'Other'
                        ? otherReasonController.text // Custom reason if "Other"
                        : selectedReason ?? 'Not available'; // Default reason

                    // Call the function to handle the decline status update
                    _handleUpdateStatus(appointmentId, 'declined',
                        declineReason: declineReason);
                    Navigator.of(context)
                        .pop(); // Close dialog after submitting
                  },
                  child: const Text('Submit'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? const Center(
      child: CircularProgressIndicator(), // Show loading indicator
    )
        : hasError
        ? const Center(
      child: Text('Error loading pending appointments'),
    ) // Show error message
        : appointments.isEmpty
        ? const Center(
      child: Text('No pending appointments available'),
    )
        : ListView.builder(
      itemCount: appointments.length,
      itemBuilder: (context, index) {
        final appointment = appointments[index];
        return pendingList(appointment);
      },
    );
  }

// Widget to display each appointment with Accept/Decline buttons
  Widget pendingList(AppointmentModel appointment) {
    // Function to open Google Maps
    Future<void> _openGoogleMaps(String? location) async {
      if (location == null || location.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Location not available')),
        );
        return;
      }

      // Use a valid location URL for Google Maps
      final String googleMapsUrl = 'https://www.google.com/maps/search/?api=1&query=${Uri.encodeComponent(location)}';

      // Check if the URL can be launched
      if (await canLaunch(googleMapsUrl)) {
        await launch(googleMapsUrl);
      } else {
        throw 'Could not open Google Maps.';
      }
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12.0),
        color: Theme.of(context).brightness == Brightness.dark
            ? Colors.grey[850] // Dark mode - darker grey
            : Colors.grey[200], // Light mode - lighter grey
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Container(
            decoration: BoxDecoration(
              color: Colors.redAccent.withOpacity(0.8), // Emergency feel
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(12.0),
                topRight: Radius.circular(12.0),
              ),
            ),
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'REQUEST ALERT', // Uppercase and bold to emphasize
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w900,
                    fontSize: 18.0,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(1.0), // Controls the size of the button
                  decoration: BoxDecoration(
                    color: Colors.white, // Button background color
                    borderRadius: BorderRadius.circular(100.0), // Rounded corners
                  ),
                  child: IconButton(
                    icon: Icon(Icons.location_on, color: TextStyles.primaryColor),
                    onPressed: () {
                      _openGoogleMaps(appointment.location);
                    },
                  ),
                )


              ],
            ),
          ),

          // Customer Name & Avatar
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 25,
                  backgroundImage: const AssetImage('asset/pic.jpg'), // Placeholder image
                ),
                const SizedBox(width: 10),
                Text(
                  appointment.customerName ?? 'Unknown Customer',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16.0,
                  ),
                ),
                const Spacer(),
                Row(
                  children: const [
                    Icon(Icons.star, color: Colors.amber, size: 16),
                    SizedBox(width: 5),
                    Text('4.9'),
                  ],
                ),
              ],
            ),
          ),

          // Service Type
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Text(
              'Service Type - ${appointment.serviceType}',
              style: const TextStyle(color: Colors.grey),
            ),
          ),

          // Arrival Time
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Arrival Time:'),
                Text(formatArrivalTime(appointment.startTime)),
              ],
            ),
          ),

          // Appointment Notes
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Text(
              'Note - ${appointment.notes?.isNotEmpty == true ? appointment.notes! : 'No notes provided.'}',
              style: TextStyle(
                color: Theme.of(context).brightness == Brightness.dark
                    ? Colors.white70 // Light white for dark mode
                    : Colors.black54, // Light black for light mode
              ),
            ),

          ),

          // Buttons
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                  onPressed: appointment.id != null
                      ? () {
                    _handleUpdateStatus(appointment.id!, 'accepted'); // Accept the appointment
                  }
                      : null, // Disable the button if ID is null
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green, // Green color for Accept
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  ),
                  child: const Text(
                    'Accept',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                ElevatedButton(
                  onPressed: appointment.id != null
                      ? () {
                    _showDeclineDialog(appointment.id!); // Show dialog for decline reason
                  }
                      : null, // Disable the button if ID is null
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red, // Red color for Decline
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  ),
                  child: const Text(
                    'Decline',
                    style: TextStyle(color: Colors.white),
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