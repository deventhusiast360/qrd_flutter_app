import 'package:due_management/amount.dart';
import 'package:due_management/home_page.dart';
import 'package:due_management/login_Page.dart';
import 'package:due_management/pages/auth/register.dart';
import 'package:due_management/pages/home/add_amount.dart';
import 'package:due_management/pages/home/pay_amount.dart';
import 'package:due_management/pages/home/show_amount_history.dart';
import 'package:due_management/splash_screen.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Register",
      initialRoute: '/splash',
      routes: {
        '/splash': (context) => SplashScreen(),
        '/home': (context) => HomePage(),
        '/addAmount': (context) => AddAmount(),
        '/payAmount': (context) => PayAmount(),
        '/amountHistory': (context) => ShowAmountHistory(),
        '/login': (context) => LoginPage(),
        '/register': (context) => RegisterPage(),
        // Set LoginPage as the root route
      },
    );
  }
}
