import 'dart:convert';

import 'package:due_management/amount.dart';
import 'package:due_management/config.dart';
import 'package:due_management/user_preferences.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String username =
      "John Doe"; // Default username before loading from UserPreferences
  String phoneNumber = "123-456-7890";

  @override
  void initState() {
    super.initState();
    _loadUsername();
    _loadPhoneNumber();
  }

  void _loadUsername() async {
    String? storedUsername = await UserPreferences.getName();
    if (storedUsername != null && storedUsername.isNotEmpty) {
      setState(() {
        username = storedUsername;
      });
    }
  }

  Future<int?> fetchAmount() async {
    int? storedUserId = await UserPreferences.getUserId();
    String userId = storedUserId.toString();
    try {
      final response = await http.get(Uri.parse(
          '${Config.baseUrl}users/$userId/totalAmount')); // Replace with the URL of your total amount API
      final responseData = json.decode(response.body);
      print(responseData);
      return responseData;
    } catch (error) {
      print("Error fetching amount: $error");
      return null;
    }
  }

  void loadAmount() async {
    int? dueAmount = await fetchAmount();
    showResponseDialog(dueAmount.toString());
  }

  void showResponseDialog(String response) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Tota Amount Due'),
          content: Text(
              response), // Assuming the 'response' is the message from the server
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  void _loadPhoneNumber() async {
    String? storedPhoneNumber = await UserPreferences.getNumber();
    print(storedPhoneNumber);
    if (storedPhoneNumber != null && storedPhoneNumber.isNotEmpty) {
      setState(() {
        phoneNumber = storedPhoneNumber;
      });
    }
  }

  void _payAmount() {
    // Implement "Pay Amount" button functionality
    print("Pay Amount button pressed");
    Navigator.of(context).pushNamed('/payAmount');
  }

  void _addAmount(context) {
    // Implement "Add Amount" button functionality
    print("Add Amount button pressed");
    Navigator.pushNamed(context, '/addAmount');
  }

  void _showAmountHistory() {
    // Implement "Show Amount History" button functionality
    print("Show Amount History button pressed");
    Navigator.of(context).pushNamed('/amountHistory');
  }

  void _showTotalAmountDue() {
    // Implement "Show Total Amount Due" button functionality
    loadAmount();
  }

  void _logOut(context) async {
    // Implement "Log Out" button functionality
    // Implement "Log Out" button functionality
    print("Log Out button pressed");

    // Clear user information
    await UserPreferences.setLoggedIn(false);
    await UserPreferences.setName("");
    await UserPreferences.setUserId(null);
    await UserPreferences.setNumber("");
    // Redirect to the login screen
    Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home Page'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Username: $username',
                    style: TextStyle(fontSize: 18),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Phone Number: $phoneNumber',
                    style: TextStyle(fontSize: 18),
                  ),
                ],
              ),
            ),
            SizedBox(height: 30),
            ElevatedButton(
              onPressed: _payAmount,
              child: Text('Pay Amount'),
            ),
            ElevatedButton(
              onPressed: () => _addAmount(context),
              child: Text('Add Amount'),
            ),
            ElevatedButton(
              onPressed: _showAmountHistory,
              child: Text('Show Amount History'),
            ),
            ElevatedButton(
              onPressed: _showTotalAmountDue,
              child: Text('Show Total Amount Due'),
            ),
            ElevatedButton(
              onPressed: () => _logOut(context),
              child: Text('Log Out'),
            ),
          ],
        ),
      ),
    );
  }
}
