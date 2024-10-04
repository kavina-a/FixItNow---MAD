import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class PaymentScreen extends StatefulWidget {
  @override
  _PaymentScreenState createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  Map<String, dynamic>? paymentIntentData;

  // Function to start payment process
  Future<void> makePayment() async {
    try {
      // Create a Payment Intent on your backend
      paymentIntentData = await createPaymentIntent('2000', 'usd'); // Amount is in cents (e.g., 2000 = $20.00)

      if (paymentIntentData != null) {
        // Initialize the payment sheet
        await Stripe.instance.initPaymentSheet(
          paymentSheetParameters: SetupPaymentSheetParameters(
            paymentIntentClientSecret: paymentIntentData!['client_secret'],
            applePay: PaymentSheetApplePay(merchantCountryCode: 'US'),
            googlePay: PaymentSheetGooglePay(merchantCountryCode: 'US'),
            style: ThemeMode.light,
            merchantDisplayName: 'FixItNow',
          ),
        );

        // Display the payment sheet to the user
        displayPaymentSheet();
      }
    } catch (e) {
      print('Error while making payment: $e');
    }
  }

  // Display the Stripe payment sheet
  displayPaymentSheet() async {
    try {
      await Stripe.instance.presentPaymentSheet();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Payment successful!')),
      );
      // Handle successful payment
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Payment cancelled')),
      );
      // Handle cancellation
    }
  }

  // Create payment intent by calling your Laravel backend
  Future<Map<String, dynamic>> createPaymentIntent(String amount, String currency) async {
    try {
      var response = await http.post(
        Uri.parse('https://your-backend-url.com/api/payment/intent'),
        body: {
          'amount': amount,
          'currency': currency,
        },
        headers: {
          'Authorization': 'Bearer your-server-side-secret-key', // Add Stripe Secret Key
        },
      );
      return jsonDecode(response.body);
    } catch (err) {
      print('Error creating payment intent: $err');
      throw Exception('Payment intent creation failed');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Make Payment')),
      body: Center(
        child: ElevatedButton(
          onPressed: () async {
            await makePayment();
          },
          child: Text('Pay Now'),
        ),
      ),
    );
  }
}
