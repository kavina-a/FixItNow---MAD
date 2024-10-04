import 'package:fixitnow/screens/activity/widgets/activity_appbar.dart';
import 'package:fixitnow/screens/activity/widgets/activity_completed.dart';
import 'package:fixitnow/screens/activity/widgets/activity_ongoinglist.dart';
import 'package:fixitnow/screens/activity/widgets/activity_pending.dart';
import 'package:fixitnow/screens/activity/widgets/activity_rejectedlist.dart';
import 'package:fixitnow/screens/widgets/navigation_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ActivityPage extends StatelessWidget {
  const ActivityPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: ListView(
          children: [
            ActivityAppBar(),
            RejectedAppointmentsScreen(),
            PendingAppointmentsScreen(),
            ActivityOngoingList(),
            // ActivityCompletedList()
          ],
        ),
      ),
      // bottomNavigationBar: MainNavigationBar(), // Correctly placed outside of the ListView
    );
  }
}
