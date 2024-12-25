// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'hour_entity.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class HourEntityAdapter extends TypeAdapter<HourEntity> {
  @override
  final int typeId = 4;

  @override
  HourEntity read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return HourEntity(
      timeEpoch: fields[0] as num,
      time: fields[1] as String,
      tempC: fields[2] as double,
      tempF: fields[3] as double,
      isDay: fields[4] as num,
      condition: fields[5] as ConditionEntity,
      windMph: fields[6] as double,
      windKph: fields[7] as double,
    );
  }

  @override
  void write(BinaryWriter writer, HourEntity obj) {
    writer
      ..writeByte(8)
      ..writeByte(0)
      ..write(obj.timeEpoch)
      ..writeByte(1)
      ..write(obj.time)
      ..writeByte(2)
      ..write(obj.tempC)
      ..writeByte(3)
      ..write(obj.tempF)
      ..writeByte(4)
      ..write(obj.isDay)
      ..writeByte(5)
      ..write(obj.condition)
      ..writeByte(6)
      ..write(obj.windMph)
      ..writeByte(7)
      ..write(obj.windKph);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is HourEntityAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
