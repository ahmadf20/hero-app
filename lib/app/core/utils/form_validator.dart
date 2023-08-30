import 'package:get/get_utils/get_utils.dart';

class FormValidator {
  static String? codeValidator(String? code) {
    if (code == null || code.isEmpty) {
      return 'Kode tidak boleh kosong';
    }
    return null;
  }

  static String? emailValidator(String? email) {
    if (email == null || email.isEmpty || !email.isEmail) {
      return 'Email tidak valid';
    }
    return null;
  }

  static String? phoneValidator(String? phone) {
    if (phone == null || phone.isEmpty || !phone.isPhoneNumber) {
      return 'Mohon masukkan nomor handphone yang valid';
    }
    return null;
  }

  static String? passwordValidator(String? password) {
    if (password == null || password.isEmpty) {
      return 'Password tidak boleh kosong';
    } else if (password.length < 6) {
      return 'Password minimal 6 karakter';
    }
    return null;
  }

  static String? confirmPasswordValidator(String? password, String? value) {
    if (password == null || password.isEmpty) {
      return 'Password tidak boleh kosong';
    } else if (password != value) {
      return 'Password tidak sama';
    }
    return null;
  }

  static String? textValidator(String? name, {String? errorText}) {
    if (name == null || name.isEmpty) {
      return errorText ?? 'Nama tidak boleh kosong';
    }
    return null;
  }

  static String? otpValidator(String? code) {
    if (code == null || code.isEmpty || code.length < 6) {
      return 'Kode tidak boleh kosong';
    }
    return null;
  }

  static String? objectValidator<T>(T? value, {String? field}) {
    if (value == null) {
      return '$field tidak boleh kosong';
    }
    return null;
  }

  /// e.g. `23:59` or `03:00`
  static String? timeValidator(String? time) {
    if (time == null ||
        RegExp(r'^(0[0-9]|1[0-9]|2[0-3]):[0-5][0-9]$').hasMatch(time) ==
            false) {
      return 'Format waktu salah';
    }
    return null;
  }
}
