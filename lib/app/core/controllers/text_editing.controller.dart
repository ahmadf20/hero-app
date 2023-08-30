import 'package:flutter/material.dart';
import 'package:get/state_manager.dart';

class MyTextEditingController extends GetxController {
  MyTextEditingController({String? text, this.onTextChange}) {
    controller.text = text ?? '';
    this.text = text ?? '';
  }

  final TextEditingController controller = TextEditingController();

  final RxString _text = ''.obs;

  String get text => _text.value;
  set text(String value) => _text.value = value;

  VoidCallback? onTextChange;
  // ignore: use_setters_to_change_properties
  void addTextChangeListener(VoidCallback listener) {
    onTextChange = listener;
  }

  @override
  void onInit() {
    super.onInit();

    controller.addListener(() {
      if (_text.value != controller.text) {
        _text.value = controller.text;
        onTextChange?.call();
      }
    });
  }
}
