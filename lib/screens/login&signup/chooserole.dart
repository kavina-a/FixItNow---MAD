import 'package:flutter/material.dart';

import '../widgets/styles.dart';

class RoleSelectionPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Get current theme brightness
    bool isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,  // Use the theme's background color
      // AppBar with back arrow button
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,  // Use the theme's background color
        elevation: 0,  // Remove the shadow for a clean look
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Theme.of(context).iconTheme.color),  // Adapt icon color to theme
          onPressed: () => Navigator.of(context).pop(),  // Go back to the previous screen
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 10),
              // Interactive Header with Subtitle
              Text(
                "Who Are You?",
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: TextStyles.primaryColor,  // Keep the custom primary color
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 10),
              Text(
                "Build your profile and unlock the benefits of FixItNow.",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w400,
                  color: isDarkMode ? Colors.grey[400] : Colors.grey[600],  // Adapt color based on dark mode
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 50),
              // First Expanded Role Card
              GestureDetector(
                onTap: () {
                  Navigator.pushNamed(context, '/customer');
                },
                child: RoleCard(
                  imagePath: 'asset/customer-chooserole.jpg',
                  role: "FixItNow: Find the Right Help Fast!",
                  expandedHeight: 200, // Increase height for a more prominent look
                ),
              ),
              const SizedBox(height: 30),
              // Second Expanded Role Card
              GestureDetector(
                onTap: () {
                  Navigator.pushNamed(context, '/service-provider');
                },
                child: RoleCard(
                  imagePath: 'asset/worker-chooserole.jpg',
                  role: "FixItPro: Offer Your Skills, Find Clients",
                  expandedHeight: 200, // Increase height for a more prominent look
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class RoleCard extends StatelessWidget {
  final String imagePath;
  final String role;
  final double expandedHeight; // Added variable for customizable height

  RoleCard({
    required this.imagePath,
    required this.role,
    this.expandedHeight = 180, // Default to 180 if not provided
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: expandedHeight, // Use customizable height
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            spreadRadius: 2,
            blurRadius: 5,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Stack(
        children: [
          // Full background image
          ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: Image.asset(
              imagePath,
              height: expandedHeight,
              width: double.infinity,
              fit: BoxFit.cover,  // Ensures the image covers the entire container
            ),
          ),
          // Semi-transparent overlay for readability
          Container(
            height: expandedHeight,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: Colors.black.withOpacity(0.4),  // Dark overlay for text contrast
            ),
          ),
          // Role text on top of the image
          Center(
            child: Text(
              role,
              style: const TextStyle(
                fontSize: 24,  // Increased font size for better readability
                fontWeight: FontWeight.bold,
                color: Colors.white,  // White text for high contrast
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}
