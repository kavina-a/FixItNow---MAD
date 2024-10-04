import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import '../../models/user_model.dart';
import '../../providers/user_provider.dart';
import '../../services/auth_service.dart';
import '../widgets/navigation_bar.dart';
import '../widgets/styles.dart';
import '../worker-screens/sp-main.dart';  // Import styles to use primary color

class ServiceProviderRegistration extends StatefulWidget {
  const ServiceProviderRegistration({super.key});

  @override
  State<ServiceProviderRegistration> createState() => _ServiceProviderRegistrationState();
}

class _ServiceProviderRegistrationState extends State<ServiceProviderRegistration> {
  File? _selectedImage;
  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage() async {
    try {
      final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
      if (pickedFile != null) {
        setState(() {
          _selectedImage = File(pickedFile.path);
        });
        print("Image picked successfully: ${pickedFile.path}");
      } else {
        print("No image selected.");
      }
    } catch (e) {
      print("Error picking image: $e");
    }
  }

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController phoneNumberController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController cityController = TextEditingController();
  final TextEditingController experienceController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();

  List<String> selectedServiceTypes = [];
  List<String> selectedLanguages = [];

  final List<String> serviceTypes = [
    "Plumber",
    "Electrician",
    "Carpenter",
    "Painter",
    "Landscaper",
    "Cleaner",
    "Roofer",
    "Mason",
    "Welder"
  ];

  final List<String> languages = ["English", "Sinhala", "Tamil", "Hindi"];

