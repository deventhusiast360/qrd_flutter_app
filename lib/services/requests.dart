import 'dart:convert';

import 'package:due_management/config.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Requests {
  static Future<Map<String, dynamic>> login(
      String phoneNumber, String password) async {
    try {
      var url = Uri.parse("${Config.baseUrl}user/login");
      //print(url);
      var response = await http.post(
        url,
        headers: {
          "Content-type": "application/json",
        },
        body: jsonEncode(
          {
            "phoneNumber": phoneNumber,
            "password": password,
          },
        ),
      );
      debugPrint(response.body);
      Map<String, dynamic> decodedResponse = jsonDecode(response.body);
      return decodedResponse["user"];
    } catch (e) {
      print(e);
      return {"error": "error occured during login"};
    }
  }

  static Future<Map<String, dynamic>> register(
      String name, String phoneNumber, String password) async {
    try {
      var url = Uri.parse("${Config.baseUrl}user/register");
      //print(url);
      var response = await http.post(
        url,
        headers: {
          "Content-type": "application/json",
        },
        body: jsonEncode(
          {
            "name": name,
            "phoneNumber": phoneNumber,
            "password": password,
          },
        ),
      );
      debugPrint(response.body);
      Map<String, dynamic> decodedResponse = jsonDecode(response.body);
      return decodedResponse["user"];
    } catch (e) {
      print(e);
      return {"error": "error occured during Registration"};
    }
  }

  static Future<int> addAmount(String id, int amount) async {
    try {
      var url = Uri.parse("${Config.baseUrl}users/$id/amounts");
      var response = await http.post(url,
          headers: {
            "Content-type": "application/json",
          },
          body: jsonEncode({
            "amount": amount,
          }));
      print(response.body);
      dynamic decodeResponse = jsonDecode(response.body);
      return decodeResponse["totalAmount"];
    } catch (e) {
      print(e);
      return 0;
    }
  }

  static payAmount(String id, int amount) async {
    try {
      var url = Uri.parse("${Config.baseUrl}users/$id/payamount/");
      var response = await http.post(
        url,
        headers: {
          "Content-type": "application/json",
        },
        body: jsonEncode({
          "amount": amount,
        }),
      );

      var decodedResponse = jsonDecode(response.body);
      print(decodedResponse);
      return decodedResponse["totalAmount"];
    } catch (e) {
      print(e);
      return 0;
    }
  }
}
