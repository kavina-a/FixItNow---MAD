import 'package:fixitnow/screens/account/widgets/account_appbar.dart';
import 'package:fixitnow/screens/account/widgets/account_settingslist.dart';
import 'package:fixitnow/screens/completed_bookings/completed_bookings.dart';
import 'package:fixitnow/screens/widgets/navigation_bar.dart';
import 'package:fixitnow/screens/worker-screens/Profile/widgets/spaccount_settingslist.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SP_AccountPage extends StatelessWidget {
  const SP_AccountPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: ListView(
          children: [
            AccountAppBar(),
            SizedBox(height: 30,),
            SP_AccountSettingsList(),
          ],
        ),
      ),
    );
  }
}