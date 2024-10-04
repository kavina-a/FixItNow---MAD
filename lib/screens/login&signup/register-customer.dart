import 'package:flutter/material.dart';
import 'package:fixitnow/screens/widgets/styles.dart';

bool _isChecked = false;

class CustomerRegistrationScreen extends StatefulWidget {
  @override
  _CustomerRegistrationScreenState createState() => _CustomerRegistrationScreenState();
}

class _CustomerRegistrationScreenState extends State<CustomerRegistrationScreen> {
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController cityController = TextEditingController();
  final TextEditingController stateController = TextEditingController();
  final TextEditingController postalCodeController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size; // Gets screen size
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 25),
          physics: const NeverScrollableScrollPhysics(),
          children: [
            // HEADER
            const Text(
              "Register as Customer",
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Text(
              "Create a new customer account to get started.",
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey,
              ),
            ),

            SizedBox(height: size.height * 0.03),

            // INPUT FIELD FOR FIRST NAME
            Padding(
              padding: const EdgeInsets.only(bottom: 25),
              child: TextField(
                controller: firstNameController,
                decoration: InputDecoration(
                  labelText: 'First Name',
                  labelStyle: TextStyle(
                    color: Colors.grey[600],
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5),
                    borderSide: BorderSide(
                      color: Colors.grey[600]!,
                      width: 2.0,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5),
                    borderSide: BorderSide(
                      color: TextStyles.primaryColor,
                      width: 2.0,
                    ),
                  ),
                  hintText: 'Enter your first name',
                  hintStyle: TextStyle(color: Colors.grey[400]),
                  filled: true,
                  fillColor: Theme.of(context).colorScheme.tertiary,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                ),
              ),
            ),

            // INPUT FIELD FOR LAST NAME
            Padding(
              padding: const EdgeInsets.only(bottom: 25),
              child: TextField(
                controller: lastNameController,
                decoration: InputDecoration(
                  labelText: 'Last Name',
                  labelStyle: TextStyle(
                    color: Colors.grey[600],
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5),
                    borderSide: BorderSide(
                      color: Colors.grey[600]!,
                      width: 2.0,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5),
                    borderSide: BorderSide(
                      color: TextStyles.primaryColor,
                      width: 2.0,
                    ),
                  ),
                  hintText: 'Enter your last name',
                  hintStyle: TextStyle(color: Colors.grey[400]),
                  filled: true,
                  fillColor: Theme.of(context).colorScheme.tertiary,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                ),
              ),
            ),

            // INPUT FIELD FOR EMAIL
            Padding(
              padding: const EdgeInsets.only(bottom: 25),
              child: TextField(
                controller: emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  labelText: 'Email',
                  labelStyle: TextStyle(
                    color: Colors.grey[600],
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5),
                    borderSide: BorderSide(
                      color: Colors.grey[600]!,
                      width: 2.0,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5),
                    borderSide: BorderSide(
                      color: TextStyles.primaryColor,
                      width: 2.0,
                    ),
                  ),
                  hintText: 'Enter your email',
                  hintStyle: TextStyle(color: Colors.grey[400]),
                  filled: true,
                  fillColor: Theme.of(context).colorScheme.tertiary,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                ),
              ),
            ),

            // INPUT FIELD FOR PHONE NUMBER - NUMERIC FIELD
            Padding(
              padding: const EdgeInsets.only(bottom: 25),
              child: TextField(
                controller: phoneController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Phone Number',
                  labelStyle: TextStyle(
                    color: Colors.grey[600],
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5),
                    borderSide: BorderSide(
                      color: Colors.grey[600]!,
                      width: 2.0,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5),
                    borderSide: BorderSide(
                      color: TextStyles.primaryColor,
                      width: 2.0,
                    ),
                  ),
                  hintText: 'Enter your phone number',
                  hintStyle: TextStyle(color: Colors.grey[400]),
                  filled: true,
                  fillColor: Theme.of(context).colorScheme.tertiary,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                ),
              ),
            ),

            // INPUT FIELD FOR ADDRESS
            Padding(
              padding: const EdgeInsets.only(bottom: 25),
              child: TextField(
                controller: addressController,
                decoration: InputDecoration(
                  labelText: 'Address',
                  labelStyle: TextStyle(
                    color: Colors.grey[600],
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5),
                    borderSide: BorderSide(
                      color: Colors.grey[600]!,
                      width: 2.0,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5),
                    borderSide: BorderSide(
                      color: TextStyles.primaryColor,
                      width: 2.0,
                    ),
                  ),
                  hintText: 'Enter your address',
                  hintStyle: TextStyle(color: Colors.grey[400]),
                  filled: true,
                  fillColor: Theme.of(context).colorScheme.tertiary,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                ),
              ),
            ),

            // INPUT FIELD FOR CITY
            Padding(
              padding: const EdgeInsets.only(bottom: 25),
              child: TextField(
                controller: cityController,
                decoration: InputDecoration(
                  labelText: 'City',
                  labelStyle: TextStyle(
                    color: Colors.grey[600],
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5),
                    borderSide: BorderSide(
                      color: Colors.grey[600]!,
                      width: 2.0,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5),
                    borderSide: BorderSide(
                      color: TextStyles.primaryColor,
                      width: 2.0,
                    ),
                  ),
                  hintText: 'Enter your city',
                  hintStyle: TextStyle(color: Colors.grey[400]),
                  filled: true,
                  fillColor: Theme.of(context).colorScheme.tertiary,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                ),
              ),
            ),

            // INPUT FIELD FOR STATE
            Padding(
              padding: const EdgeInsets.only(bottom: 25),
              child: TextField(
                controller: stateController,
                decoration: InputDecoration(
                  labelText: 'State',
                  labelStyle: TextStyle(
                    color: Colors.grey[600],
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5),
                    borderSide: BorderSide(
                      color: Colors.grey[600]!,
                      width: 2.0,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5),
                    borderSide: BorderSide(
                      color: TextStyles.primaryColor,
                      width: 2.0,
                    ),
                  ),
                  hintText: 'Enter your state',
                  hintStyle: TextStyle(color: Colors.grey[400]),
                  filled: true,
                  fillColor: Theme.of(context).colorScheme.tertiary,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                ),
              ),
            ),

            // INPUT FIELD FOR POSTAL CODE
            Padding(
              padding: const EdgeInsets.only(bottom: 25),
              child: TextField(
                controller: postalCodeController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Postal Code',
                  labelStyle: TextStyle(
                    color: Colors.grey[600],
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5),
                    borderSide: BorderSide(
                      color: Colors.grey[600]!,
                      width: 2.0,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5),
                    borderSide: BorderSide(
                      color: TextStyles.primaryColor,
                      width: 2.0,
                    ),
                  ),
                  hintText: 'Enter your postal code',
                  hintStyle: TextStyle(color: Colors.grey[400]),
                  filled: true,
                  fillColor: Theme.of(context).colorScheme.tertiary,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                ),
              ),
            ),

            // INPUT FIELD FOR PASSWORD
            Padding(
              padding: const EdgeInsets.only(bottom: 25),
              child: TextField(
                controller: passwordController,
                decoration: InputDecoration(
                  labelText: 'Password',
                  labelStyle: TextStyle(
                    color: Colors.grey[600],
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5),
                    borderSide: BorderSide(
                      color: Colors.grey[600]!,
                      width: 2.0,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5),
                    borderSide: BorderSide(
                      color: TextStyles.primaryColor,
                      width: 2.0,
                    ),
                  ),
                  hintText: 'Enter your password',
                  hintStyle: TextStyle(color: Colors.grey[400]),
                  filled: true,
                  fillColor: Theme.of(context).colorScheme.tertiary,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                  suffixIcon: IconButton(
                    icon: Icon(Icons.visibility_off_outlined, color: TextStyles.primaryColor),
                    onPressed: () {
                      // Add functionality for visibility toggle
                    },
                  ),
                ),
              ),
            ),

            // INPUT FIELD FOR CONFIRM PASSWORD
            Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: TextField(
                controller: confirmPasswordController,
                decoration: InputDecoration(
                  labelText: 'Confirm Password',
                  labelStyle: TextStyle(
                    color: Colors.grey[600],
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5),
                    borderSide: BorderSide(
                      color: Colors.grey[600]!,
                      width: 2.0,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5),
                    borderSide: BorderSide(
                      color: TextStyles.primaryColor,
                      width: 2.0,
                    ),
                  ),
                  hintText: 'Confirm your password',
                  hintStyle: TextStyle(color: Colors.grey[400]),
                  filled: true,
                  fillColor: Theme.of(context).colorScheme.tertiary,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                  suffixIcon: IconButton(
                    icon: Icon(Icons.visibility_off_outlined, color: TextStyles.primaryColor),
                    onPressed: () {
                      // Add functionality for visibility toggle
                    },
                  ),
                ),
              ),
            ),

            // TERMS AND CONDITIONS CHECKBOX
            Row(
              children: [
                Checkbox(
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
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),

            SizedBox(height: size.height * 0.03),

            // REGISTER BUTTON
            GestureDetector(
              onTap: () {
                // Implement registration logic here
              },
              child: Material(
                elevation: 5,
                borderRadius: BorderRadius.circular(100),
                child: Container(
                  width: size.width,
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
      ),
    );
  }
}
