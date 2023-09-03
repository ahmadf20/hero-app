import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../widgets/_base/loading_indicator.widget.dart';
import '../../widgets/bottom_navbar.widget.dart';
import '../history/history.page.dart';
import '../home/home.page.dart';
import '../measure/measure.page.dart';
import '../user/controllers/user.controller.dart';
import 'controllers/main.controller.dart';

class MainPage extends GetView<MainController> {
  MainPage({Key? key}) : super(key: key);

  final user = Get.find<UserController>();

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
          body: IndexedStack(
            index: controller.currentIndex,
            children: [
              HomePage(),
              const MeasurePage(),
              HistoryPage(),
            ],
          ),
          bottomNavigationBar: BottomNavbar(controller),
        );
      },
    );
  }
}
