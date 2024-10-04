import 'package:fixitnow/screens/widgets/styles.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../completed_bookings/completed_bookings.dart';
import '../account/account.dart';
import '../activity/activity.dart';
import '../home/home.dart';
import '../message/message.dart';

class MainNavigationBar extends StatefulWidget {
  const MainNavigationBar({super.key});

  @override
  State<MainNavigationBar> createState() => _MainNavigationBarState();
}

class _MainNavigationBarState extends State<MainNavigationBar> {
  int _selectedIndex = 0;

  // Pass the first name to the HomePage
  List<Widget> get _widgetOptions => [
    HomePage(),  // Pass firstName to HomePage
    const ActivityPage(key: ValueKey('ActivityPage')),
    CompletedBookings(key: ValueKey('CompletedPage')),
    const AccountPage(key: ValueKey('AccountPage')),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    Brightness currentBrightness = Theme.of(context).brightness;

    return Scaffold(
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 250),
        transitionBuilder: (Widget child, Animation<double> animation) {
          return FadeTransition(
            opacity: animation,
            child: child,
          );
        },
        child: _widgetOptions[_selectedIndex],
      ),
      bottomNavigationBar: BottomNavigationBar(
        elevation: 0,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.timer), label: 'Activity'),
          BottomNavigationBarItem(icon: Icon(Icons.history_rounded), label: 'History'),
          BottomNavigationBarItem(icon: Icon(Icons.account_circle), label: 'Profile'),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: TextStyles.primaryColor,
        unselectedItemColor:
        currentBrightness == Brightness.dark ? Colors.white : Colors.black,
        onTap: _onItemTapped,
        type: BottomNavigationBarType.fixed,
      ),
    );
  }
}
