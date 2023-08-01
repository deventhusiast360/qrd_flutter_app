import 'package:due_management/services/requests.dart';
import 'package:due_management/user_preferences.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController _phoneNumberController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  @override
  void dispose() {
    _phoneNumberController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _loginButtonPressed() async {
    // Implement your login logic here
    String phoneNumber = _phoneNumberController.text;
    String password = _passwordController.text;

    // Add your login authentication logic here

    var loginResult = await Requests.login(phoneNumber, password);

    if (loginResult["phoneNumber"] == phoneNumber) {
      await UserPreferences.setLoggedIn(true);
      await UserPreferences.setName(loginResult["name"]);
      await UserPreferences.setUserId(loginResult["id"]);
      await UserPreferences.setNumber(loginResult["phoneNumber"]);
      Navigator.of(context).pushReplacementNamed('/home');
    }

    print('Phone Number: $phoneNumber');
    print('Password: $password');
  }

  void _registerButtonPressed() {
    Navigator.of(context).pushReplacementNamed('/register');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login Page'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
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
              onPressed: _loginButtonPressed,
              child: Text('Login'),
            ),
            SizedBox(height: 20),
            Text("Register if you don't have nay account",
                style: TextStyle(fontSize: 16.0)),
            // SizedBox(height: 20),
            ElevatedButton(
              onPressed: _registerButtonPressed,
              child: Text("Register"),
            )
          ],
        ),
      ),
    );
  }
}
