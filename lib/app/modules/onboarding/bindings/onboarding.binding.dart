// ignore_for_file: cascade_invocations

import 'package:get/get.dart';

import '../controllers/onboarding.controller.dart';

class OnboardingBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<OnboardingController>(
      OnboardingController.new,
    );
  }
}
