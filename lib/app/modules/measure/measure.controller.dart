import 'dart:developer';

import 'package:get/get.dart';
import 'package:health/health.dart';
import 'package:permission_handler/permission_handler.dart';

enum MeassureType { manual, sync, auto }

enum MeassuringState { running, paused, stopped }

class MeasureController extends GetxController {
  final meassureType = MeassureType.manual.obs;

  // create a HealthFactory for use in the app, choose if HealthConnect should be used or not
  final HealthFactory health = HealthFactory(useHealthConnectIfAvailable: true);

  @override
  void onInit() {
    authorize();

    super.onInit();
  }

  // define the types to get
  final types = [
    HealthDataType.BLOOD_OXYGEN,
    HealthDataType.BLOOD_PRESSURE_DIASTOLIC,
    HealthDataType.BLOOD_PRESSURE_SYSTOLIC,
    HealthDataType.HEART_RATE,
  ];

  final permissions = [
    HealthDataAccess.READ,
    HealthDataAccess.READ,
    HealthDataAccess.READ,
    HealthDataAccess.READ,
  ];

  final bloodPressureDiastolic = Rxn<HealthDataPoint>();
  final bloodPressureSystolic = Rxn<HealthDataPoint>();
  final heartRate = Rxn<HealthDataPoint>();
  final oxygenSaturation = Rxn<HealthDataPoint>();

  Future<void> readHealth() async {
    final bool requested =
        await health.requestAuthorization(types, permissions: permissions);

    final now = DateTime.now();

    if (!requested) return;

    final List<HealthDataPoint> healthData =
        await health.getHealthDataFromTypes(
      DateTime(now.year, now.month, now.day),
      now,
      types,
    );

    bloodPressureDiastolic.value = healthData.firstWhereOrNull(
      (element) => element.type == HealthDataType.BLOOD_PRESSURE_DIASTOLIC,
    );
    bloodPressureSystolic.value = healthData.firstWhereOrNull(
      (element) => element.type == HealthDataType.BLOOD_PRESSURE_SYSTOLIC,
    );
    heartRate.value = healthData.firstWhereOrNull(
      (element) => element.type == HealthDataType.HEART_RATE,
    );
    oxygenSaturation.value = healthData.firstWhereOrNull(
      (element) => element.type == HealthDataType.BLOOD_OXYGEN,
    );
  }

  Future authorize() async {
    // If we are trying to read Step Count, Workout, Sleep or other data that requires
    // the ACTIVITY_RECOGNITION permission, we need to request the permission first.
    // This requires a special request authorization call.
    //
    // The location permission is requested for Workouts using the Distance information.
    await Permission.activityRecognition.request();
    await Permission.location.request();

    // Check if we have permission
    bool? hasPermissions =
        await health.hasPermissions(types, permissions: permissions);

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

    await readHealth();
  }

  final meassuringState = MeassuringState.stopped.obs;

  void startMeassure() {
    meassuringState.value = MeassuringState.running;
  }

  void stopMeassure() {
    meassuringState.value = MeassuringState.paused;
  }

  void resetMeassure() {
    meassuringState.value = MeassuringState.stopped;
  }
}
