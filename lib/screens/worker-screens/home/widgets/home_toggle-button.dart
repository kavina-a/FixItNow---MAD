import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../../../../services/service-provider-service.dart';

class AvailabilityScreen extends StatefulWidget {
  @override
  _AvailabilityScreenState createState() => _AvailabilityScreenState();
}

class _AvailabilityScreenState extends State<AvailabilityScreen> {
  bool _isAvailable = false;
  bool _isLoading = true;
  final CategoryServiceProviderService _CategoryServiceProviderService = CategoryServiceProviderService();

  @override
  void initState() {
    super.initState();
    _fetchAvailability();
  }

  // Fetch availability status from the server
  Future<void> _fetchAvailability() async {
    try {
      final isAvailable = await _CategoryServiceProviderService.getAvailability();
      setState(() {
        _isAvailable = isAvailable;
        _isLoading = false; // Set loading to false after fetching data
      });
    } catch (error) {
      print('Error fetching availability: $error');
      setState(() {
        _isLoading = false; // Set loading to false even if an error occurs
      });
    }
  }

  // Update availability status on the server
  Future<void> _updateAvailability(bool newStatus) async {
    try {
      await _CategoryServiceProviderService.updateAvailability(newStatus);
      setState(() {
        _isAvailable = newStatus;
      });
    } catch (error) {
      print('Error updating availability: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end, // Align switch and label to the right
          children: [
            // Label text changes based on availability
            Text(
              _isAvailable ? 'Available' : 'Unavailable',
              style: TextStyle(
                fontSize: 16,
                color: _isAvailable ? Colors.green : Colors.red, // Text color changes
              ),
            ),
            SizedBox(width: 10),
            // Switch button to toggle availability
            Switch(
              value: _isAvailable,
              activeColor: Colors.green, // Switch color when active
              inactiveThumbColor: Colors.red, // Switch color when inactive
              onChanged: (newValue) {
                _updateAvailability(newValue);
              },
            ),
          ],
        ),
      ),
    );
  }
}
