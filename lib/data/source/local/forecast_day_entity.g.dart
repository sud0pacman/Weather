// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'forecast_day_entity.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ForecastDayEntityAdapter extends TypeAdapter<ForecastDayEntity> {
  @override
  final int typeId = 8;

  @override
  ForecastDayEntity read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ForecastDayEntity(
      date: fields[0] as String,
      day: fields[1] as DayEntity,
      hours: (fields[2] as List).cast<HourEntity>(),
    );
  }

  @override
  void write(BinaryWriter writer, ForecastDayEntity obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.date)
      ..writeByte(1)
      ..write(obj.day)
      ..writeByte(2)
      ..write(obj.hours);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ForecastDayEntityAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
