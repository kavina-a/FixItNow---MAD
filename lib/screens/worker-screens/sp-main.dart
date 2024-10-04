import 'package:fixitnow/screens/worker-screens/Activity/activity.dart';
import 'package:fixitnow/screens/worker-screens/Profile/sp_account.dart';
import 'package:fixitnow/screens/worker-screens/home/home.dart';
import 'package:flutter/material.dart';

import '../../themes/dark_theme.dart';
import '../../themes/light_theme.dart';
import 'RatingsandReviews/ratingsandreviews.dart';
import 'nav_bar.dart';

void main() {
  runApp(ServiceProviderApp());
}

class ServiceProviderApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: lightTheme,
      darkTheme: darkTheme,
      themeMode: ThemeMode.system,
      home: MainScreen(),
    );
  }
}

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  // List of pages
  final List<Widget> _pages = [
    SP_HomePage(),
    SP_ActivityPage(),
    ServiceProviderRatingsAndReviewsScreen(),
    SP_AccountPage()
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}
