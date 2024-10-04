import 'package:fixitnow/screens/activity/widgets/activity_completed.dart';
import 'package:fixitnow/screens/widgets/styles.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../providers/user_provider.dart';
import '../../../completed_bookings/completed_bookings.dart';


class AccountAppBar extends StatelessWidget {
  const AccountAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    // Access the user and customer data
    final userProvider = Provider.of<UserProvider>(context);
    final user = userProvider.user;
    final customer = userProvider.customer;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(24.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Check if the user and customer are available before accessing their properties
              Text(
                (user != null && customer != null)
                    ? 'Welcome ${capitalize(customer.firstName)}!' // Access customer-specific data
                    : 'No User Logged In',
                style: TextStyles.headlineLarge,
              ),
              CircleAvatar(
                radius: 30,
                backgroundImage: AssetImage('asset/profilepic.jpeg'),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(14, 20, 12, 0),
          child: GridView.count(
            crossAxisCount: 3,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            mainAxisSpacing: 16.0,
            crossAxisSpacing: 16.0,
            children: [
              const MenuItem(icon: Icons.favorite, label: 'Favorites'),
              MenuItem(
                icon: Icons.history, // Use history icon
                label: 'History',
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => CompletedBookings(), // Navigate to HistoryScreen
                    ),
                  );
                },
              ),
              const MenuItem(icon: Icons.shopping_bag, label: 'Promotions'),
            ],
          ),
        ),
      ],
    );
  }
}

String capitalize(String s) {
  return s.split(' ').map((word) => word[0].toUpperCase() + word.substring(1).toLowerCase()).join(' ');
}

class MenuItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback? onTap; // Add onTap for navigation

  const MenuItem({required this.icon, required this.label, this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap, // Trigger the onTap when tapped
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: TextStyles.primaryColor.withOpacity(0.2),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, size: 40),
          ),
          const SizedBox(height: 8),
          Text(label, style: TextStyles.bodyMedium, textAlign: TextAlign.center),
        ],
      ),
    );
  }
}
