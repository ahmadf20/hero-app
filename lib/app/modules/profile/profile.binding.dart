import 'package:get/get.dart';

import 'profile.controller.dart';

class ProfileBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut(ProfileController.new);
  }
}
