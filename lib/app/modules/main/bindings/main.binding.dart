// ignore_for_file: cascade_invocations

import 'package:get/get.dart';

import '../controllers/main.controller.dart';

class MainBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<MainController>(
      MainController.new,
    );
  }
}
