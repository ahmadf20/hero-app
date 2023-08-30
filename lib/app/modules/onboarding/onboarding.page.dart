import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../core/utils/date_time.dart';
import '../../routes/app_pages.dart';
import '../../widgets/_base/screen_wrapper.widget.dart';
import '../user/controllers/user.controller.dart';
import 'controllers/onboarding.controller.dart';

class OnboardingPage extends GetView<OnboardingController> {
  OnboardingPage({Key? key}) : super(key: key);

  final user = Get.find<UserController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ScreenWrapper(
        child: Column(
          children: [
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    'Welcome',
                    style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                    textAlign: TextAlign.start,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Please fill the form below to continue',
                    style: Theme.of(context).textTheme.bodyLarge,
                    textAlign: TextAlign.start,
                  ),
                  const SizedBox(height: 16),
                  Column(
                    children: [
                      TextFormField(
                        controller: controller.name.controller,
                        decoration: InputDecoration(
                          label: const Text('Name'),
                          filled: true,
                          fillColor: Theme.of(context).colorScheme.background,
                        ),
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Name is required';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              readOnly: true,
                              controller: controller.birthdate.controller,
                              onTap: () async {
                                final date = await showDatePicker(
                                  context: context,
                                  initialDate:
                                      controller.date.value ?? DateTime.now(),
                                  firstDate: DateTime(1900),
                                  lastDate: DateTime.now(),
                                  initialDatePickerMode: DatePickerMode.year,
                                );

                                if (date != null) {
                                  controller.date.value = date;
                                  controller.birthdate.controller.text =
                                      DateTimeUtils.format(
                                    date,
                                    format: 'dd MMMM yyyy',
                                  );
                                }
                              },
                              decoration: InputDecoration(
                                label: const Text('Birth Date'),
                                filled: true,
                                fillColor:
                                    Theme.of(context).colorScheme.background,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: TextFormField(
                              controller: controller.weight.controller,
                              decoration: InputDecoration(
                                label: const Text('Weight'),
                                filled: true,
                                fillColor:
                                    Theme.of(context).colorScheme.background,
                                suffixText: 'Kg',
                              ),
                              inputFormatters: [
                                FilteringTextInputFormatter.allow(
                                  RegExp(r'^(\d+)?\.?\d{0,2}'),
                                ),
                              ],
                              keyboardType:
                                  const TextInputType.numberWithOptions(
                                decimal: true,
                              ),
                              autovalidateMode:
                                  AutovalidateMode.onUserInteraction,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Weight is required';
                                }
                                return null;
                              },
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: TextFormField(
                              controller: controller.height.controller,
                              decoration: InputDecoration(
                                label: const Text('Height'),
                                filled: true,
                                fillColor:
                                    Theme.of(context).colorScheme.background,
                                suffixText: 'Cm',
                              ),
                              inputFormatters: [
                                FilteringTextInputFormatter.allow(
                                  RegExp(r'^(\d+)?\.?\d{0,2}'),
                                ),
                              ],
                              keyboardType:
                                  const TextInputType.numberWithOptions(
                                decimal: true,
                              ),
                              autovalidateMode:
                                  AutovalidateMode.onUserInteraction,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Height is required';
                                }
                                return null;
                              },
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 64),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                FilledButton.icon(
                  onPressed: controller.submit,
                  label: const Text('Next'),
                  icon: const Icon(Icons.arrow_circle_right_outlined),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
