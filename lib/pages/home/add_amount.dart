import 'package:due_management/services/requests.dart';
import 'package:due_management/user_preferences.dart';
import 'package:flutter/material.dart';

class AddAmount extends StatefulWidget {
  const AddAmount({Key? key}) : super(key: key);

  @override
  _AddAmountState createState() => _AddAmountState();
}

class _AddAmountState extends State<AddAmount> {
  final TextEditingController _amountController = TextEditingController();
  int _totalAmount = 0;

  void _addAmount() async {
    int? storedUserId = await UserPreferences.getUserId();
    String userId = storedUserId.toString();
    // Parse the amount from the text field and add it to the total amount
    if (storedUserId != null) {
      int enteredAmount = int.tryParse(_amountController.text) ?? 0;
      setState(() {
        _totalAmount = enteredAmount;
      });
      var response = await Requests.addAmount(userId, _totalAmount);
      print(_totalAmount);
      print(response);
      showResponseDialog(response.toString());
    }

    // Clear the text field after adding the amount
    _amountController.clear();
  }

  void showResponseDialog(String response) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Response'),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Add Amount Page")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: TextFormField(
                controller: _amountController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'Enter Amount'),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                _addAmount();
              },
              child: const Text('Add Amount'),
            ),
          ],
        ),
      ),
    );
  }
}
