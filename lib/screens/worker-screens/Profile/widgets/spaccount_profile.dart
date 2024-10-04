import 'dart:io';
import 'package:flutter/material.dart';
import 'package:fixitnow/services/profile_service.dart';
import 'package:fixitnow/models/serviceprovider_model.dart';
import 'package:image_picker/image_picker.dart';

import '../../../widgets/styles.dart';

class ServiceProviderProfileScreen extends StatefulWidget {
  @override
  _ServiceProviderProfileScreenState createState() => _ServiceProviderProfileScreenState();
}

class _ServiceProviderProfileScreenState extends State<ServiceProviderProfileScreen> {
  final ProfileService _profileService = ProfileService();
  late Future<ServiceProviderModel> _profile;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  File? _profileImage;

  String? firstName;
  String? lastName;
  String? phoneNumber;
  String? address;
  String? city;
  String? description;
  int? yearsOfExperience;

  @override
  void initState() {
    super.initState();
    _profile = _profileService.getServiceProviderProfile();
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _profileImage = File(pickedFile.path);
      });
    }
  }

  void _updateProfile() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      _profileService
          .updateServiceProviderProfile(
        firstName: firstName,
        lastName: lastName,
        phoneNumber: phoneNumber,
        address: address,
        city: city,
        description: description,
        yearsOfExperience: yearsOfExperience,
        profileImage: _profileImage,
      )
          .then((_) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Profile updated successfully')));
      }).catchError((error) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to update profile: $error')));
      });
    }
  }

  Widget _buildTextFormField({
    required String labelText,
    required String initialValue,
    required Function(String?) onSaved,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        initialValue: initialValue,
        decoration: InputDecoration(
          labelText: labelText,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          contentPadding: EdgeInsets.symmetric(vertical: 18, horizontal: 16),
        ),
        onSaved: onSaved,
        keyboardType: keyboardType,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<ServiceProviderModel>(
        future: _profile,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            final profile = snapshot.data!;
            return SingleChildScrollView(
              child: Column(
                children: [
                  Stack(
                    clipBehavior: Clip.none,
                    children: [
                      // AppBar with gradient
                      Container(
                        height: 225,
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
                      // Profile Picture
                      Positioned(
                        top: 140,
                        left: 0,
                        right: 0,
                        child: Column(
                          children: [
                            GestureDetector(
                              onTap: _pickImage,
                              child: CircleAvatar(
                                radius: 75,
                                backgroundImage: _profileImage != null
                                    ? FileImage(_profileImage!)
                                    : (profile.profileImage != null && profile.profileImage.isNotEmpty
                                    ? NetworkImage(
                                  profile.profileImage.startsWith('http')
                                      ? profile.profileImage
                                      : 'http://10.0.2.2:8000/${profile.profileImage}',
                                )
                                    : const AssetImage('assets/placeholder.png')) as ImageProvider,
                              ),
                            ),
                            TextButton(
                              onPressed: _pickImage,
                              child: const Text(
                                'Change Picture',
                                style: TextStyle(color: Colors.redAccent),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 150), // Space for profile image
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildTextFormField(
                            labelText: 'First Name',
                            initialValue: profile.firstName,
                            onSaved: (value) => firstName = value,
                          ),
                          SizedBox(height: 12),
                          _buildTextFormField(
                            labelText: 'Last Name',
                            initialValue: profile.lastName,
                            onSaved: (value) => lastName = value,
                          ),
                          SizedBox(height: 12),
                          _buildTextFormField(
                            labelText: 'Phone Number',
                            initialValue: profile.phoneNumber,
                            onSaved: (value) => phoneNumber = value,
                            keyboardType: TextInputType.phone,
                          ),
                          SizedBox(height: 12),
                          _buildTextFormField(
                            labelText: 'Address',
                            initialValue: profile.address,
                            onSaved: (value) => address = value,
                          ),
                          SizedBox(height: 12),
                          _buildTextFormField(
                            labelText: 'City',
                            initialValue: profile.city,
                            onSaved: (value) => city = value,
                          ),
                          SizedBox(height: 12),
                          _buildTextFormField(
                            labelText: 'Description',
                            initialValue: profile.description,
                            onSaved: (value) => description = value,
                          ),                          SizedBox(height: 12),


                          _buildTextFormField(
                            labelText: 'Years of Experience',
                            initialValue: profile.yearsOfExperience!.toString(),
                            keyboardType: TextInputType.number,
                            onSaved: (value) => yearsOfExperience = int.tryParse(value!),
                          ),
                          const SizedBox(height: 32),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: _updateProfile,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: TextStyles.primaryColor,
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
            );
          }
        },
      ),
    );
  }
}
