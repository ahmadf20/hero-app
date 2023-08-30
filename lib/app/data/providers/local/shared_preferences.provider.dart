import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../../../core/utils/logger.dart';
import '../../models/user.model.dart';

class SharedPrefsProvider {
  SharedPrefsProvider._();

  static Future<bool> logOut() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.clear();
  }

  static Future<bool> setUser(User user) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    try {
      await prefs.setString('user', json.encode(user));
    } on Exception catch (e) {
      logger.e('Failed to save user data: $e');
      return false;
    }

    return true;
  }

  static Future<User?> getUser() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    try {
      final user = json.decode(prefs.getString('user') ?? '');
      return User.fromJson(user as Map<String, Object?>);
    } on Exception catch (e) {
      logger.e('Failed to get user data: $e');
      return null;
    }
  }
}
