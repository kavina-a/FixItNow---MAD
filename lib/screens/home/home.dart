import 'package:fixitnow/screens/home/widgets/home_appbar.dart';
import 'package:fixitnow/screens/home/widgets/home_categorieslist.dart';
import 'package:fixitnow/screens/home/widgets/home_jobcard.dart';
import 'package:fixitnow/screens/home/widgets/home_searchcard.dart';
import 'package:fixitnow/screens/widgets/navigation_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fixitnow/services/location_service.dart';
import 'package:geolocator/geolocator.dart';  // Import the location service

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final LocationService _locationService = LocationService();  // Initialize LocationService

  Position? _currentPosition;  // Store user's location
  String? _locationError;  // Store error if any


  @override
  void initState() {
    super.initState();
    // Call the initializeLocation method when the home page is loaded
    LocationService().initializeLocation();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
          children: [
            HomeAppBar(),
            SizedBox(height: 60),
            HomeSearchCard(),
            SizedBox(height: 60),
            HomeCategoriesList(),
            SizedBox(height: 40),
            Divider(),
            SizedBox(height: 20),
            JobCard(),

            // Display location or error
            SizedBox(height: 20),
            _currentPosition != null
                ? Text("Your Location: ${_currentPosition!.latitude}, ${_currentPosition!.longitude}")
                : _locationError != null
                ? Text("Error: $_locationError")
                : CircularProgressIndicator(),  // Show loading indicator
          ],
        ),
      ),
    );
  }
}


