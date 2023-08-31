import 'package:get/get.dart';

import '../../../core/controllers/text_editing.controller.dart';
import '../../../core/utils/form_validator.dart';
import '../measure.controller.dart';

class InputSheetController extends GetxController {
  final bool? isHeartRate;
  final String? intitialValue1;
  final String? intitialValue2;
  final MeasureController meassureController;

  InputSheetController({
    required this.meassureController,
    this.isHeartRate,
    this.intitialValue1,
    this.intitialValue2,
  });

  final input1 = Get.put(MyTextEditingController(), tag: 'text1');
  final input2 = Get.put(MyTextEditingController(), tag: 'text2');

  bool get getIsFormValid {
    return FormValidator.textValidator(input1.text) == null &&
        (isHeartRate! || FormValidator.textValidator(input2.text) == null);
  }

  void initalizeData() {
    input1.controller.text = intitialValue1 ?? '';
    input2.controller.text = intitialValue2 ?? '';
  }

  @override
  void onInit() {
    super.onInit();
    initalizeData();
  }

  void save() {
    if (!getIsFormValid) return;

    if (isHeartRate!) {
      meassureController.heartRate.value = HealthData(
        value: double.parse(input1.text),
        updatedAt: DateTime.now(),
      );
    } else {
      meassureController.bloodPressureSystolic.value = HealthData(
        value: double.parse(input1.text),
        updatedAt: DateTime.now(),
      );

      meassureController.bloodPressureDiastolic.value = HealthData(
        value: double.parse(input2.text),
        updatedAt: DateTime.now(),
      );
    }

    meassureController.calculateCardiacOutput();

    Get.back();
  }
}
