import 'dart:async';
import 'dart:developer';

import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:health/health.dart';
import 'package:permission_handler/permission_handler.dart';

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

  @override
  void onInit() {
    authorize();
    super.onInit();
  }

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
    final bool requested = await health.requestAuthorization(
      types,
      permissions: permissions,
    );

    if (!requested) return;
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
    const k = 0.3; // TODO: calculate this

    final sbp = double.parse(
      bloodPressureSystolic.value?.value.toString() ?? '0',
    ).toInt();
    final dbp = double.parse(
      bloodPressureDiastolic.value?.value.toString() ?? '0',
    ).toInt();
    final hr = double.parse(
      heartRate.value?.value.toString() ?? '0',
    ).toInt();

    final coEst = hr * ((sbp - dbp) / (sbp + dbp));
    final co = coEst * k;

    cardiacOutput.value = HealthData(value: co, updatedAt: DateTime.now());
  }

  double toDouble(HealthValue? value) {
    return double.parse(value?.toString() ?? '0');
  }

  Future authorize() async {
    await Permission.activityRecognition.request();

    bool? hasPermissions = await health.hasPermissions(
      types,
      permissions: permissions,
    );

    // hasPermissions = false because the hasPermission cannot disclose if WRITE access exists.
    // Hence, we have to request with WRITE as well.
    hasPermissions = false;

    if (!hasPermissions) {
      // requesting access to the data types before reading them
      try {
        await health.requestAuthorization(types, permissions: permissions);
      } on Exception catch (error) {
        log('Exception in authorize: $error');
      }
    }
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
    // TODO: save data to sqlite database

    GetStorage box = GetStorage();
  }
}
