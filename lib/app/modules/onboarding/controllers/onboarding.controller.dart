import 'package:get/get.dart';

import '../../../core/controllers/text_editing.controller.dart';
import '../../../core/utils/date_time.dart';
import '../../../core/utils/form_validator.dart';
import '../../../data/models/user.model.dart';
import '../../../data/providers/local/shared_preferences.provider.dart';
import '../../../routes/app_pages.dart';
import '../../user/controllers/user.controller.dart';

class OnboardingController extends GetxController {
  final date = Rxn<DateTime>();

  final birthdate = Get.put(MyTextEditingController(), tag: 'birthdate');
  final height = Get.put(MyTextEditingController(), tag: 'height');
  final weight = Get.put(MyTextEditingController(), tag: 'weight');
  final name = Get.put(MyTextEditingController(), tag: 'name');

  bool get getIsFormValid {
    return FormValidator.textValidator(birthdate.text) == null ||
        FormValidator.textValidator(height.text) == null ||
        FormValidator.textValidator(weight.text) == null ||
        FormValidator.textValidator(name.text) == null;
  }

  final user = Get.find<UserController>();

  void initalizeData() {
    if (!user.isLoggedIn) return;

    setBirthDate(user.user.value?.birthDate);
    height.controller.text = user.user.value?.height?.toString() ?? '';
    weight.controller.text = user.user.value?.weight?.toString() ?? '';
    name.controller.text = user.user.value?.name ?? '';
  }

  @override
  void onInit() {
    super.onInit();
    initalizeData();
  }

  void reset() {
    date.value = null;
    birthdate.controller.text = '';
    height.controller.text = '';
    weight.controller.text = '';
    name.controller.text = '';
  }

  void setBirthDate(DateTime? dateTime) {
    date.value = dateTime;
    birthdate.controller.text = DateTimeUtils.format(
      dateTime,
      format: 'dd MMMM yyyy',
    );
  }

  Future<void> submit() async {
    await SharedPrefsProvider.setUser(
      User(
        name: name.text.trim(),
        birthDate: date.value,
        height: double.parse(height.text),
        weight: double.parse(weight.text),
      ),
    );

    user.fetchUser();

    if (getIsFormValid) {
      await Get.offNamed(Routes.HOME);
    }
  }
}
