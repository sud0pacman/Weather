// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'current_entity.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class CurrentEntityAdapter extends TypeAdapter<CurrentEntity> {
  @override
  final int typeId = 2;

  @override
  CurrentEntity read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return CurrentEntity(
      lastUpdatedEpoch: fields[0] as int,
      lastUpdated: fields[1] as String,
      tempC: fields[2] as double,
      tempF: fields[3] as double,
      isDay: fields[4] as int,
      condition: fields[5] as ConditionEntity,
      windMph: fields[6] as double,
      windKph: fields[7] as double,
      windDegree: fields[8] as int,
      windDir: fields[9] as String,
      pressureMb: fields[10] as double,
      pressureIn: fields[11] as double,
      precipMm: fields[12] as double,
      precipIn: fields[13] as double,
      humidity: fields[14] as int,
      cloud: fields[15] as int,
      feelslikeC: fields[16] as double,
      feelslikeF: fields[17] as double,
      visKm: fields[18] as double,
      visMiles: fields[19] as double,
      uv: fields[20] as double,
      gustMph: fields[21] as double,
      gustKph: fields[22] as double,
    );
  }

  @override
  void write(BinaryWriter writer, CurrentEntity obj) {
    writer
      ..writeByte(23)
      ..writeByte(0)
      ..write(obj.lastUpdatedEpoch)
      ..writeByte(1)
      ..write(obj.lastUpdated)
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
      ..write(obj.windKph)
      ..writeByte(8)
      ..write(obj.windDegree)
      ..writeByte(9)
      ..write(obj.windDir)
      ..writeByte(10)
      ..write(obj.pressureMb)
      ..writeByte(11)
      ..write(obj.pressureIn)
      ..writeByte(12)
      ..write(obj.precipMm)
      ..writeByte(13)
      ..write(obj.precipIn)
      ..writeByte(14)
      ..write(obj.humidity)
      ..writeByte(15)
      ..write(obj.cloud)
      ..writeByte(16)
      ..write(obj.feelslikeC)
      ..writeByte(17)
      ..write(obj.feelslikeF)
      ..writeByte(18)
      ..write(obj.visKm)
      ..writeByte(19)
      ..write(obj.visMiles)
      ..writeByte(20)
      ..write(obj.uv)
      ..writeByte(21)
      ..write(obj.gustMph)
      ..writeByte(22)
      ..write(obj.gustKph);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CurrentEntityAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
