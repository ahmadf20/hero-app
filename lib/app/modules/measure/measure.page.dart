import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../core/utils/date_time.dart';
import '../../widgets/_base/screen_wrapper.widget.dart';
import '../home/home.page.dart';
import 'measure.controller.dart';

class MeasurePage extends StatelessWidget {
  const MeasurePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetX<MeasureController>(
      init: MeasureController(),
      builder: (controller) {
        return ScreenWrapper(
          child: Stack(
            alignment: Alignment.center,
            children: [
              ListView(
                padding: const EdgeInsets.only(bottom: 56),
                children: [
                  const SizedBox(height: 30),
                  Text(
                    'Meassure',
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                  ),
                  const SizedBox(height: 22),
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
                  if (controller.heartRate.value != null) ...[
                    const SizedBox(height: 16),
                    ListItem(
                      label: 'Cardiac Output',
                      value:
                          '${double.parse(controller.heartRate.value?.value.toString() ?? '0').toInt()}',
                      unit: 'L/min',
                      time: DateTimeUtils.format(
                        controller.heartRate.value?.dateFrom,
                        format: 'HH.mm',
                      ),
                      icon: '🫀',
                    ),
                  ],
                  const SizedBox(height: 16),
                  Text(
                    'Input',
                    style: Theme.of(context)
                        .textTheme
                        .titleMedium
                        ?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  Text(
                    'Tap the card to edit',
                    style: TextStyle(color: Colors.grey.shade600),
                  ),
                  if (controller.bloodPressureSystolic.value != null &&
                      controller.bloodPressureDiastolic.value != null) ...[
                    const SizedBox(height: 16),
                    ListItem(
                      label: 'Blood Pressure',
                      value:
                          '${double.parse(controller.bloodPressureSystolic.value?.value.toString() ?? '0').toInt()}/${double.parse(controller.bloodPressureDiastolic.value?.value.toString() ?? '0').toInt()}',
                      unit: 'mmHg',
                      time: DateTimeUtils.format(
                        controller.bloodPressureSystolic.value?.dateFrom,
                        format: 'HH.mm',
                      ),
                      icon: '🩸',
                      // suffix: IconButton.filled(
                      //   onPressed: () {},
                      //   icon: const Icon(
                      //     Icons.edit_note_rounded,
                      //     color: Colors.white,
                      //   ),
                      // ),
                      onPressed: () {
                        Get.bottomSheet(
                          const InputDialog(),
                          backgroundColor: Theme.of(context).canvasColor,
                        );
                      },
                    ),
                  ],
                  if (controller.heartRate.value != null) ...[
                    const SizedBox(height: 16),
                    ListItem(
                      label: 'Heart Rate',
                      value:
                          '${double.parse(controller.heartRate.value?.value.toString() ?? '0').toInt()}',
                      unit: 'BPM',
                      time: DateTimeUtils.format(
                        controller.heartRate.value?.dateFrom,
                        format: 'HH.mm',
                      ),
                      icon: '🩺',
                      // suffix: IconButton.filled(
                      //   onPressed: () {},
                      //   icon: const Icon(
                      //     Icons.sync_rounded,
                      //     color: Colors.white,
                      //   ),
                      // ),
                      onPressed: () {
                        Get.bottomSheet(
                          const InputDialog(),
                          backgroundColor: Theme.of(context).canvasColor,
                        );
                      },
                    ),
                  ],
                ],
              ),
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  child: Row(
                    children: [
                      if (controller.meassuringState.value ==
                          MeassuringState.paused) ...[
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

class InputDialog extends StatelessWidget {
  const InputDialog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Transform.translate(
            offset: const Offset(-16, 0),
            child: Row(
              children: [
                IconButton(
                  onPressed: Get.back,
                  icon: const Icon(Icons.close_rounded),
                ),
                Text(
                  'Blood Pressure',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  decoration: InputDecoration(
                    label: const Text('Systolic'),
                    filled: true,
                    fillColor:
                        Theme.of(context).colorScheme.primary.withOpacity(.1),
                    suffixText: 'mmHg',
                  ),
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(
                      RegExp(r'^(\d+)?\.?\d{0,2}'),
                    ),
                  ],
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                  autofocus: true,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
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
                  decoration: InputDecoration(
                    label: const Text('Diastolic'),
                    filled: true,
                    fillColor:
                        Theme.of(context).colorScheme.primary.withOpacity(.1),
                    suffixText: 'mmHg',
                  ),
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(
                      RegExp(r'^(\d+)?\.?\d{0,2}'),
                    ),
                  ],
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Weight is required';
                    }
                    return null;
                  },
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          FilledButton(
            onPressed: Get.back,
            child: const Text('Save'),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}
