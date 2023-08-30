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
      if (user.name != null) await prefs.setString('name', user.name ?? '');
      if (user.birthDate != null) {
        await prefs.setString(
          'birthdate',
          user.birthDate?.toIso8601String() ?? '',
        );
      }
      if (user.height != null) await prefs.setDouble('height', user.height!);
      if (user.weight != null) await prefs.setDouble('weight', user.weight!);
    } on Exception catch (e) {
      logger.e('Failed to save user data: $e');
      return false;
    }

    return true;
  }

  static Future<User?> getUser() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    try {
      final name = prefs.getString('name');

      return User(
        name: name,
      );
    } on Exception catch (e) {
      logger.e('Failed to get user data: $e');
      return null;
    }
  }
}
