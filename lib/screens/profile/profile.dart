import 'package:flutter/material.dart';
import 'package:fixitnow/services/profile_service.dart';

class CustomerProfileUpdateScreen extends StatefulWidget {
  const CustomerProfileUpdateScreen({Key? key}) : super(key: key);

  @override
  _CustomerProfileUpdateScreenState createState() => _CustomerProfileUpdateScreenState();
}

class _CustomerProfileUpdateScreenState extends State<CustomerProfileUpdateScreen> {
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _cityController = TextEditingController();

  // Function to fetch the current user profile information
  void _fetchCurrentProfile() async {
    try {
      final profileData = await ProfileService().fetchCustomerProfile();

      // Set the controllers' text with the fetched profile data
      _firstNameController.text = profileData['first_name'] ?? '';
      _lastNameController.text = profileData['last_name'] ?? '';
      _phoneNumberController.text = profileData['phone_number'] ?? '';
      _addressController.text = profileData['address'] ?? '';
      _cityController.text = profileData['city'] ?? '';
    } catch (e) {
      print('Failed to fetch profile data: $e');
      // Handle error, e.g., show a snackbar or alert
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchCurrentProfile(); // Load current user profile information
  }

  void _updateProfile() async {
    try {
      await ProfileService().updateCustomerProfile(
        firstName: _firstNameController.text,
        lastName: _lastNameController.text,
        phoneNumber: _phoneNumberController.text,
        address: _addressController.text,
        city: _cityController.text,
      );
      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Profile updated successfully!')),
      );
    } catch (e) {
      // Show error message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to update profile: $e')),
      );
    }
  }

  Widget _buildTextFormField({
    required String labelText,
    required TextEditingController controller,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          labelText: labelText,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          contentPadding: const EdgeInsets.symmetric(vertical: 18, horizontal: 16),
        ),
        keyboardType: keyboardType,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Stack(
              clipBehavior: Clip.none,
              children: [
                // AppBar with gradient
                Container(
                  height: 150,
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Colors.redAccent, Colors.orangeAccent],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                  ),
                ),
                Positioned(
                  top: 50,
                  left: 16,
                  child: IconButton(
                    icon: const Icon(Icons.arrow_back, color: Colors.white),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ),
                Positioned(
                  top: 50,
                  right: 16,
                  child: IconButton(
                    icon: const Icon(Icons.share, color: Colors.white),
                    onPressed: () {
                      // Action for sharing
                    },
                  ),
                ),
                // Title text in place of profile image
                Positioned(
                  top: 100,
                  left: 0,
                  right: 0,
                  child: Center(
                    child: Column(
                      children: const [
                        Text(
                          'Update Profile',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 80), // Space to push the form down
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Form(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildTextFormField(
                      labelText: 'First Name',
                      controller: _firstNameController,
                    ),
                    SizedBox(height: 12),
                    _buildTextFormField(
                      labelText: 'Last Name',
                      controller: _lastNameController,
                    ),
                    SizedBox(height: 12),
                    _buildTextFormField(
                      labelText: 'Phone Number',
                      controller: _phoneNumberController,
                      keyboardType: TextInputType.phone,
                    ),
                    SizedBox(height: 12),
                    _buildTextFormField(
                      labelText: 'Address',
                      controller: _addressController,
                    ),
                    SizedBox(height: 12),
                    _buildTextFormField(
                      labelText: 'City',
                      controller: _cityController,
                    ),
                    const SizedBox(height: 32),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _updateProfile,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.black87,
                          padding: const EdgeInsets.symmetric(vertical: 16.0),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12.0),
                          ),
                        ),
                        child: const Text(
                          "Update Profile",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                    const SizedBox(height: 32),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
