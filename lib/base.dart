import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'app/data/models/user.model.dart';

import 'app/data/providers/local/shared_preferences.provider.dart';
import 'app/routes/app_pages.dart';
import 'app/widgets/_base/loading_indicator.widget.dart';

class BaseWidget extends StatefulWidget {
  const BaseWidget({Key? key}) : super(key: key);

  @override
  State<BaseWidget> createState() => _BaseWidgetState();
}

class _BaseWidgetState extends State<BaseWidget> {
  Future<User?> getUserData() async {
    return SharedPrefsProvider.getUser();
  }

  Future<void> initialize() async {
    final User? user = await getUserData();
    log('user $user');

    if (user?.name == null) {
      await Get.offAndToNamed(Routes.ONBOARDING);
    } else {
      await Get.offAndToNamed(Routes.HOME);
    }
  }

  @override
  void initState() {
    super.initState();
    initialize();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: MyLoadingIndicator.circular(),
      ),
    );
  }
}
