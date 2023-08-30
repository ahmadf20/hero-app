// ignore_for_file: constant_identifier_names, non_constant_identifier_names

part of './app_pages.dart';

/// This class is used when invoking Get Router. Dont use this class
/// in `app_pages.dart` file.
///
/// Example:
/// ```
/// Get.toNamed(Routes.HOME)
/// ```
abstract class Routes {
  static const INITIAL = _Paths.INITIAL;
  static const ONBOARDING = _Paths.ONBOARDING;
  static const HOME = _Paths.HOME;
  static const PROFILE = _Paths.PROFILE;
  static const MEASURE = _Paths.MEASURE;
  static const HISTORY = _Paths.HISTORY;
}

/// This class is only used in this file and the `app_pages.dart` file as constants.
/// Shouldn't be used elsewhere.
abstract class _Paths {
  static const INITIAL = '/';
  static const ONBOARDING = '/onboarding';
  static const HOME = '/home';
  static const PROFILE = '/profile';
  static const MEASURE = '/measure';
  static const HISTORY = '/history';
}
