import 'package:hive/hive.dart';

part 'record.model.g.dart';

@HiveType(typeId: 1)
class HealthRecord {
  @HiveField(0)
  final double systolicPressure;

  @HiveField(1)
  final double diastolicPressure;

  @HiveField(2)
  final double heartRate;

  @HiveField(3)
  final double cardiacOutput;

  @HiveField(4)
  final double k;

  @HiveField(5)
  final DateTime updatedAt;

  HealthRecord({
    required this.systolicPressure,
    required this.diastolicPressure,
    required this.heartRate,
    required this.cardiacOutput,
    required this.k,
    required this.updatedAt,
  });
}
