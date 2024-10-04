import 'package:fixitnow/screens/worker-screens/Activity/widgets/booking_request.dart';
import 'package:fixitnow/screens/worker-screens/Activity/widgets/spactivity_appbar.dart';
import 'package:flutter/material.dart';

class SP_ActivityPage extends StatelessWidget {
  const SP_ActivityPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            SP_ActivityAppBar(),

            Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 24, vertical: 10),
                child: PendingAppointmentsScreen(), // Scrollable content
              ),
            ),

          ],
        ),
      ),
    );
  }
}
