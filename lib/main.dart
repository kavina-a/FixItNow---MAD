import 'dart:async';

import 'package:fixitnow/screens/activity/activity.dart';
import 'package:fixitnow/screens/home/home.dart';
import 'package:fixitnow/screens/home/widgets/home_detailed_jobcard.dart';
import 'package:fixitnow/screens/login&signup/login.dart';
import 'package:fixitnow/screens/login&signup/register-serviceprovider.dart';
import 'package:fixitnow/screens/login&signup/signup.dart';
import 'package:fixitnow/screens/message/message.dart';
import 'package:fixitnow/screens/widgets/navigation_bar.dart';
import 'package:fixitnow/screens/worker-screens/Activity/activity.dart';
import 'package:fixitnow/screens/worker-screens/home/home.dart';
import 'package:fixitnow/screens/worker-screens/sp-main.dart';
import 'package:flutter/material.dart';
import 'package:fixitnow/themes/light_theme.dart';
import 'package:fixitnow/themes/dark_theme.dart';
import 'package:device_preview/device_preview.dart';
import 'package:provider/provider.dart'; // Add Provider package
import 'package:fixitnow/providers/user_provider.dart'; // Import the UserProvider
import 'package:flutter_stripe/flutter_stripe.dart'; // Import flutter_stripe package
import 'package:connectivity_plus/connectivity_plus.dart'; // Import connectivity_plus package
import 'package:url_launcher/url_launcher.dart'; // Import url_launcher for opening Wi-Fi settings

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Stripe with your publishable key
  Stripe.publishableKey = 'pk_test_51Q5MsnKcg0aY6eUJ57igd8egjQBvGBfi6A8dhkvhXz0hGL9JgrkTQegIbwmuTcFCIvKCQeEsB5RtQrHe4SMjntOI0092wwr405';

  runApp(
    DevicePreview(
      enabled: true,
      builder: (context) => MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => UserProvider()), // Provide UserProvider globally
        ],
        child: const MyApp(),
      ),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  ConnectivityResult _connectionStatus = ConnectivityResult.none;
  final Connectivity _connectivity = Connectivity();
  late StreamSubscription<ConnectivityResult> _subscription;

  @override
  void initState() {
    super.initState();
    _checkConnectivity();
    _subscribeToConnectivityChanges();
  }

  Future<void> _checkConnectivity() async {
    var connectivityResult = await _connectivity.checkConnectivity();
    setState(() {
      _connectionStatus = connectivityResult;
    });
  }

  void _subscribeToConnectivityChanges() {
    _subscription = _connectivity.onConnectivityChanged.listen((ConnectivityResult result) {
      setState(() {
        _connectionStatus = result;
      });
    });
  }

  @override
  void dispose() {
    _subscription.cancel(); // Cancel the subscription when the widget is disposed
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: lightTheme,
      darkTheme: darkTheme,
      themeMode: ThemeMode.system,
      title: 'FIXITNOW',
      home: _connectionStatus == ConnectivityResult.none
          ? const NoInternetPage()  // Automatically show NoInternetPage when offline
          : const LoginPage(),      // Show LoginPage when online
      routes: {
        '/customer': (context) => const SignInPage(),
        '/service-provider': (context) => const ServiceProviderRegistration(),
        '/customer/home': (context) => const MainNavigationBar(),
        '/service-provider/home': (context) => ServiceProviderApp(),
        '/customer/activity': (context) => const ActivityPage(),
      },
    );
  }
}

// NoInternetPage for when there is no internet connection
class NoInternetPage extends StatelessWidget {
  const NoInternetPage({super.key});

  Future<void> _openWifiSettings() async {
    const wifiSettingsUrl = 'wifi:';
    if (await canLaunch(wifiSettingsUrl)) {
      await launch(wifiSettingsUrl);
    } else {
      throw 'Could not open Wi-Fi settings';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.wifi_off, size: 80, color: Colors.red),
            const SizedBox(height: 20),
            const Text(
              'You are offline. Please check your connection.',
              style: TextStyle(fontSize: 18),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            // ElevatedButton(
            //   onPressed: _openWifiSettings,
            //   child: const Text('Open Wi-Fi Settings'),
            // ),
          ],
        ),
      ),
    );
  }
}
