// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'forecast_entity.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ForecastEntityAdapter extends TypeAdapter<ForecastEntity> {
  @override
  final int typeId = 1;

  @override
  ForecastEntity read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ForecastEntity(
      forecastDays: (fields[0] as List).cast<ForecastDayEntity>(),
    );
  }

  @override
  void write(BinaryWriter writer, ForecastEntity obj) {
    writer
      ..writeByte(1)
      ..writeByte(0)
      ..write(obj.forecastDays);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ForecastEntityAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
