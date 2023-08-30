import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../widgets/_base/screen_wrapper.widget.dart';
import 'controllers/home.controller.dart';

class HomePage extends GetView<HomeController> {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ScreenWrapper(
      child: Container(),
    );
  }
}
