import 'package:fixitnow/screens/worker-screens/home/widgets/home_analytics.dart';
import 'package:fixitnow/screens/worker-screens/home/widgets/home_appbar.dart';
import 'package:fixitnow/screens/worker-screens/home/widgets/home_ongoingappointments.dart';
import 'package:flutter/material.dart';

class SP_HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            SP_HomeAppBar(),
            SizedBox(height: 20),
            // Analytics Page
            SP_AnalyticsPage(),
            SizedBox(height: 50),
            // Ongoing Appointments List
            Container(
              height: MediaQuery.of(context).size.height * 0.5, // Set height to 50% of the screen for ongoing appointments
              child: SP_OngoingList(),
            ),
          ],
        ),
      ),
    );
  }
}
