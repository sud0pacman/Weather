// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'day_entity.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class DayEntityAdapter extends TypeAdapter<DayEntity> {
  @override
  final int typeId = 3;

  @override
  DayEntity read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return DayEntity(
      tempC: fields[0] as double,
      tempF: fields[1] as double,
      maxTempC: fields[2] as double,
      maxTempF: fields[3] as double,
      minTempC: fields[4] as double,
      minTempF: fields[5] as double,
      condition: fields[6] as ConditionEntity,
    );
  }

  @override
  void write(BinaryWriter writer, DayEntity obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.tempC)
      ..writeByte(1)
      ..write(obj.tempF)
      ..writeByte(2)
      ..write(obj.maxTempC)
      ..writeByte(3)
      ..write(obj.maxTempF)
      ..writeByte(4)
      ..write(obj.minTempC)
      ..writeByte(5)
      ..write(obj.minTempF)
      ..writeByte(6)
      ..write(obj.condition);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DayEntityAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
