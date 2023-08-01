import 'dart:ffi';

import 'package:shared_preferences/shared_preferences.dart';

class UserPreferences {
  static const String _isLoggedInKey = 'isLoggedIn';
  static const String _tokenKey = 'token';
  static const String _userIdKey = 'userId';
  static const String _userNameKey = 'user';
  static const String _phoneNumberKey = 'phoneNumber';

  static Future<SharedPreferences> _getPreferences() async {
    return await SharedPreferences.getInstance();
  }

  static Future<bool> isLoggedIn() async {
    final prefs = await _getPreferences();
    return prefs.getBool(_isLoggedInKey) ?? false;
  }

  static Future<void> setLoggedIn(bool value) async {
    final prefs = await _getPreferences();
    prefs.setBool(_isLoggedInKey, value);
  }

  static Future<String?> getToken() async {
    final prefs = await _getPreferences();
    return prefs.getString(_tokenKey);
  }

  static Future<void> setToken(String value) async {
    final prefs = await _getPreferences();
    prefs.setString(_tokenKey, value);
  }

  static Future<int?> getUserId() async {
    final prefs = await _getPreferences();
    return prefs.getInt(_userIdKey);
  }

  static Future<void> setUserId(int? value) async {
    final prefs = await _getPreferences();
    prefs.setInt(_userIdKey, value ?? 999999999);
  }

  static Future<String?> getName() async {
    final prefs = await _getPreferences();
    return prefs.getString(_userNameKey);
  }

  static Future<void> setName(String value) async {
    final prefs = await _getPreferences();
    prefs.setString(_userNameKey, value);
  }

  static Future<String?> getNumber() async {
    final prefs = await _getPreferences();
    return prefs.getString(_phoneNumberKey);
  }

  static Future<void> setNumber(String value) async {
    final prefs = await _getPreferences();
    prefs.setString(_phoneNumberKey, value);
  }
}
