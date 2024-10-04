import 'package:geolocator/geolocator.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocationService {
  // Request location permissions from the user
  Future<void> requestPermission() async {
    LocationPermission permission = await Geolocator.checkPermission();
    print('Initial permission status: $permission');  // Debug log

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      print('Permission after request: $permission');  // Debug log

      if (permission == LocationPermission.deniedForever) {
        // Handle permission denied permanently (ask user to enable from settings)
        throw Exception("Location permission is permanently denied. Please enable it in settings.");
      } else if (permission == LocationPermission.denied) {
        // Handle permission denied temporarily
        throw Exception("Location permission denied.");
      }
    } else {
      print('Permission already granted: $permission');  // Debug log
    }
  }

  // Get the current position of the user
  Future<Position> getCurrentLocation() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    print('Is location service enabled: $serviceEnabled');  // Debug log

    if (!serviceEnabled) {
      // If the location services are disabled, throw an error
      throw Exception("Location services are disabled.");
    }

    try {
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      print('Current position: $position');  // Debug log to see location details
      return position;
    } catch (e) {
      // Handle any errors (like permission not granted)
      print('Error getting current location: $e');  // Log the specific error
      throw Exception("Failed to get current location.");
    }
  }

  // Store location in SharedPreferences
  Future<void> storeLocation(double latitude, double longitude) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    print('Storing latitude: $latitude, longitude: $longitude');  // Debug log

    if (latitude == null || longitude == null) {
      print('Error: Latitude or longitude is null before storing!');  // Log if any value is null
    }

    await prefs.setDouble('latitude', latitude);
    await prefs.setDouble('longitude', longitude);
    print('Location stored successfully.');  // Confirmation log
  }


  Future<void> initializeLocation() async {
    try {
      // Request permission for location access
      await LocationService().requestPermission();

      // Get the current location
      Position position = await LocationService().getCurrentLocation();

      // Store the latitude and longitude in SharedPreferences
      await LocationService().storeLocation(position.latitude, position.longitude);

      print('Location successfully stored: Latitude: ${position.latitude}, Longitude: ${position.longitude}');
    } catch (e) {
      print('Error storing location: $e');
    }
  }

  // Retrieve location from SharedPreferences
  Future<Position?> getLocationFromStorage() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    double? lat = prefs.getDouble('latitude');
    double? lon = prefs.getDouble('longitude');

    print('Retrieved latitude: $lat, longitude: $lon');  // Debug log to verify retrieved data

    if (lat != null && lon != null) {
      return Position(
        latitude: lat,
        longitude: lon,
        timestamp: DateTime.now(),  // Provide current time
        accuracy: 0.0,              // Default or mock value
        altitude: 0.0,              // Default or mock value
        heading: 0.0,               // Default or mock value
        speed: 0.0,                 // Default or mock value
        speedAccuracy: 0.0,         // Default or mock value
        isMocked: false,
        altitudeAccuracy: 0.0,
        headingAccuracy: 0.0,
      );
    }

    print('No location found in storage.');  // Log if location is not found
    return null;
  }
}