  bool _isChecked = false;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.black),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 25),
          children: [
            const Text(
              "Register as a\nFixItNow Worker!",
              style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
            ),
            const Text(
              "Create a new account to get started.",
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
            SizedBox(height: size.height * 0.03),

            // Updated Image Upload section (Circular Image Preview)
            Center(
              child: Stack(
                children: [
                  CircleAvatar(
                    radius: 60,
                    backgroundColor: Colors.grey[300],
                    backgroundImage:
                    _selectedImage != null ? FileImage(_selectedImage!) : null,
                    child: _selectedImage == null
                        ? Icon(
                      Icons.person,
                      size: 60,
                      color: Colors.grey[600],
                    )
                        : null,
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: GestureDetector(
                      onTap: _pickImage,
                      child: CircleAvatar(
                        radius: 20,
                        backgroundColor: TextStyles.primaryColor,
                        child: Icon(
                          Icons.camera_alt,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),

            // First Name
            buildTextField(
              controller: firstNameController,
              labelText: 'First Name',
              hintText: 'Enter your first name',
            ),
            // Last Name
            buildTextField(
              controller: lastNameController,
              labelText: 'Last Name',
              hintText: 'Enter your last name',
            ),
            // Email
            buildTextField(
              controller: emailController,
              labelText: 'Email',
              hintText: 'Enter your email',
              keyboardType: TextInputType.emailAddress,
            ),
            // Phone Number
            buildTextField(
              controller: phoneNumberController,
              labelText: 'Phone Number',
              hintText: 'Enter your phone number',
              keyboardType: TextInputType.phone,
            ),
            // Address
            buildTextField(
              controller: addressController,
              labelText: 'Address',
              hintText: 'Enter your address',
            ),
            // City
            buildTextField(
              controller: cityController,
              labelText: 'City',
              hintText: 'Enter your city',
            ),
            // Years of Experience
            buildTextField(
              controller: experienceController,
              labelText: 'Years of Experience',
              hintText: 'Enter your years of experience',
              keyboardType: TextInputType.number,
            ),
            // Description
            buildTextField(
              controller: descriptionController,
              labelText: 'Description',
              hintText: 'Enter a brief description',
            ),

            SizedBox(height: 20),

            // Service Type Selection Button (Updated UI)
            ElevatedButton(
              onPressed: _showServiceTypeDialog,
              style: ElevatedButton.styleFrom(
                iconColor: TextStyles.primaryColor, // Use primary color
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
              ),
              child: const Text('Select Service Types'),
            ),
            if (selectedServiceTypes.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 10),
                child: Text(
                  'Selected Service Types: ${selectedServiceTypes.join(', ')}',
                  style: TextStyle(color: Colors.grey[600]),
                ),
              ),

            SizedBox(height: 20),

            // Language Selection Button (Updated UI)
            ElevatedButton(
              onPressed: _showLanguageDialog,
              style: ElevatedButton.styleFrom(
                iconColor: TextStyles.primaryColor, // Use primary color
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
              ),
              child: const Text('Select Languages'),
            ),
            if (selectedLanguages.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 10),
                child: Text(
                  'Selected Languages: ${selectedLanguages.join(', ')}',
                  style: TextStyle(color: Colors.grey[600]),
                ),
              ),

            SizedBox(height: 20),

            // Password
            buildPasswordField(
                passwordController, 'Password', 'Enter your password'),
            // Confirm Password
            buildPasswordField(confirmPasswordController, 'Confirm Password',
                'Confirm your password'),

            // Terms and Conditions Checkbox
            Row(
              children: [
                Checkbox(
                  value: _isChecked,
                  onChanged: (value) {
                    setState(() {
                      _isChecked = value!;
                    });
                    print("Terms and Conditions checked: $_isChecked");
                  },
                  activeColor: TextStyles.primaryColor,
                ),
                const Text(
                  'I agree to the Terms and Conditions',
                  style: TextStyle(fontSize: 14, color: Colors.grey),
                ),
              ],
            ),
            SizedBox(height: size.height * 0.03),

// REGISTER BUTTON
            GestureDetector(
              onTap: () async {
                print("Register button pressed");

                if (passwordController.text != confirmPasswordController.text) {
                  print("Passwords do not match");
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Passwords do not match"), backgroundColor: Colors.red),
                  );
                  return;
                }

                print("Starting registration process...");
                try {
                  AuthService authService = AuthService();

                  // Debugging form data before sending request
                  print("Email: ${emailController.text}");
                  print("First Name: ${firstNameController.text}");
                  print("Last Name: ${lastNameController.text}");
                  print("Phone Number: ${phoneNumberController.text}");
                  print("Address: ${addressController.text}");
                  print("City: ${cityController.text}");
                  print("Years of Experience: ${experienceController.text}");
                  print("Service Types: $selectedServiceTypes");
                  print("Languages: $selectedLanguages");
                  print("Selected Image: ${_selectedImage?.path}");

                  // Register service provider, passing the image if available
                  UserModel registeredUser = await authService.registerServiceProvider(
                    email: emailController.text,
                    password: passwordController.text,
                    firstName: firstNameController.text,
                    lastName: lastNameController.text,
                    phoneNumber: phoneNumberController.text,
                    address: addressController.text,
                    city: cityController.text,
                    yearsOfExperience: int.parse(experienceController.text),
                    serviceType: selectedServiceTypes,
                    description: descriptionController.text,
                    languages: selectedLanguages,
                    profileImage: _selectedImage,  // Pass the selected image here
                  );

                  print("User registered successfully");

                  // Update the user in the UserProvider
                  Provider.of<UserProvider>(context, listen: false).setUser(registeredUser);

                  // Navigate to the main screen
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => ServiceProviderApp()),
                  );
                } catch (e) {
                  print("Error during registration: $e");
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("Registration failed: $e"), backgroundColor: Colors.red),
                  );
                }
              },
              child: Material(
                elevation: 5,
                borderRadius: BorderRadius.circular(100),
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  decoration: BoxDecoration(
                    color: TextStyles.primaryColor, // Use primary color
                    borderRadius: BorderRadius.circular(100),
                  ),
                  child: const Center(
                    child: Text(
                      "Register",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        fontSize: 22,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildTextField({
    required TextEditingController controller,
    required String labelText,
    required String hintText,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 25),
      child: TextField(
        controller: controller,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          labelText: labelText,
          labelStyle: TextStyle(color: Colors.grey[600]),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(5),
            borderSide: BorderSide(color: Colors.grey[600]!, width: 2.0),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(5),
            borderSide: BorderSide(color: TextStyles.primaryColor, width: 2.0),
          ),
          hintText: hintText,
          hintStyle: TextStyle(color: Colors.grey[400]),
          filled: true,
          fillColor: Theme.of(context).colorScheme.tertiary,
          contentPadding: const EdgeInsets.symmetric(
              horizontal: 20, vertical: 20),
        ),
      ),
    );
  }

  Widget buildPasswordField(TextEditingController controller, String labelText,
      String hintText) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 25),
      child: TextField(
        controller: controller,
        obscureText: true,
        decoration: InputDecoration(
          labelText: labelText,
          labelStyle: TextStyle(color: Colors.grey[600]),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(5),
            borderSide: BorderSide(color: Colors.grey[600]!, width: 2.0),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(5),
            borderSide: BorderSide(color: TextStyles.primaryColor, width: 2.0),
          ),
          hintText: hintText,
          hintStyle: TextStyle(color: Colors.grey[400]),
          filled: true,
          fillColor: Theme.of(context).colorScheme.tertiary,
          contentPadding: const EdgeInsets.symmetric(
              horizontal: 20, vertical: 20),
        ),
      ),
    );
  }

  void _showServiceTypeDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.black87, // Dark background for a sleek look
          title: const Text(
              'Select Service Types', style: TextStyle(color: Colors.white)),
          content: StatefulBuilder(
            builder: (context, setState) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: serviceTypes.map((serviceType) {
                  return CheckboxListTile(
                    title: Text(serviceType, style: const TextStyle(
                        color: Colors.white)),
                    activeColor: Colors.orange,
                    value: selectedServiceTypes.contains(serviceType),
                    onChanged: (bool? selected) {
                      setState(() {
                        if (selected == true &&
                            !selectedServiceTypes.contains(serviceType)) {
                          selectedServiceTypes.add(
                              serviceType); // Add to the list
                        } else {
                          selectedServiceTypes.remove(
                              serviceType); // Remove from the list
                        }
                      });
                      print("Selected Service Types: $selectedServiceTypes");
                    },
                  );
                }).toList(),
              );
            },
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text(
                  'Close', style: TextStyle(color: Colors.orange)),
            ),
          ],
        );
      },
    );
  }

  void _showLanguageDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.black87, // Dark background for a sleek look
          title: const Text(
              'Select Languages', style: TextStyle(color: Colors.white)),
          content: StatefulBuilder(
            builder: (context, setState) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: languages.map((language) {
                  return CheckboxListTile(
                    title: Text(language, style: const TextStyle(
                        color: Colors.white)),
                    activeColor: Colors.orange,
                    value: selectedLanguages.contains(language),
                    onChanged: (bool? selected) {
                      setState(() {
                        if (selected == true &&
                            !selectedLanguages.contains(language)) {
                          selectedLanguages.add(language); // Add to the list
                        } else {
                          selectedLanguages.remove(language); // Remove from the list
                        }
                      });
                      print("Selected Languages: $selectedLanguages");
                    },
                  );
                }).toList(),
              );
            },
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text(
                  'Close', style: TextStyle(color: Colors.orange)),
            ),
          ],
        );
      },
    );
  }
}
