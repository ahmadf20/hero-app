import 'package:get/get.dart';

class MainController extends GetxController {
  static MainController get to => Get.find();

  final Rx<int> _currentIndex = 0.obs;

  int get currentIndex => _currentIndex.value;

  set currentIndex(int value) {
    _currentIndex.value = value;
    update();
  }
}
