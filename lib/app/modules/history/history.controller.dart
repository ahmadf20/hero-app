import 'package:get/get.dart';
import 'package:hive/hive.dart';

import '../../data/models/record.model.dart';

class HistoryController extends GetxController {
  void addDummyData() {
    final data = HealthRecord(
      systolicPressure: 120,
      diastolicPressure: 80,
      heartRate: 80,
      cardiacOutput: 80,
      k: 80,
      updatedAt: DateTime.now(),
    );

    final recordBox = Hive.box<HealthRecord>('records');

    recordBox.add(data);
  }
}
