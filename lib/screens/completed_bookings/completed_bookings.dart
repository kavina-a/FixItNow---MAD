import 'package:flutter/material.dart';
import '../layouts/completedbookings_landscape.dart';
import '../layouts/completedbookings_portrait.dart';

class CompletedBookings extends StatefulWidget {
  const CompletedBookings({Key? key}) : super(key: key); // Added key to the constructor

  @override
  _CompletedBookingsState createState() => _CompletedBookingsState();
}

class _CompletedBookingsState extends State<CompletedBookings> {
  @override
  Widget build(BuildContext context) {
    var orientation = MediaQuery.of(context).orientation;

    // Switch between portrait and landscape layouts
    return orientation == Orientation.portrait
        ? CompletedBookingsPortrait()
        : CompletedBookingsLandscape();
  }
}
