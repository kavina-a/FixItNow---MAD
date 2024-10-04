import 'package:fixitnow/screens/login&signup/chooserole.dart';
import 'package:fixitnow/screens/login&signup/signup.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fixitnow/screens/home/home.dart';
import 'package:fixitnow/screens/widgets/navigation_bar.dart';
import 'package:fixitnow/screens/widgets/styles.dart';
import 'package:fixitnow/services/auth_service.dart';
import 'package:fixitnow/providers/user_provider.dart';
import 'package:fixitnow/models/user_model.dart';
import 'package:fixitnow/models/customer_model.dart';

import '../../models/ServiceProviderLoginModel.dart';
import '../../models/serviceprovider_model.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  bool _isLoading = false;

  // Handle Login
  // Handle Login
  Future<void> _login(BuildContext context) async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      try {
        final userProvider = Provider.of<UserProvider>(context, listen: false);

        // Call the AuthService login function
        final result = await AuthService().loginUser(
          email: _emailController.text,
          password: _passwordController.text,
        );

        if (result != null) {
          // Extract user, role, and token from the result
          final user = result['user'] as UserModel;
          final role = user.role;
          final token = result['token'];

          // Set user data in the provider
          userProvider.setUser(user);

          // Handle different roles and profiles
          if (role == 'customer') {
            // Extract and set customer data
            final customer = result['profile'] as CustomerModel;
            userProvider.setCustomer(customer);

            // Navigate to the Customer screen
            Navigator.pushReplacementNamed(context, '/customer/home');
          } else if (role == 'service_provider') {
            // Extract and set service provider data
            final serviceProvider = result['profile'] as ServiceProviderLoginModel;
            userProvider.setServiceProvider(serviceProvider);

            // Navigate to the Service Provider screen
            Navigator.pushReplacementNamed(context, '/service-provider/home');
          } else {
            // Handle unknown roles
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Invalid role detected.')),
            );
          }
        }
      } catch (error) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Login failed: $error')),
        );
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }



  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size; // Gets screen size
    Brightness brightness = Theme.of(context).brightness;
    String imagePath =
    brightness == Brightness.light ? 'asset/logo.light.png' : 'asset/logo.dark.png';

    return Scaffold(
      body: Container(
        child: SafeArea(
          child: ListView(
            physics: const NeverScrollableScrollPhysics(),
            children: [
              // LOGO PART
              Container(
                height: size.height * 0.34,
                width: size.height * 0.3,
                child: Image.asset(imagePath),
              ),
              Form(
                key: _formKey,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25),
                  child: Column(
                    children: [
                      // INPUT FIELD FOR EMAIL
                      TextFormField(
                        controller: _emailController,
                        decoration: InputDecoration(
                          labelText: 'Email',
                          labelStyle: TextStyle(
                            color: Colors.grey[400],
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
                          hintStyle: TextStyle(
                            color: Colors.grey[400],
                          ),
                          filled: true,
                          fillColor: Theme.of(context).colorScheme.tertiary,
                          contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                        ),
                        keyboardType: TextInputType.emailAddress,
                        validator: (value) {
                          if (value == null || value.isEmpty || !value.contains('@')) {
                            return 'Enter a valid email';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 20),

                      // INPUT FIELD FOR PASSWORD
                      TextFormField(
                        controller: _passwordController,
                        obscureText: true,
                        decoration: InputDecoration(
                          labelText: 'Password',
                          labelStyle: TextStyle(
                            color: Colors.grey[400],
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
                          hintStyle: TextStyle(
                            color: Colors.grey[400],
                          ),
                          filled: true,
                          fillColor: Theme.of(context).colorScheme.tertiary,
                          contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                        ),
                        validator: (value) {
                          if (value == null || value.length < 8) {
                            return 'Password must be at least 8 characters long';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 20),

                      // FORGOT PASSWORD
                      Align(
                        alignment: Alignment.centerRight,
                        child: Text(
                          "Forgot Password?",
                          style: TextStyles.captions,
                        ),
                      ),

                      const SizedBox(height: 40),

                      // Sign in button
                      GestureDetector(
                        onTap: () => _login(context),
                        child: Material(
                          elevation: 5,
                          borderRadius: BorderRadius.circular(100),
                          child: Container(
                            width: size.width,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            decoration: BoxDecoration(
                              color: TextStyles.primaryColor,
                              borderRadius: BorderRadius.circular(100),
                            ),
                            child: _isLoading
                                ? const Center(child: CircularProgressIndicator(color: Colors.white))
                                : const Center(
                              child: Text(
                                "Sign In",
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
              ),
              const SizedBox(height: 40),

              // OR CONTINUE WITH SECTION
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    height: 1.5,
                    width: size.width * 0.2,
                    color: TextStyles.primaryColor,
                  ),
                  Text("  Or continue with   ", style: TextStyles.bodyMedium),
                  Container(
                    height: 1.5,
                    width: size.width * 0.2,
                    color: TextStyles.primaryColor,
                  ),
                ],
              ),

              const SizedBox(height: 10),

              // Social Media login buttons (Facebook and Google)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: 35,
                      height: 40,
                      child: Image.asset('asset/fblogo.png'),
                    ),
                    const SizedBox(width: 15),
                    SizedBox(
                      width: 35,
                      height: 40,
                      child: Image.asset('asset/google.png'),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 40),

              // Register now link
              Center(
                child: RichText(
                  text: TextSpan(
                    text: "Not a member? ",
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onSurface,
                      fontSize: 14,
                    ),
                    children: [
                      WidgetSpan(
                        alignment: PlaceholderAlignment.baseline,
                        baseline: TextBaseline.alphabetic,
                        child: GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                                MaterialPageRoute(builder: (context) => RoleSelectionPage()),
                            );
                          },
                          child: const Text(
                            "Register now",
                            style: TextStyle(
                              color: Color(0xFFFF7F66),
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
