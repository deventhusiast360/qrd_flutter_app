import 'package:due_management/services/requests.dart';
import 'package:due_management/user_preferences.dart';
import 'package:flutter/material.dart';

class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  TextEditingController _nameController = TextEditingController();
  TextEditingController _phoneNumberController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _phoneNumberController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _registerButtonPressed() async {
    // Implement your login logic here
    String name = _nameController.text;
    String phoneNumber = _phoneNumberController.text;
    String password = _passwordController.text;

    // Add your login authentication logic here

    var registrationResult =
        await Requests.register(name, phoneNumber, password);
    print(registrationResult);
    if (registrationResult["phoneNumber"] == phoneNumber) {
      await UserPreferences.setLoggedIn(true);
      await UserPreferences.setName(registrationResult["name"]);
      await UserPreferences.setUserId(registrationResult["id"]);
      await UserPreferences.setNumber(registrationResult["phoneNumber"]);
      Navigator.of(context).pushReplacementNamed('/home');
    }

    print('Phone Number: $phoneNumber');
    print('Password: $password');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Registration Page'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _nameController,
              decoration: InputDecoration(
                labelText: 'Name',
              ),
            ),
            TextField(
              controller: _phoneNumberController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Phone Number',
              ),
            ),
            SizedBox(height: 20),
            TextField(
              controller: _passwordController,
              obscureText: false,
              decoration: InputDecoration(
                labelText: 'Password',
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _registerButtonPressed,
              child: Text('Register'),
            ),
          ],
        ),
      ),
    );
  }
}
