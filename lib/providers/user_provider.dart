import 'package:flutter/material.dart';
import '../models/ServiceProviderLoginModel.dart';
import '../models/serviceprovider_model.dart';
import '../models/user_model.dart';
import '../models/customer_model.dart';  // Import the CustomerModel
import '../services/auth_service.dart';  // Import the AuthService

class UserProvider with ChangeNotifier {
  UserModel? _user;
  CustomerModel? _customer;
  ServiceProviderLoginModel? _serviceProvider; // Add ServiceProviderModel

  // Getter to access the user data
  UserModel? get user => _user;

  // Getter to access the customer data
  CustomerModel? get customer => _customer;

  // Getter to access the service provider data
  ServiceProviderLoginModel? get serviceProvider => _serviceProvider;

  // Method to set the user data after registration or login
  void setUser(UserModel user) {
    _user = user;
    notifyListeners();
  }

  // Method to set the customer data
  void setCustomer(CustomerModel customer) {
    _customer = customer;
    notifyListeners();
  }

  // Method to set the service provider data
  void setServiceProvider(ServiceProviderLoginModel serviceProvider) {
    _serviceProvider = serviceProvider;
    notifyListeners();
  }

  // Clear user, customer, and service provider data (for logout)
  void clearData() {
    _user = null;
    _customer = null;
    _serviceProvider = null;
    notifyListeners();
  }

  // Add login method here if login is user-specific
  Future<void> login(String email, String password) async {
    try {
      final result = await AuthService().loginUser(email: email, password: password);

      // Extract the user from the result
      final user = result['user'] as UserModel;

      // Check the user's role and set the correct profile
      if (user.role == 'customer') {
        final customer = result['profile'] as CustomerModel;
        setUser(user);
        setCustomer(customer);  // Set customer profile
      } else if (user.role == 'service_provider') {
        final serviceProvider = result['profile'] as ServiceProviderLoginModel;
        setUser(user);
        setServiceProvider(serviceProvider);  // Set service provider profile
      } else {
        throw Exception('Unknown role: ${user.role}');
      }

    } catch (error) {
      throw Exception('Login failed: $error');
    }
  }
}
