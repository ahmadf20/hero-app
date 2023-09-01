import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../core/utils/date_time.dart';
import '../../widgets/_base/screen_wrapper.widget.dart';
import '../home/home.page.dart';
import 'measure.controller.dart';
import 'widgets/input.sheet.dart';

class MeasurePage extends StatelessWidget {
  const MeasurePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetX<MeasureController>(
      init: MeasureController(),
      builder: (controller) {
        final bps = controller.bloodPressureSystolic.value;
        final bpd = controller.bloodPressureDiastolic.value;
        final heartRate = controller.heartRate.value;
        final co = controller.cardiacOutput.value;

        return ScreenWrapper(
          child: Stack(
            alignment: Alignment.center,
            children: [
              ListView(
                padding: const EdgeInsets.only(bottom: 56),
                children: [
                  const SizedBox(height: 20),
                  Text(
                    'Measure',
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                  ),
                  const SizedBox(height: 22),
                  if (controller.hasCompleted)
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
                    )
                  else if (controller.meassuringState.value ==
                      MeassuringState.running)
                    const InformationHeader(
                      title: 'Measuring',
                      subtitle: 'Please wait',
                      icon: '⌛',
                    )
                  else if (controller.meassuringState.value ==
                      MeassuringState.paused)
                    const InformationHeader(
                      title: 'Paused',
                      subtitle: 'Tap continue to resume',
                      icon: '⌛',
                    )
                  else if (controller.meassuringState.value ==
                      MeassuringState.stopped)
                    const InformationHeader(
                      title: 'Start Measuring',
                      subtitle:
                          'Wear your smartwatach and tap start to begin or input the data manually instead',
                      icon: '▶',
                    ),
                  const SizedBox(height: 24),
                  ListItem(
                    label: 'Cardiac Output',
                    value: co?.value.toStringAsFixed(1) ?? '0',
                    unit: 'L/min',
                    time: DateTimeUtils.format(co?.updatedAt, format: 'HH:mm'),
                    icon: '🫀',
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Input',
                    style: Theme.of(context)
                        .textTheme
                        .titleMedium
                        ?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  ListItem(
                    label: 'Blood Pressure',
                    value:
                        '${bps?.value.toStringAsFixed(0) ?? '0'}/${bpd?.value.toStringAsFixed(0) ?? '0'}',
                    unit: 'mmHg',
                    time: DateTimeUtils.format(bps?.updatedAt, format: 'HH:mm'),
                    icon: '🩸',
                    onPressed: () {
                      Get.bottomSheet(
                        InputSheet(
                          meassureController: controller,
                          intitialValue1: bps?.value.toStringAsFixed(0),
                          intitialValue2: bpd?.value.toStringAsFixed(0),
                        ),
                        backgroundColor: Theme.of(context).canvasColor,
                      );
                    },
                  ),
                  const SizedBox(height: 16),
                  ListItem(
                    label: 'Heart Rate',
                    value: heartRate?.value.toStringAsFixed(0) ?? '0',
                    unit: 'BPM',
                    time: DateTimeUtils.format(
                      heartRate?.updatedAt,
                      format: 'HH:mm',
                    ),
                    icon: '🩺',
                    onPressed: () {
                      Get.bottomSheet(
                        InputSheet(
                          meassureController: controller,
                          isHeartRate: true,
                          intitialValue1: heartRate?.value.toStringAsFixed(0),
                        ),
                        backgroundColor: Theme.of(context).canvasColor,
                      );
                    },
                  ),
                ],
              ),
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          if (controller.meassuringState.value ==
                                  MeassuringState.paused ||
                              controller.hasCompleted) ...[
                            Expanded(
                              child: FilledButton.tonalIcon(
                                onPressed: controller.resetMeassure,
                                label: const Text(
                                  'Reset',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                icon: const Icon(Icons.close_rounded),
                              ),
                            ),
                            const SizedBox(width: 8),
                          ],
                          if (!controller.hasCompleted)
                            Expanded(
                              child: FilledButton.icon(
                                onPressed: controller.meassuringState.value ==
                                        MeassuringState.running
                                    ? controller.stopMeassure
                                    : controller.startMeassure,
                                label: Text(
                                  controller.meassuringState.value ==
                                          MeassuringState.running
                                      ? 'Stop'
                                      : controller.meassuringState.value ==
                                              MeassuringState.paused
                                          ? 'Continue'
                                          : 'Start',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                icon: Icon(
                                  controller.meassuringState.value ==
                                          MeassuringState.running
                                      ? Icons.stop_rounded
                                      : Icons.play_arrow_rounded,
                                ),
                              ),
                            ),
                          if (controller.hasCompleted) ...[
                            Expanded(
                              child: FilledButton.icon(
                                onPressed: controller.save,
                                label: const Text(
                                  'Save',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                icon: const Icon(Icons.upload_rounded),
                              ),
                            ),
                          ],
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class InformationHeader extends StatelessWidget {
  final String title;
  final String subtitle;
  final String icon;

  const InformationHeader({
    required this.title,
    required this.subtitle,
    required this.icon,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          icon,
          style: const TextStyle(
            fontSize: 100,
            height: 1.2,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          title,
          style: Theme.of(context).textTheme.headlineSmall,
        ),
        const SizedBox(height: 8),
        Text(
          subtitle,
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
