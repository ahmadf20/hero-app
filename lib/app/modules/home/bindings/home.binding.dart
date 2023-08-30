import 'package:get/get.dart';
import '../controllers/home.controller.dart';

class HomeBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut(HomeController.new);
  }
}
