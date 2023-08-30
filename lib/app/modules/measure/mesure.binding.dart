import 'package:get/get.dart';

import 'measure.controller.dart';

class MeasureBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut(MeasureController.new);
  }
}
