import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:health/health.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../widgets/bottom_navbar.widget.dart';
import '../home/home.page.dart';
import '../user/controllers/user.controller.dart';
import 'controllers/main.controller.dart';

class MainPage extends GetView<MainController> {
  MainPage({Key? key}) : super(key: key);

  final user = Get.find<UserController>();

  // create a HealthFactory for use in the app, choose if HealthConnect should be used or not
  final HealthFactory health = HealthFactory(useHealthConnectIfAvailable: true);

  // define the types to get
  final types = [
    HealthDataType.STEPS,
    HealthDataType.BLOOD_PRESSURE_SYSTOLIC,
    HealthDataType.BLOOD_PRESSURE_DIASTOLIC,
    HealthDataType.HEART_RATE,
  ];

  final permissions = [
    HealthDataAccess.READ,
    HealthDataAccess.READ,
    HealthDataAccess.READ,
    HealthDataAccess.READ,
  ];

  Future<void> readHealth() async {
    final bool requested =
        await health.requestAuthorization(types, permissions: permissions);

    final now = DateTime.now();

    if (!requested) return;

    // fetch health data from the last 24 hours
    final List<HealthDataPoint> healthData =
        await health.getHealthDataFromTypes(
      now.subtract(const Duration(days: 30)),
      now,
      types,
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
  }

  Widget renderPage() {
    switch (controller.currentIndex) {
      case 0:
        return const HomePage();

      default:
        return const HomePage();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Obx(
      () {
        // if (user.isLoading.value || user.user.value == null) {
        //   return Scaffold(
        //     body: MyLoadingIndicator.circular(),
        //   );
        // }

        return Scaffold(
          body: renderPage(),
          bottomNavigationBar: BottomNavbar(controller),
        );
      },
    );
  }
}
