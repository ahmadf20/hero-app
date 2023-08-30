import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

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
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      if (user.isLoggedIn) ...[
                        IconButton.filledTonal(
                          style: ButtonStyle(
                            shape: MaterialStateProperty.all(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                          ),
                          padding: EdgeInsets.zero,
                          onPressed: Get.back,
                          icon: Icon(
                            Icons.arrow_back,
                            size: 25,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                        ),
                        const SizedBox(width: 12),
                      ],
                      Text(
                        user.isLoggedIn ? 'Profile' : 'Welcome',
                        style:
                            Theme.of(context).textTheme.headlineLarge?.copyWith(
                                  fontWeight: FontWeight.w600,
                                  color: Theme.of(context).colorScheme.primary,
                                ),
                        textAlign: TextAlign.start,
                      ),
                    ],
                  ),
                  if (!user.isLoggedIn) ...[
                    const SizedBox(height: 4),
                    Text(
                      'Please fill the form below to continue',
                      style: Theme.of(context).textTheme.bodyLarge,
                      textAlign: TextAlign.start,
                    ),
                  ],
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
                                  controller.setBirthDate(date);
                                }
                              },
                              decoration: InputDecoration(
                                label: const Text('Birth Date'),
                                filled: true,
                                fillColor:
                                    Theme.of(context).colorScheme.background,
                              ),
                              autovalidateMode:
                                  AutovalidateMode.onUserInteraction,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Birthdate is required';
                                }
                                return null;
                              },
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
              mainAxisAlignment: user.isLoggedIn
                  ? MainAxisAlignment.spaceBetween
                  : MainAxisAlignment.end,
              children: [
                if (user.isLoggedIn)
                  TextButton(
                    onPressed: () {
                      controller.reset();
                      // user.onLogout();
                    },
                    child: const Text('Reset'),
                  ),
                FilledButton.icon(
                  onPressed: controller.submit,
                  label: Text(user.isLoggedIn ? 'Save' : 'Next'),
                  icon: Icon(
                    user.isLoggedIn
                        ? Icons.save
                        : Icons.arrow_circle_right_outlined,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
