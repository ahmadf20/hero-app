import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../core/utils/date_time.dart';
import '../../routes/app_pages.dart';
import '../../widgets/_base/screen_wrapper.widget.dart';
import '../user/controllers/user.controller.dart';
import 'controllers/home.controller.dart';

class HomePage extends StatelessWidget {
  HomePage({Key? key}) : super(key: key);

  final user = Get.find<UserController>();

  @override
  Widget build(BuildContext context) {
    return GetX<HomeController>(
      init: HomeController(),
      builder: (controller) {
        return ScreenWrapper(
          child: ListView(
            children: [
              const SizedBox(height: 14),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: Text(
                      'Summary',
                      style:
                          Theme.of(context).textTheme.headlineMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context).colorScheme.primary,
                              ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  IconButton.filled(
                    iconSize: 24,
                    onPressed: () {
                      Get.toNamed(Routes.PROFILE);
                    },
                    color: Colors.white,
                    icon: SizedBox(
                      width: 24,
                      height: 24,
                      child: FittedBox(
                        child: Center(
                          child: Text(
                            user.user.value?.name?.trim()[0] ?? '-',
                            style: Theme.of(context)
                                .textTheme
                                .titleLarge
                                ?.copyWith(
                                  color: Colors.white,
                                ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Column(
                children: [
                  const Text(
                    '😄',
                    style: TextStyle(
                      fontSize: 100,
                      height: 1.2,
                    ),
                  ),
                  Text(
                    'You are Healthy',
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Text(
                'Today',
                style: Theme.of(context)
                    .textTheme
                    .titleMedium
                    ?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              ListItem(
                label: 'Blood Pressure',
                value:
                    '${double.parse(controller.bloodPressureSystolic.value?.value.toString() ?? '0').toInt()}/${double.parse(controller.bloodPressureDiastolic.value?.value.toString() ?? '0').toInt()}',
                unit: 'mmHg',
                time: DateTimeUtils.format(
                  controller.bloodPressureSystolic.value?.dateFrom,
                  format: 'HH:mm',
                ),
                icon: '🩸',
              ),
              const SizedBox(height: 16),
              ListItem(
                label: 'Heart Rate',
                value:
                    '${double.parse(controller.heartRate.value?.value.toString() ?? '0').toInt()}',
                unit: 'BPM',
                time: DateTimeUtils.format(
                  controller.heartRate.value?.dateFrom,
                  format: 'HH:mm',
                ),
                icon: '🩺',
              ),
              const SizedBox(height: 16),
              ListItem(
                label: 'Cardiac Output',
                value:
                    '${double.parse(controller.heartRate.value?.value.toString() ?? '0').toInt()}',
                unit: 'L/min',
                time: DateTimeUtils.format(
                  controller.heartRate.value?.dateFrom,
                  format: 'HH:mm',
                ),
                icon: '🫀',
              ),
              const SizedBox(height: 16),
              ListItem(
                label: 'Oxygen Saturation',
                value:
                    '${(double.parse(controller.oxygenSaturation.value?.value.toString() ?? '0') * 100).toInt()}',
                unit: '%',
                time: DateTimeUtils.format(
                  controller.oxygenSaturation.value?.dateFrom,
                  format: 'HH:mm',
                ),
                icon: '💦',
              ),
              const SizedBox(height: 16),
            ],
          ),
        );
      },
    );
  }
}

class ListItem extends StatelessWidget {
  final String label;
  final String value;
  final String? unit;
  final String icon;
  final String? time;
  final Widget? suffix;
  final void Function()? onPressed;

  const ListItem({
    required this.label,
    required this.value,
    required this.icon,
    this.unit,
    this.time,
    this.suffix,
    this.onPressed,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return FilledButton.tonal(
      style: ButtonStyle(
        overlayColor: MaterialStateProperty.all(
          Theme.of(context)
              .colorScheme
              .primary
              .withOpacity(onPressed == null ? 0 : 0.1),
        ),
        padding: MaterialStateProperty.all(
          const EdgeInsets.all(16),
        ),
        shape: MaterialStateProperty.all(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        backgroundColor: MaterialStateProperty.all(
          Theme.of(context).colorScheme.primary.withOpacity(0.1),
        ),
      ),
      onPressed: onPressed ?? () {},
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.background,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Center(
                  child: Text(
                    icon,
                    style: const TextStyle(fontSize: 24),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(label),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        value,
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                      const SizedBox(width: 2),
                      if (unit != null) Text(unit!),
                    ],
                  ),
                ],
              ),
              const Spacer(),
              suffix ?? (time != null ? Text(time!) : Container()),
            ],
          ),
        ],
      ),
    );
  }
}
