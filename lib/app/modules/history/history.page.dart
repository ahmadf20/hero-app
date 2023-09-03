import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../../core/utils/date_time.dart';
import '../../data/models/record.model.dart';
import '../../widgets/_base/screen_wrapper.widget.dart';
import '../home/home.page.dart';
import 'history.controller.dart';
import 'widgets/input.sheet.dart';

class HistoryPage extends StatelessWidget {
  HistoryPage({Key? key}) : super(key: key);

  final controller = Get.put(HistoryController());

  @override
  Widget build(BuildContext context) {
    String getFormatDate(DateTime date) {
      final now = DateTime.now();

      var format = '';

      final differece = now.difference(date);

      if (now.year == date.year) {
        if (differece.inDays > 0) {
          format = 'dd MMM';
        }
      }

      format = format.isNotEmpty ? '$format • HH:mm' : 'HH:mm';

      return DateTimeUtils.format(date, format: 'MMM d yyy, HH:mm');
    }

    return ScreenWrapper(
      // floatingActionButton: isEmpty
      //     ? null
      //     : FloatingActionButton(
      //         elevation: 75,
      //         backgroundColor: Theme.of(context).colorScheme.primary,
      //         onPressed: () {
      //           (){
      //  }();
      //           // Get.bottomSheet(
      //           //   InputSheet(),
      //           //   backgroundColor: Theme.of(context).canvasColor,
      //           // );
      //         },
      //         child: const Icon(
      //           Icons.add,
      //           color: Colors.white,
      //         ),
      //       ),
      child: ValueListenableBuilder(
        valueListenable: Hive.box<HealthRecord>('records').listenable(),
        builder: (context, box, child) {
          final isEmpty = box.isEmpty;

          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Records',
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                  ),
                  const SizedBox(width: 16),
                  if (!isEmpty)
                    IconButton.filled(
                      iconSize: 24,
                      onPressed: () {
                        Get.bottomSheet(
                          const InputRecordSheet(),
                          backgroundColor: Theme.of(context).canvasColor,
                          isScrollControlled: true,
                        );
                      },
                      icon: const Icon(Icons.add),
                    ),
                ],
              ),
              const SizedBox(height: 24),
              if (isEmpty)
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      children: [
                        const Spacer(),
                        Icon(
                          Icons.assignment_late_outlined,
                          size: 100,
                          color: Colors.grey.shade500,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'No records yet',
                          style: Theme.of(context).textTheme.headlineSmall,
                        ),
                        const SizedBox(height: 16),
                        const Text(
                          'First record needs to be added manually to calibrate the app',
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 24),
                        FilledButton.tonalIcon(
                          onPressed: () {
                            Get.bottomSheet(
                              const InputRecordSheet(isFirstRecord: true),
                              backgroundColor: Theme.of(context).canvasColor,
                              isScrollControlled: true,
                            );
                          },
                          icon: const Icon(Icons.add),
                          label: const Text('Add'),
                        ),
                        const SizedBox(height: 36),
                        const Spacer(),
                      ],
                    ),
                  ),
                ),
              if (!isEmpty)
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.only(bottom: 72),
                    itemCount: box.length,
                    itemBuilder: (context, index) {
                      final currIndex = box.length - index - 1;
                      final item = box.getAt(currIndex);

                      return Padding(
                        padding: const EdgeInsets.only(bottom: 16),
                        child: ListItem(
                          label: getFormatDate(item!.updatedAt),
                          value: '${item.cardiacOutput}',
                          unit: 'L/min',
                          icon: '🫀',
                          suffix: IconButton.filledTonal(
                            onPressed: () {
                              Get.bottomSheet(
                                DeleteConfirmationSheet(index: currIndex),
                                backgroundColor: Theme.of(context).canvasColor,
                                isScrollControlled: true,
                              );
                            },
                            icon: const Icon(Icons.close_rounded),
                          ),
                          onPressed: () {
                            Get.bottomSheet(
                              DetailSheet(data: item),
                              backgroundColor: Theme.of(context).canvasColor,
                              isScrollControlled: true,
                            );
                          },
                        ),
                      );
                    },
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}

class DetailSheet extends StatelessWidget {
  const DetailSheet({
    this.data,
    Key? key,
  }) : super(key: key);

  final HealthRecord? data;

  @override
  Widget build(BuildContext context) {
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
                    'Detail Record',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            ListItem(
              label: 'Date/Time',
              value: DateTimeUtils.format(
                data?.updatedAt,
                format: 'dd MMM yyy, HH:mm',
              ),
              icon: '🗓',
            ),
            const SizedBox(height: 16),
            ListItem(
              label: 'Blood Pressure',
              value:
                  '${data?.systolicPressure.toInt()}/${data?.diastolicPressure.toInt()}',
              unit: 'mmHg',
              icon: '🩸',
            ),
            const SizedBox(height: 16),
            ListItem(
              label: 'Heart Rate',
              value: '${data?.heartRate.toInt()}',
              unit: 'BPM',
              icon: '🩺',
            ),
            const SizedBox(height: 16),
            ListItem(
              label: 'Cardiac Output',
              value: '${data?.cardiacOutput}',
              unit: 'L/min',
              icon: '🫀',
            ),
            const SizedBox(height: 16),
            FilledButton(
              onPressed: Get.back,
              child: const Text('Close'),
            ),
          ],
        ),
      ),
    );
  }
}

class DeleteConfirmationSheet extends StatelessWidget {
  const DeleteConfirmationSheet({
    required this.index,
    Key? key,
  }) : super(key: key);

  final int index;

  @override
  Widget build(BuildContext context) {
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
                    'Delete Record',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Are you sure you want to permanently delete this record? You cannot undone this action.',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: Colors.grey.shade600,
                  ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: FilledButton.tonal(
                    onPressed: Get.back,
                    child: const Text('Cancel'),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: FilledButton(
                    onPressed: () {
                      final recordBox = Hive.box<HealthRecord>('records');
                      recordBox.deleteAt(index);

                      Get.back();
                    },
                    child: const Text('Delete'),
                  ),
                ),
                const SizedBox(height: 16),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
