import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';
import 'package:flutter/cupertino.dart';
import 'package:table_calendar/table_calendar.dart'; // Import table_calendar package
import '../../services/booking_service.dart';
import '../../services/location_service.dart';
import '../widgets/styles.dart';  // Assuming this contains TextStyles

class AppointmentForm extends StatefulWidget {
  final int serviceProviderId;
  final String serviceType;
  final String serviceProviderName;

  const AppointmentForm({Key? key, required this.serviceProviderId, required this.serviceType, required this.serviceProviderName}) : super(key: key);

  @override
  _AppointmentFormState createState() => _AppointmentFormState();
}

class _AppointmentFormState extends State<AppointmentForm> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _notesController = TextEditingController();

  bool _isLoading = false;
  DateTime? _selectedTime;
  DateTime? _selectedDate;
  CalendarFormat _calendarFormat = CalendarFormat.month;

  @override
  void initState() {
    super.initState();
  }

  // Function to show Cupertino (scroll) time picker
  Future<void> _pickTime() async {
    DateTime now = DateTime.now();
    showCupertinoModalPopup(
      context: context,
      builder: (BuildContext context) {
        return Container(
          height: 250,
          color: const Color.fromARGB(255, 255, 255, 255),
          child: Column(
            children: [
              SizedBox(
                height: 200,
                child: CupertinoDatePicker(
                  initialDateTime: now,
                  mode: CupertinoDatePickerMode.time,
                  use24hFormat: false,
                  minuteInterval: 1,
                  onDateTimeChanged: (DateTime pickedTime) {
                    setState(() {
                      _selectedTime = pickedTime;
                    });
                  },
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('Done'),
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _bookAppointment() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      try {
        Position? position = await LocationService().getLocationFromStorage();
        if (position != null) {
          String selectedDateTime =
              '${DateFormat('yyyy-MM-dd').format(_selectedDate!)} ${DateFormat('HH:mm:ss').format(_selectedTime!)}';

          await AppointmentService().bookAppointment(
            serviceProviderId: widget.serviceProviderId,
            startTime: selectedDateTime,
            notes: _notesController.text,
            serviceType: widget.serviceType,
            latitude: position.latitude,
            longitude: position.longitude,
          );

          _showSuccessDialog();
        } else {
          throw Exception('Failed to get location');
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to book appointment: $e')),
        );
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  // Show Success Dialog with Styled Confirmation
  void _showSuccessDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            "Appointment Booked",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: TextStyles.primaryColor,  // Use the primary color for the title
            ),
          ),
          content: Text(
            "Your appointment has been successfully booked!",
            style: TextStyle(
              fontSize: 16,
              color: TextStyles.primaryColor.withOpacity(0.8),  // Subtle primary color
              fontWeight: FontWeight.w500,
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text(
                "OK",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: TextStyles.primaryColor,  // Use primary color for button
                ),
              ),
              onPressed: () {
                Navigator.of(context).pop();  // Close the dialog
                Navigator.pushReplacementNamed(context, '/customer/home');  // Redirect to activity page
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: IconThemeData(color: TextStyles.primaryColor),
        title: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 1.0), // Add padding here
          child: Text.rich(
            TextSpan(
              children: [
                TextSpan(
                  text:'Appointment with ${widget.serviceProviderName} 🔧',  // Use a "wrench" emoji
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: TextStyles.primaryColor,  // Use primary color for title
                  ),
                ),
              ],
            ),
          ),
        ),
        centerTitle: true,
      ),


      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Select Appointment Date',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 30),

              // Enhanced Table Calendar with Colors
              TableCalendar(
                firstDay: DateTime.now(),
                lastDay: DateTime(2100),
                focusedDay: _selectedDate ?? DateTime.now(),
                calendarFormat: _calendarFormat,
                selectedDayPredicate: (day) => isSameDay(_selectedDate, day),
                onDaySelected: (selectedDay, focusedDay) {
                  setState(() {
                    _selectedDate = selectedDay;
                  });
                },
                onFormatChanged: (format) {
                  setState(() {
                    _calendarFormat = format;
                  });
                },
                calendarStyle: CalendarStyle(
                  selectedDecoration: BoxDecoration(
                    color: TextStyles.primaryColor,  // Primary color for selected date
                    shape: BoxShape.circle,
                  ),
                  todayDecoration: BoxDecoration(
                    color: Colors.pink.shade100,  // Custom color for today
                    shape: BoxShape.circle,
                  ),
                  weekendTextStyle: TextStyle(color: Colors.redAccent),  // Style weekends
                  defaultTextStyle: TextStyle(color: Colors.black87),  // Default day text color
                  outsideDaysVisible: false,  // Hide outside days
                ),
                headerStyle: HeaderStyle(
                  formatButtonVisible: true,
                  titleCentered: true,
                  formatButtonTextStyle: TextStyle(
                    color: TextStyles.primaryColor,
                    fontWeight: FontWeight.bold,
                  ),
                  formatButtonDecoration: BoxDecoration(
                    color: TextStyles.primaryColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  leftChevronIcon: Icon(
                    Icons.chevron_left,
                    color: TextStyles.primaryColor,
                  ),
                  rightChevronIcon: Icon(
                    Icons.chevron_right,
                    color: TextStyles.primaryColor,
                  ),
                ),
              ),
              const SizedBox(height: 30),

              // Time Picker using Cupertino wheel picker
              GestureDetector(
                onTap: _pickTime,
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey.shade300),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        _selectedTime != null
                            ? 'Selected Time: ${DateFormat('hh:mm a').format(_selectedTime!)}'
                            : 'Select Time',
                        style: TextStyle(fontSize: 16, color: Colors.grey[800]),
                      ),
                      const Icon(Icons.access_time),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 30),

              // Notes Input
              // Notes Input Styled as a Box
              Container(
                padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade300),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: TextFormField(
                  controller: _notesController,
                  decoration: const InputDecoration.collapsed(
                    hintText: 'Notes (Optional)',  // Add hint text
                  ),
                  style: TextStyle(fontSize: 16, color: Colors.grey[800]),  // Style the text inside
                  maxLines: 3,  // Allow multiple lines for the notes
                ),
              ),

              const SizedBox(height: 30),

              // Submit Button
              // Submit Button
              Center(
                child: ElevatedButton(
                  onPressed: _bookAppointment,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 40),  // Increase padding
                    backgroundColor: TextStyles.primaryColor,  // Use the primary color for the button
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),  // Rounded corners
                    ),
                  ),
                  child: const Text(
                    '📅 Confirm Booking',  // Make it more exciting with an emoji
                    style: TextStyle(fontSize: 18, color: Colors.white),
                  ),
                ),
              ),

            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _notesController.dispose();
    super.dispose();
  }
}
