import 'package:get/get.dart';

import '../../../core/controllers/text_editing.controller.dart';
import '../../../core/utils/form_validator.dart';
import '../../../data/models/user.model.dart';
import '../../../data/providers/local/shared_preferences.provider.dart';
import '../../../routes/app_pages.dart';

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

  void submit() {
    SharedPrefsProvider.setUser(
      User(
        name: name.text,
        birthDate: date.value,
        height: double.parse(height.text),
        weight: double.parse(weight.text),
      ),
    );

    if (getIsFormValid) {
      Get.offNamed(Routes.HOME);
    }
  }
}
