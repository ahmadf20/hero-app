// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'record.model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class HealthRecordAdapter extends TypeAdapter<HealthRecord> {
  @override
  final int typeId = 1;

  @override
  HealthRecord read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return HealthRecord(
      systolicPressure: fields[0] as double,
      diastolicPressure: fields[1] as double,
      heartRate: fields[2] as double,
      cardiacOutput: fields[3] as double,
      k: fields[4] as double,
      updatedAt: fields[5] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, HealthRecord obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.systolicPressure)
      ..writeByte(1)
      ..write(obj.diastolicPressure)
      ..writeByte(2)
      ..write(obj.heartRate)
      ..writeByte(3)
      ..write(obj.cardiacOutput)
      ..writeByte(4)
      ..write(obj.k)
      ..writeByte(5)
      ..write(obj.updatedAt);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is HealthRecordAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
