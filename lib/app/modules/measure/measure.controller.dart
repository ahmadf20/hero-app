import 'dart:async';

import 'package:get/get.dart';
import 'package:health/health.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../../data/models/record.model.dart';

enum MeassureType { manual, sync, auto }

enum MeassuringState { running, paused, stopped }

class HealthData {
  final double value;
  final DateTime updatedAt;

  HealthData({
    required this.value,
    required this.updatedAt,
  });
}

class MeasureController extends GetxController {
  final meassureType = MeassureType.manual.obs;

  final HealthFactory health = HealthFactory(useHealthConnectIfAvailable: true);

  final types = [
    HealthDataType.BLOOD_PRESSURE_DIASTOLIC,
    HealthDataType.BLOOD_PRESSURE_SYSTOLIC,
    HealthDataType.HEART_RATE,
  ];

  final permissions = [
    HealthDataAccess.READ,
    HealthDataAccess.READ,
    HealthDataAccess.READ,
  ];

  final bloodPressureDiastolic = Rxn<HealthData>();
  final bloodPressureSystolic = Rxn<HealthData>();
  final heartRate = Rxn<HealthData>();

  final cardiacOutput = Rxn<HealthData>();

  final startAt = Rxn<DateTime>();

  late Timer? timer;

  Future<void> readHealth({DateTime? startAt}) async {
    final bool? requested = await health.hasPermissions(
      types,
      permissions: permissions,
    );

    if (requested != true) return;
    if (startAt == null) return;

    final now = DateTime.now();
    final healthData = await health.getHealthDataFromTypes(
      startAt.subtract(const Duration(minutes: 1)),
      now,
      types,
    );

    final dbp = healthData.firstWhereOrNull(
      (element) => element.type == HealthDataType.BLOOD_PRESSURE_DIASTOLIC,
    );

    if (dbp != null) {
      bloodPressureDiastolic.value = HealthData(
        value: toDouble(dbp.value),
        updatedAt: dbp.dateFrom,
      );
    }

    final sbp = healthData.firstWhereOrNull(
      (element) => element.type == HealthDataType.BLOOD_PRESSURE_SYSTOLIC,
    );

    if (sbp != null) {
      bloodPressureSystolic.value = HealthData(
        value: toDouble(sbp.value),
        updatedAt: sbp.dateFrom,
      );
    }

    final hr = healthData.firstWhereOrNull(
      (element) => element.type == HealthDataType.HEART_RATE,
    );

    if (hr != null) {
      heartRate.value = HealthData(
        value: toDouble(hr.value),
        updatedAt: hr.dateFrom,
      );
    }

    if (timer == null) return;
    if (bloodPressureDiastolic.value != null &&
        bloodPressureSystolic.value != null &&
        heartRate.value != null) {
      calculateCardiacOutput();
      reset();
    }
  }

  void calculateCardiacOutput() {
    final data = getHealtRecord();

    cardiacOutput.value = HealthData(
      value: data.cardiacOutput,
      updatedAt: data.updatedAt,
    );
  }

  double toDouble(HealthValue? value) {
    return double.parse(value?.toString() ?? '0');
  }

  final meassuringState = MeassuringState.stopped.obs;

  void startMeassure() {
    if (meassuringState.value == MeassuringState.stopped) {
      startAt.value = DateTime.now();
    }

    meassuringState.value = MeassuringState.running;

    timer = Timer.periodic(const Duration(seconds: 1), (Timer t) {
      readHealth(startAt: startAt.value);
    });
  }

  void stopMeassure() {
    meassuringState.value = MeassuringState.paused;
    timer?.cancel();
  }

  void reset() {
    meassuringState.value = MeassuringState.stopped;
    startAt.value = null;
    timer?.cancel();
  }

  void resetMeassure() {
    reset();

    bloodPressureDiastolic.value = null;
    bloodPressureSystolic.value = null;
    heartRate.value = null;
    cardiacOutput.value = null;
  }

  bool get hasCompleted {
    return cardiacOutput.value != null &&
        bloodPressureDiastolic.value != null &&
        bloodPressureSystolic.value != null &&
        heartRate.value != null;
  }

  void save() {
    final recordBox = Hive.box<HealthRecord>('records');
    final data = getHealtRecord();
    recordBox.add(data);
    resetMeassure();
  }

  HealthRecord getHealtRecord() {
    final systolicPressure = bloodPressureSystolic.value?.value ?? 0;
    final diastolicPressure = bloodPressureDiastolic.value?.value ?? 0;
    final heartRate = this.heartRate.value?.value ?? 0;

    final coEst = (systolicPressure - diastolicPressure) /
        (systolicPressure + diastolicPressure) *
        heartRate;

    final recordBox = Hive.box<HealthRecord>('records');

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

    return HealthRecord(
      systolicPressure: systolicPressure,
      diastolicPressure: diastolicPressure,
      heartRate: heartRate,
      cardiacOutput: double.parse(cardiacOutput.toStringAsFixed(2)),
      k: k,
      updatedAt: DateTime.now(),
    );
  }
}
