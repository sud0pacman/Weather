// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'location_entity.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class LocationEntityAdapter extends TypeAdapter<LocationEntity> {
  @override
  final int typeId = 6;

  @override
  LocationEntity read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return LocationEntity(
      name: fields[0] as String,
      region: fields[1] as String,
      country: fields[2] as String,
      lat: fields[3] as double,
      lon: fields[4] as double,
      tzId: fields[5] as String,
      localtimeEpoch: fields[6] as String,
      localtime: fields[7] as String,
    );
  }

  @override
  void write(BinaryWriter writer, LocationEntity obj) {
    writer
      ..writeByte(8)
      ..writeByte(0)
      ..write(obj.name)
      ..writeByte(1)
      ..write(obj.region)
      ..writeByte(2)
      ..write(obj.country)
      ..writeByte(3)
      ..write(obj.lat)
      ..writeByte(4)
      ..write(obj.lon)
      ..writeByte(5)
      ..write(obj.tzId)
      ..writeByte(6)
      ..write(obj.localtimeEpoch)
      ..writeByte(7)
      ..write(obj.localtime);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is LocationEntityAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
