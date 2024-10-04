import 'package:fixitnow/screens/home/home.dart';
import 'package:fixitnow/screens/widgets/navigation_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:fixitnow/screens/widgets/styles.dart';
import 'package:provider/provider.dart';

import '../../models/user_model.dart';
import '../../providers/user_provider.dart';
import '../../services/auth_service.dart';

bool _isChecked = false;

class SignInPage extends StatefulWidget {
  const SignInPage({super.key});

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  // Controllers to retrieve input values
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController phoneNumberController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController cityController = TextEditingController();

  final TextEditingController confirmPasswordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery
        .of(context)
        .size; // Gets screen size
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
        ),
        body: SafeArea(
          child: ListView(
            padding: const EdgeInsets.symmetric(horizontal: 25),
            children: [
              // HEADER
              const Text(
                "Register",
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Text(
                "Create a new account to get started.",
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey,
                ),
              ),
              SizedBox(height: size.height * 0.03),

              // FIRST NAME
              Padding(
                padding: const EdgeInsets.only(bottom: 25),
                child: TextField(
                  controller: firstNameController,
                  decoration: InputDecoration(
                    labelText: 'First Name',
                    labelStyle: TextStyle(color: Colors.grey[600]),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5),
                      borderSide: BorderSide(
                          color: Colors.grey[600]!, width: 2.0),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5),
                      borderSide: BorderSide(
                          color: TextStyles.primaryColor, width: 2.0),
                    ),
                    hintText: 'Enter your first name',
                    hintStyle: TextStyle(color: Colors.grey[400]),
                    filled: true,
                    fillColor: Theme
                        .of(context)
                        .colorScheme
                        .tertiary,
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 20),
                  ),
                ),
              ),

              // LAST NAME
              Padding(
                padding: const EdgeInsets.only(bottom: 25),
                child: TextField(
                  controller: lastNameController,
                  decoration: InputDecoration(
                    labelText: 'Last Name',
                    labelStyle: TextStyle(color: Colors.grey[600]),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5),
                      borderSide: BorderSide(
                          color: Colors.grey[600]!, width: 2.0),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5),
                      borderSide: BorderSide(
                          color: TextStyles.primaryColor, width: 2.0),
                    ),
                    hintText: 'Enter your last name',
                    hintStyle: TextStyle(color: Colors.grey[400]),
                    filled: true,
                    fillColor: Theme
                        .of(context)
                        .colorScheme
                        .tertiary,
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 20),
                  ),
                ),
              ),

              // EMAIL
              Padding(
                padding: const EdgeInsets.only(bottom: 25),
                child: TextField(
                  controller: emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    labelText: 'Email',
                    labelStyle: TextStyle(color: Colors.grey[600]),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5),
                      borderSide: BorderSide(
                          color: Colors.grey[600]!, width: 2.0),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5),
                      borderSide: BorderSide(
                          color: TextStyles.primaryColor, width: 2.0),
                    ),
                    hintText: 'Enter your email',
                    hintStyle: TextStyle(color: Colors.grey[400]),
                    filled: true,
                    fillColor: Theme
                        .of(context)
                        .colorScheme
                        .tertiary,
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 20),
                  ),
                ),
              ),

              // PHONE NUMBER
              Padding(
                padding: const EdgeInsets.only(bottom: 25),
                child: TextField(
                  controller: phoneNumberController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: 'Phone Number',
                    labelStyle: TextStyle(color: Colors.grey[600]),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5),
                      borderSide: BorderSide(
                          color: Colors.grey[600]!, width: 2.0),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5),
                      borderSide: BorderSide(
                          color: TextStyles.primaryColor, width: 2.0),
                    ),
                    hintText: 'Enter your phone number',
                    hintStyle: TextStyle(color: Colors.grey[400]),
                    filled: true,
                    fillColor: Theme
                        .of(context)
                        .colorScheme
                        .tertiary,
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 20),
                  ),
                ),
              ),

              // ADDRESS
              Padding(
                padding: const EdgeInsets.only(bottom: 25),
                child: TextField(
                  controller: addressController,
                  decoration: InputDecoration(
                    labelText: 'Address',
                    labelStyle: TextStyle(color: Colors.grey[600]),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5),
                      borderSide: BorderSide(
                          color: Colors.grey[600]!, width: 2.0),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5),
                      borderSide: BorderSide(
                          color: TextStyles.primaryColor, width: 2.0),
                    ),
                    hintText: 'Enter your address',
                    hintStyle: TextStyle(color: Colors.grey[400]),
                    filled: true,
                    fillColor: Theme
                        .of(context)
                        .colorScheme
                        .tertiary,
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 20),
                  ),
                ),
              ),

              // CITY
              Padding(
                padding: const EdgeInsets.only(bottom: 25),
                child: TextField(
                  controller: cityController,
                  decoration: InputDecoration(
                    labelText: 'City',
                    labelStyle: TextStyle(color: Colors.grey[600]),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5),
                      borderSide: BorderSide(
                          color: Colors.grey[600]!, width: 2.0),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5),
                      borderSide: BorderSide(
                          color: TextStyles.primaryColor, width: 2.0),
                    ),
                    hintText: 'Enter your city',
                    hintStyle: TextStyle(color: Colors.grey[400]),
                    filled: true,
                    fillColor: Theme
                        .of(context)
                        .colorScheme
                        .tertiary,
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 20),
                  ),
                ),
              ),

              // PASSWORD
              Padding(
                padding: const EdgeInsets.only(bottom: 25),
                child: TextField(
                  controller: passwordController,
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: 'Password',
                    labelStyle: TextStyle(color: Colors.grey[600]),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5),
                      borderSide: BorderSide(
                          color: Colors.grey[600]!, width: 2.0),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5),
                      borderSide: BorderSide(
                          color: TextStyles.primaryColor, width: 2.0),
                    ),
                    hintText: 'Enter your password',
                    hintStyle: TextStyle(color: Colors.grey[400]),
                    filled: true,
                    fillColor: Theme
                        .of(context)
                        .colorScheme
                        .tertiary,
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 20),
                    suffixIcon: IconButton(
                      icon: Icon(Icons.visibility_off_outlined,
                          color: TextStyles.primaryColor),
                      onPressed: () {
                        //
                      },
                    ),
                  ),
                ),
              ),

              // CONFIRM PASSWORD
              Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: TextField(
                  controller: confirmPasswordController,
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: 'Confirm Password',
                    labelStyle: TextStyle(color: Colors.grey[600]),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5),
                      borderSide: BorderSide(
                          color: Colors.grey[600]!, width: 2.0),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5),
                      borderSide: BorderSide(
                          color: TextStyles.primaryColor, width: 2.0),
                    ),
                    hintText: 'Confirm your password',
                    hintStyle: TextStyle(color: Colors.grey[400]),
                    filled: true,
                    fillColor: Theme
                        .of(context)
                        .colorScheme
                        .tertiary,
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 20),
                    suffixIcon: IconButton(
                      icon: Icon(Icons.visibility_off_outlined,
                          color: TextStyles.primaryColor),
                      onPressed: () {
                        //
                      },
                    ),
                  ),
                ),
              ),

              // TERMS AND CONDITIONS CHECKBOX
              Row(
                children: [
                  Checkbox(
                    //checks whether the checkbox is checked or not
                    value: _isChecked,
                    onChanged: (value) {
                      setState(() {
                        _isChecked = value!;
                      });
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


              GestureDetector(
                onTap: () async {
                  // Collect input data from the controllers
                  String email = emailController.text;
                  String password = passwordController.text;
                  String firstName = firstNameController.text;
                  String lastName = lastNameController.text;
                  String phoneNumber = phoneNumberController.text;
                  String address = addressController.text;
                  String city = cityController.text;

                  String confirmPassword = confirmPasswordController.text;

                  // Validate passwords
                  if (password != confirmPassword) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("Passwords do not match"),
                        backgroundColor: Colors.red,
                      ),
                    );
                    return;
                  }

                  // Call the AuthService register method
                  try {
                    AuthService authService = AuthService();

                    // Get the registered user as a UserModel
                    UserModel registeredUser = await authService.registerCustomer(
                      email: email,
                      password: password,
                      firstName: firstName,
                      lastName: lastName,
                      phoneNumber: phoneNumber,
                      address: address,
                      city: city,

                    );

                    // Set the user data in the UserProvider
                    Provider.of<UserProvider>(context, listen: false).setUser(registeredUser);

                    // Navigate to the MainNavigationBar screen
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => MainNavigationBar()),
                    );
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text("Registration failed: $e"),
                        backgroundColor: Colors.red,
                      ),
                    );
                  }
                },
                child: Material(
                  elevation: 5,
                  borderRadius: BorderRadius.circular(100),
                  child: Container(
                    width: MediaQuery
                        .of(context)
                        .size
                        .width,
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFF7F66),
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
        )
    );
  }
}
