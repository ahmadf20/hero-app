import 'package:get/get.dart';
import '../modules/main/bindings/main.binding.dart';
import '../modules/main/main.page.dart';
import '../modules/onboarding/bindings/onboarding.binding.dart';
import '../modules/onboarding/onboarding.page.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static final routes = [
    GetPage(
      name: _Paths.INITIAL,
      page: MainPage.new,
      binding: MainBinding(),
      transition: Transition.noTransition,
    ),
    GetPage(
      name: _Paths.ONBOARDING,
      page: OnboardingPage.new,
      binding: OnboardingBinding(),
    ),
    GetPage(
      name: _Paths.PROFILE,
      page: OnboardingPage.new,
      binding: OnboardingBinding(),
    ),
  ];
}
