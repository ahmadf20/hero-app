import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import 'input_sheet.controller.dart';

class InputRecordSheet extends StatelessWidget {
  const InputRecordSheet({
    this.isFirstRecord,
    Key? key,
  }) : super(key: key);

  final bool? isFirstRecord;

  @override
  Widget build(BuildContext context) {
    return GetX(
      init: InputSheetController(
        isFirstRecord: isFirstRecord,
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
                        'Add Record',
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
                        controller: c.sbp.controller,
                        decoration: InputDecoration(
                          label: const Text('Systolic'),
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
                    const SizedBox(width: 16),
                    Expanded(
                      child: TextFormField(
                        controller: c.dbp.controller,
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
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: c.hr.controller,
                  decoration: InputDecoration(
                    label: const Text('Heart Rate'),
                    filled: true,
                    fillColor:
                        Theme.of(context).colorScheme.primary.withOpacity(.1),
                    suffixText: 'BPM',
                  ),
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
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
                const SizedBox(height: 16),
                if ((isFirstRecord ?? false) ||
                    c.co.controller.text.isNotEmpty) ...[
                  const Text('Output'),
                  const SizedBox(height: 16),
                  TextFormField(
                    readOnly: isFirstRecord != true,
                    controller: c.co.controller,
                    decoration: InputDecoration(
                      label: const Text('Cardiac Output'),
                      filled: true,
                      fillColor:
                          Theme.of(context).colorScheme.primary.withOpacity(.1),
                      suffixText: 'L/min',
                    ),
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(
                        RegExp(r'^\d*\.?\d{0,2}'),
                      ),
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
                ],
                const SizedBox(height: 24),
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
