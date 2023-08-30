import 'package:get/get.dart';
import '../../../data/models/user.model.dart';

import '../../../data/providers/local/shared_preferences.provider.dart';
import '../../../widgets/_base/bot_toast.widget.dart';

class UserController extends GetxController {
  Future onLogout() async {
    await SharedPrefsProvider.logOut();
    // await Get.offAllNamed(Routes.LOGIN);
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

    // repository.getMe().then((value) async {
    //   if (value is User) {
    //     user.value = value;

    //     final userId = value.pengguna?.id?.toString();
    //     await AnalyticsService.instance?.setUserId(id: userId);
    //     OneSignalService.setUserId(userId);
    //   }
    // }).catchError((e) {
    //   if (kDebugMode) print(e);
    //   return;
    // }).whenComplete(isLoading.toggle);
  }
}
