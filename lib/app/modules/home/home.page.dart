import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../../core/utils/date_time.dart';
import '../../data/models/record.model.dart';
import '../../routes/app_pages.dart';
import '../../widgets/_base/screen_wrapper.widget.dart';
import '../user/controllers/user.controller.dart';
import 'controllers/home.controller.dart';

class HomePage extends StatelessWidget {
  HomePage({Key? key}) : super(key: key);

  final user = Get.find<UserController>();

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: Hive.box<HealthRecord>('records').listenable(),
      builder: (context, box, child) {
        final lastRecord = box.values.isNotEmpty ? box.values.last : null;

        final bool hasRecord = box.values.isNotEmpty &&
            DateTimeUtils.isDateToday(lastRecord!.updatedAt);

        final Map<String, dynamic> todayStatus;

        if (!hasRecord) {
          todayStatus = {
            'title': 'Are you okay?',
            'icon': '🤔',
            'subtitle':
                'Go to measure page to check if you are in good condition today',
            'color': Colors.grey.shade800,
          };
        } else if (lastRecord.cardiacOutput > 6 ||
            lastRecord.cardiacOutput < 5) {
          todayStatus = {
            'title': 'You are Unhealthy',
            'icon': '😣',
            'subtitle':
                'The normal cardiac output ranges from 5 to 6 liters per minute in a person at rest. Please consult with your doctor',
            'color': Colors.red.shade700,
          };
        } else {
          todayStatus = {
            'title': 'You are Healthy',
            'icon': '😄',
            'subtitle':
                'The normal cardiac output ranges from 5 to 6 liters per minute in a person at rest',
            'color': Colors.green,
          };
        }

        return GetX<HomeController>(
          init: HomeController(),
          builder: (controller) {
            return ScreenWrapper(
              child: ListView(
                children: [
                  const SizedBox(height: 18),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(
                        child: Text(
                          'Summary',
                          style: Theme.of(context)
                              .textTheme
                              .headlineMedium
                              ?.copyWith(
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
                      Text(
                        todayStatus['icon']?.toString() ?? '',
                        style: const TextStyle(
                          fontSize: 100,
                          height: 1.2,
                        ),
                      ),
                      Text(
                        todayStatus['title']?.toString() ?? '',
                        style:
                            Theme.of(context).textTheme.headlineSmall?.copyWith(
                                  color: todayStatus['color'] as Color?,
                                  fontWeight: FontWeight.bold,
                                ),
                      ),
                      const SizedBox(height: 8),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24),
                        child: Text(
                          todayStatus['subtitle']?.toString() ?? '',
                          textAlign: TextAlign.center,
                        ),
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
                    label: 'Cardiac Output',
                    value: hasRecord
                        ? lastRecord.cardiacOutput.toStringAsFixed(2)
                        : '0',
                    unit: 'L/min',
                    time: DateTimeUtils.format(
                      hasRecord
                          ? lastRecord.updatedAt
                          : controller.heartRate.value?.dateFrom,
                      format: 'HH:mm',
                    ),
                    icon: '🫀',
                  ),
                  const SizedBox(height: 16),
                  ListItem(
                    label: 'Blood Pressure',
                    value: hasRecord
                        ? '${lastRecord.systolicPressure.toInt()}/${lastRecord.diastolicPressure.toInt()}'
                        : '${double.parse(controller.bloodPressureSystolic.value?.value.toString() ?? '0').toInt()}/${double.parse(controller.bloodPressureDiastolic.value?.value.toString() ?? '0').toInt()}',
                    unit: 'mmHg',
                    time: DateTimeUtils.format(
                      hasRecord
                          ? lastRecord.updatedAt
                          : controller.bloodPressureSystolic.value?.dateFrom,
                      format: 'HH:mm',
                    ),
                    icon: '🩸',
                  ),
                  const SizedBox(height: 16),
                  ListItem(
                    label: 'Heart Rate',
                    value: hasRecord
                        ? '${lastRecord.heartRate.toInt()}'
                        : '${double.parse(controller.heartRate.value?.value.toString() ?? '0').toInt()}',
                    unit: 'BPM',
                    time: DateTimeUtils.format(
                      hasRecord
                          ? lastRecord.updatedAt
                          : controller.heartRate.value?.dateFrom,
                      format: 'HH:mm',
                    ),
                    icon: '🩺',
                  ),

                  const SizedBox(height: 16),
                  // ListItem(
                  //   label: 'Oxygen Saturation',
                  //   value:
                  //       '${(double.parse(controller.oxygenSaturation.value?.value.toString() ?? '0') * 100).toInt()}',
                  //   unit: '%',
                  //   time: DateTimeUtils.format(
                  //     controller.oxygenSaturation.value?.dateFrom,
                  //     format: 'HH:mm',
                  //   ),
                  //   icon: '💦',
                  // ),
                  // const SizedBox(height: 16),
                ],
              ),
            );
          },
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
