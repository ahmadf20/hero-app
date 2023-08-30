import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import '../../../data/models/user.model.dart';

import '../../../data/providers/local/shared_preferences.provider.dart';
import '../../../routes/app_pages.dart';
import '../../../widgets/_base/bot_toast.widget.dart';

class UserController extends GetxController {
  Future onLogout() async {
    await SharedPrefsProvider.logOut();
    await Get.offAllNamed(Routes.ONBOARDING);
    MyBotToast.text('Berhasil keluar dari Akun');
  }

  @override
  void onInit() {
    super.onInit();
    fetchUser();
  }

  final user = Rxn<User>();
  final isLoading = false.obs;

  void fetchUser() {
    isLoading.toggle();

    SharedPrefsProvider.getUser()
        .then((value) => user.value = value)
        .catchError((e) {
      if (kDebugMode) print(e);
      return null;
    }).whenComplete(isLoading.toggle);
  }
}
