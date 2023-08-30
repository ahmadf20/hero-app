import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../widgets/_base/loading_indicator.widget.dart';
import '../../widgets/bottom_navbar.widget.dart';
import '../home/home.page.dart';
import '../user/controllers/user.controller.dart';
import 'controllers/main.controller.dart';

class MainPage extends GetView<MainController> {
  MainPage({Key? key}) : super(key: key);

  final user = Get.find<UserController>();

  Widget renderPage() {
    switch (controller.currentIndex) {
      case 0:
        return HomePage();

      default:
        return HomePage();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Obx(
      () {
        if (user.isLoading.value || user.user.value == null) {
          return Scaffold(
            body: MyLoadingIndicator.circular(),
          );
        }

        return Scaffold(
          body: renderPage(),
          bottomNavigationBar: BottomNavbar(controller),
        );
      },
    );
  }
}
