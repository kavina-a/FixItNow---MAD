import 'package:fixitnow/screens/profile/profile.dart';
import 'package:fixitnow/screens/widgets/styles.dart';
import 'package:fixitnow/screens/worker-screens/Profile/widgets/spaccount_profile.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../../../login&signup/login.dart';

class SP_AccountSettingsList extends StatelessWidget {
  const SP_AccountSettingsList({super.key});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size; // Gets screen size
    Brightness brightness = Theme.of(context).brightness;

    Color backgroundColor = brightness == Brightness.light
        ? TextStyles.primaryColor.withOpacity(0.2)
        : Theme.of(context).colorScheme.secondary;

    final FlutterSecureStorage storage = FlutterSecureStorage(); // Instance of FlutterSecureStorage

    Future<void> _logout(BuildContext context) async {
      // Remove the token from secure storage
      await storage.delete(key: 'token'); // Remove the token

      // Navigate back to the login page
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => LoginPage()),
            (Route<dynamic> route) => false,
      );
    }

    return SingleChildScrollView(
      child: Container(
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(50),
            topRight: Radius.circular(50),
          ),
        ),
        child: Padding(
          padding: EdgeInsets.only(top: 25, left: 20),
          child: Padding(
            padding: EdgeInsets.only(top: 10.0),
            child: Column(
              children: [
                InkWell( // Make this ListTile clickable
                  onTap: () {
                    // Navigate to the Profile Update Screen
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ServiceProviderProfileScreen(), // Replace with your Profile Update screen
                      ),
                    );
                  },
                  child: ListTile(
                    leading: Icon(Icons.account_circle_outlined, color: TextStyles.primaryColor),
                    title: Text('Profile', style: TextStyles.bodyMedium),
                  ),
                ),
                ListTile(
                  leading: Icon(Icons.directions_car, color: TextStyles.primaryColor),
                  title: Text('Notification Settings', style: TextStyles.bodyMedium),
                ),
                ListTile(
                  leading: Icon(Icons.payments_outlined, color: TextStyles.primaryColor),
                  title: Text('Payment Settings', style: TextStyles.bodyMedium),
                ),
                ListTile(
                  leading: Icon(Icons.work_history_outlined, color: TextStyles.primaryColor),
                  title: Text('Earn by working', style: TextStyles.bodyMedium),
                ),
                ListTile(
                  leading: Icon(Icons.language_outlined, color: TextStyles.primaryColor),
                  title: Text('Language Preferences', style: TextStyles.bodyMedium),
                ),
                ListTile(
                  leading: Icon(Icons.support_agent, color: TextStyles.primaryColor),
                  title: Text('Help and Support', style: TextStyles.bodyMedium),
                ),
                ListTile(
                  leading: Icon(Icons.policy, color: TextStyles.primaryColor),
                  title: Text('Terms of Service and Privacy Policy', style: TextStyles.bodyMedium),
                ),
                ListTile(
                  leading: Icon(Icons.info_outline, color: TextStyles.primaryColor),
                  title: Text('About', style: TextStyles.bodyMedium),
                ),
                ListTile(
                  leading: Icon(Icons.logout, color: TextStyles.primaryColor),  // Change the icon to a logout icon
                  title: Text('Log Out', style: TextStyles.bodyMedium),  // Change text to "Log Out"
                  onTap: () async {
                    // Call the logout function when tapped
                    await _logout(context);  // Ensure you have the _logout function defined
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
