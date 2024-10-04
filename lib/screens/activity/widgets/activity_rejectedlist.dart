import 'package:flutter/material.dart';
import '../../../models/appointment_model.dart';
import '../../../services/booking_service.dart';

class RejectedAppointmentsScreen extends StatefulWidget {
  @override
  _RejectedAppointmentsScreenState createState() => _RejectedAppointmentsScreenState();
}

class _RejectedAppointmentsScreenState extends State<RejectedAppointmentsScreen> {
  late Future<List<AppointmentModel>> _rejectedAppointments;
  List<AppointmentModel> _appointmentsList = []; // To hold the rejected appointments locally

  @override
  void initState() {
    super.initState();
    _loadRejectedAppointments();
  }

  // Load rejected appointments and store them locally in a list
  void _loadRejectedAppointments() {
    AppointmentService().getRejectedAppointments().then((appointments) {
      setState(() {
        _appointmentsList = appointments;
      });
    }).catchError((error) {
      print('Error loading rejected appointments: $error');
    });
  }

  @override
  Widget build(BuildContext context) {
    return _appointmentsList.isEmpty
        ? SizedBox.shrink() // Hide when there's no data
        : Padding(
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
      child: Column(
        children: _appointmentsList.map((appointment) {
          return Column(
            children: [
              rejectedCard(
                serviceProviderName: appointment.serviceProviderName ?? 'Unknown Provider',
                imagePath: 'assets/rejection.png', // Use an image for the rejection message
                reason: appointment.declinedReason ?? 'No reason provided', // Rejection reason
                appointmentId: appointment.id!,
                rejectionSeen: appointment.rejectionSeen ?? false, // Default value (false) if null
                appointmentType: appointment.serviceType
              ),
              SizedBox(height: 20),
            ],
          );
        }).toList(),
      ),
    );
  }

  Widget rejectedCard({
    required String serviceProviderName,
    required String imagePath,
    required String reason,
    required int appointmentId,
    required bool rejectionSeen,
    required String appointmentType
  }) {
    return Container(
      padding: EdgeInsets.all(12), // Reduced padding for a smaller height
      decoration: BoxDecoration(
        color: Colors.redAccent.withOpacity(0.7),
        borderRadius: BorderRadius.circular(12.0),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.15),
            blurRadius: 8,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // New header message
          Container(
            padding: EdgeInsets.symmetric(vertical: 8),
            color: Colors.redAccent.withOpacity(0.1), // Softer red for background
            child: Center(
              child: Text(
                "Unfortunately, your booking has been declined.", // New phrase
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          SizedBox(height: 10),

          // Profile picture and name
          Row(
            children: [
              CircleAvatar(
                radius: 25,
                backgroundImage: AssetImage(imagePath),
              ),
              SizedBox(width: 12),
              Expanded(
                child: Text(
                  '${serviceProviderName} - ${appointmentType}',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
          SizedBox(height: 10),

          // Reason for rejection
          Text(
            ' Hold up! There’s a reason for the change: ${reason}.\n'
            ' No stress, other pros are available!' ,
            style: TextStyle(fontSize: 14, color: Colors.black87, fontWeight: FontWeight.w400),
          ),
          SizedBox(height: 10),

          // Checkbox for "Mark as seen"
          Row(
            children: [
              Checkbox(
                value: rejectionSeen,
                onChanged: (value) {
                  AppointmentService().markAppointmentAsSeen(appointmentId).then((_) {
                    setState(() {
                      _appointmentsList.removeWhere((appointment) => appointment.id == appointmentId);
                    });
                  }).catchError((error) {
                    print('Error marking appointment as seen: $error');
                  });
                },
              ),
              Text(
                'Mark as seen',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w400),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
