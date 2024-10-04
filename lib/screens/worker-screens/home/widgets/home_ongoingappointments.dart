import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../models/appointment_model.dart';
import '../../../../services/service-provider-service.dart';
import 'dart:io';

import '../../../widgets/styles.dart';

class SP_OngoingList extends StatefulWidget {
  const SP_OngoingList({super.key});

  @override
  _SP_OngoingListState createState() => _SP_OngoingListState();
}

class _SP_OngoingListState extends State<SP_OngoingList> {
  late Future<List<AppointmentModel>> _ongoingAppointments;

  @override
  void initState() {
    super.initState();
    _ongoingAppointments = CategoryServiceProviderService().getOngoingAppointmentsForServiceProvider();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<AppointmentModel>>(
      future: _ongoingAppointments,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text('No ongoing appointments available'));
        }

        final ongoingAppointments = snapshot.data!;

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: ListView.builder(
            shrinkWrap: true,  // Ensures it doesn't take excess space
            physics: NeverScrollableScrollPhysics(), // Prevents internal scrolling conflict
            itemCount: ongoingAppointments.length,
            itemBuilder: (context, index) {
              final appointment = ongoingAppointments[index];
              return Column(
                children: [
                  ongoing(
                    'Ongoing Booking',
                    appointment.serviceType,
                    'asset/workerpic1.jpg',
                    appointment.customerName ?? 'Unknown',
                    appointment.notes ?? 'No notes provided',
                    context,
                    appointment.id,
                    appointment.customerphoneNumber,
                    appointment.location,
                  ),
                  const SizedBox(height: 40),
                ],
              );
            },
          ),
        );
      },
    );
  }
  // Helper function to format the date and time in a user-friendly format
  String _formatDateTime(String dateTime) {
    try {
      DateTime parsedDate = DateTime.parse(dateTime);
      return DateFormat('d MMMM, h:mm a').format(parsedDate);
    } catch (e) {
      return dateTime;
    }
  }

  void _makePhoneCall(String phoneNumber) async {
    var status = await Permission.phone.status;
    if (!status.isGranted) {
      status = await Permission.phone.request();
      if (!status.isGranted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Phone call permission is required to make a call.')),
        );
        return;
      }
    }

    final Uri phoneUri = Uri(scheme: 'tel', path: phoneNumber);
    if (await canLaunchUrl(phoneUri)) {
      await launchUrl(phoneUri);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Cannot make phone call. Please check your device settings.')),
      );
    }
  }

  // Function to open Google Maps with a location
  void _openGoogleMaps(String? location) async {
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

  // This is the widget that displays each ongoing appointment
  Widget ongoing(
      String title,
      String serviceType,
      String imagePath,
      String customerName,
      String notes,
      BuildContext context,
      int? appointmentId,
      String? phoneNumber, // Add the customer's phone number
      String? location, // Add the customer's location for Google Maps
      ) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16.0), // Rounded corners
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            blurRadius: 10,
            spreadRadius: 2,
            offset: Offset(0, 4), // changes position of shadow
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(14.0),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [TextStyles.primaryColor, Colors.redAccent],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(16.0),
                topRight: Radius.circular(16.0),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18.0,
                    color: Colors.white,
                  ),
                ),
                Row(
                  children: [
                    // Phone Button with similar design as Map Button
                    if (phoneNumber != null)
                      Container(
                        padding: const EdgeInsets.all(1.0), // Controls the size of the button
                        decoration: BoxDecoration(
                          color: Colors.white, // Button background color
                          borderRadius: BorderRadius.circular(100.0), // Rounded corners for circular shape
                        ),
                        child: IconButton(
                          icon: Icon(Icons.call, color: TextStyles.primaryColor), // Phone icon
                          onPressed: () {
                            _makePhoneCall(phoneNumber); // Call function
                          },
                        ),
                      ),
                    const SizedBox(width: 10), // Spacer between the two buttons

                    // Location Button
                    if (location != null)
                      Container(
                        padding: const EdgeInsets.all(1.0), // Controls the size of the button
                        decoration: BoxDecoration(
                          color: Colors.white, // Button background color
                          borderRadius: BorderRadius.circular(100.0), // Rounded corners for circular shape
                        ),
                        child: IconButton(
                          icon: Icon(Icons.location_on, color: TextStyles.primaryColor), // Location icon
                          onPressed: () {
                            _openGoogleMaps(location); // Open Google Maps function
                          },
                        ),
                      ),
                  ],
                ),

              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 25,
                  backgroundImage: AssetImage(imagePath), // Placeholder image
                ),
                const SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Ongoing: $serviceType for $customerName',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16.0,
                        color: Theme.of(context).brightness == Brightness.dark
                            ? Colors.white // White in dark mode
                            : Colors.black87, // Black in light mode
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      _formatDateTime(DateTime.now().toString()), // Example formatting
                      style: TextStyle(
                        color: Theme.of(context).brightness == Brightness.dark
                            ? Colors.white70 // Light white in dark mode
                            : Colors.black54, // Light black in light mode
                      ),
                    ),

                  ],
                ),
              ],
            ),
          ),
          const Divider(height: 1, thickness: 1),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const
                Text('Notes:', style: TextStyle(fontWeight: FontWeight.bold)),
                Text(
                  notes,
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    color: Theme.of(context).brightness == Brightness.dark
                        ? Colors.white70 // Light white in dark mode
                        : Colors.black54, // Light black in light mode
                    fontSize: 14.0,
                  ),
                ),

                const SizedBox(height: 16),
                Center(
                  child: ElevatedButton(
                    onPressed: () {
                      if (appointmentId != null) {
                        _showImagePickerDialog(appointmentId);
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: TextStyles.primaryColor,
                      padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      "Complete Appointment",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // This function shows a dialog to either pick an image or skip it
  void _showImagePickerDialog(int appointmentId) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Complete Appointment"),
          content: const Text("Would you like to upload an image as proof of completion?"),
          actions: <Widget>[
            TextButton(
              child: const Text("No"),
              onPressed: () {
                Navigator.of(context).pop();
                _completeAppointment(appointmentId);  // Complete without image
              },
            ),
            TextButton(
              child: const Text("Yes"),
              onPressed: () async {
                Navigator.of(context).pop();
                final pickedImage = await _pickImage();
                _completeAppointment(appointmentId, proofImage: pickedImage);  // Complete with image
              },
            ),
          ],
        );
      },
    );
  }

  Future<File?> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.camera);
    if (pickedFile != null) {
      return File(pickedFile.path);
    }
    return null;
  }

  void _completeAppointment(int appointmentId, {File? proofImage}) async {
    try {
      if (proofImage != null) {
        print("Proof image path: ${proofImage.path}");
      }
      await CategoryServiceProviderService().completeAppointment(appointmentId, proofImage: proofImage);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Appointment completed successfully!')),
      );
    } catch (e) {
      print("Error completing appointment: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to complete appointment: $e')),
      );
    }
  }
}
