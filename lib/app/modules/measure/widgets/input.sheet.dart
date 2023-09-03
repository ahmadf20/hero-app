import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../measure.controller.dart';
import 'input_sheet.controller.dart';

class InputSheet extends StatelessWidget {
  const InputSheet({
    required this.meassureController,
    this.isHeartRate = false,
    this.intitialValue1,
    this.intitialValue2,
    Key? key,
  }) : super(key: key);

  final bool? isHeartRate;
  final String? intitialValue1;
  final String? intitialValue2;
  final MeasureController meassureController;

  @override
  Widget build(BuildContext context) {
    return GetX(
      init: InputSheetController(
        intitialValue1: intitialValue1,
        intitialValue2: intitialValue2,
        isHeartRate: isHeartRate,
        meassureController: meassureController,
      ),
      builder: (c) {
        return SafeArea(
          top: false,
          child: Container(
            padding: const EdgeInsets.all(24).copyWith(bottom: 8),
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
                        c.isHeartRate! ? 'Heart Rate' : 'Blood Pressure',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: c.input1.controller,
                        decoration: InputDecoration(
                          label:
                              Text(c.isHeartRate! ? 'Heart Rate' : 'Systolic'),
                          filled: true,
                          fillColor: Theme.of(context)
                              .colorScheme
                              .primary
                              .withOpacity(.1),
                          suffixText: c.isHeartRate! ? 'BPM' : 'mmHg',
                        ),
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                        ],
                        keyboardType: const TextInputType.numberWithOptions(
                          decimal: true,
                        ),
                        autofocus: true,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'This field is required';
                          }
                          return null;
                        },
                      ),
                    ),
                    if (!c.isHeartRate!) ...[
                      const SizedBox(width: 16),
                      Expanded(
                        child: TextFormField(
                          controller: c.input2.controller,
                          decoration: InputDecoration(
                            label: const Text('Diastolic'),
                            filled: true,
                            fillColor: Theme.of(context)
                                .colorScheme
                                .primary
                                .withOpacity(.1),
                            suffixText: 'mmHg',
                          ),
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                          ],
                          keyboardType: const TextInputType.numberWithOptions(
                            decimal: true,
                          ),
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'This field is required';
                            }
                            return null;
                          },
                        ),
                      ),
                    ],
                  ],
                ),
                const SizedBox(height: 16),
                FilledButton(
                  onPressed: c.getIsFormValid ? c.save : null,
                  child: const Text('Save'),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
