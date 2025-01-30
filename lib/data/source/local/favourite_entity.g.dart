// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'favourite_entity.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class FavouriteEntityAdapter extends TypeAdapter<FavouriteEntity> {
  @override
  final int typeId = 0;

  @override
  FavouriteEntity read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return FavouriteEntity(
      name: fields[0] as String?,
      region: fields[1] as String?,
      lat: fields[2] as double?,
      lon: fields[3] as double?,
      iconCode: fields[4] as int?,
      tempC: fields[5] as double?,
      tempF: fields[6] as double?,
      country: fields[7] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, FavouriteEntity obj) {
    writer
      ..writeByte(8)
      ..writeByte(0)
      ..write(obj.name)
      ..writeByte(1)
      ..write(obj.region)
      ..writeByte(2)
      ..write(obj.lat)
      ..writeByte(3)
      ..write(obj.lon)
      ..writeByte(4)
      ..write(obj.iconCode)
      ..writeByte(5)
      ..write(obj.tempC)
      ..writeByte(6)
      ..write(obj.tempF)
      ..writeByte(7)
      ..write(obj.country);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is FavouriteEntityAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
