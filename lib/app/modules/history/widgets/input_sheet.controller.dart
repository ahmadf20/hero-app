import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../../../core/controllers/text_editing.controller.dart';
import '../../../core/utils/form_validator.dart';
import '../../../data/models/record.model.dart';

class InputSheetController extends GetxController {
  final Map? data;
  final bool? isFirstRecord;

  InputSheetController({
    this.data,
    this.isFirstRecord = false,
  });

  final sbp = Get.put(MyTextEditingController(), tag: 'sbp');
  final dbp = Get.put(MyTextEditingController(), tag: 'dbp');
  final hr = Get.put(MyTextEditingController(), tag: 'hr');
  final co = Get.put(MyTextEditingController(), tag: 'co');

  bool get getIsFormValid {
    return FormValidator.textValidator(sbp.text) == null &&
        (FormValidator.textValidator(dbp.text) == null) &&
        FormValidator.textValidator(hr.text) == null &&
        (isFirstRecord != true || FormValidator.textValidator(co.text) == null);
  }

  void initalizeData() {
    // input1.controller.text = intitialValue1 ?? '';
    // input2.controller.text = intitialValue2 ?? '';
  }

  @override
  void onInit() {
    super.onInit();
    initalizeData();
  }

  void save() {
    if (!getIsFormValid) return;

    final systolicPressure = double.parse(sbp.text);
    final diastolicPressure = double.parse(dbp.text);
    final heartRate = double.parse(hr.text);

    final coEst = (systolicPressure - diastolicPressure) /
        (systolicPressure + diastolicPressure) *
        heartRate;

    final recordBox = Hive.box<HealthRecord>('records');

    HealthRecord data;

    if (isFirstRecord ?? false) {
      final cardiacOutput = double.parse(co.text);

      final k = cardiacOutput / coEst;

      data = HealthRecord(
        systolicPressure: systolicPressure,
        diastolicPressure: diastolicPressure,
        heartRate: heartRate,
        cardiacOutput: cardiacOutput,
        k: k,
        updatedAt: DateTime.now(),
      );
    } else {
      final records = recordBox.values.toList();

      double k = 0;

      for (final record in records) {
        final coEst = (record.systolicPressure - record.diastolicPressure) /
            (record.systolicPressure + record.diastolicPressure) *
            record.heartRate;

        k += record.cardiacOutput / coEst;
      }

      k = k / records.length;

      final cardiacOutput = coEst * k;

      data = HealthRecord(
        systolicPressure: systolicPressure,
        diastolicPressure: diastolicPressure,
        heartRate: heartRate,
        cardiacOutput: double.parse(cardiacOutput.toStringAsFixed(2)),
        k: k,
        updatedAt: DateTime.now(),
      );

      // co.text = cardiacOutput.toString();
    }

    recordBox.add(data);

    Get.back();
  }
}
