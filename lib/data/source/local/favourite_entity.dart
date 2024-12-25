import 'package:hive/hive.dart';
import 'package:weather_now/data/model/favourite_model.dart';

part 'favourite_entity.g.dart';

@HiveType(typeId: 0) // Assign a unique typeId for this entity
class FavouriteEntity {
  @HiveField(0)
  String? name;

  @HiveField(1)
  String? region;

  @HiveField(2)
  double? lat;

  @HiveField(3)
  double? lon;

  @HiveField(4)
  int? iconCode;

  @HiveField(5)
  double? tempC;

  @HiveField(6)
  double? tempF;

  @HiveField(7)
  String? country;

  FavouriteEntity({this.name, this.region, this.lat, this.lon, this.iconCode, this.tempC, this.tempF, this.country});

  FavouriteModel toModel() {
    return FavouriteModel(
        name: name ?? "",
        region: region ?? '',
        country: country ?? '',
        lat: lat ?? 0,
        lon: lon ?? 0,
        isSaved: true,
        iconCode: iconCode ?? 0,
        tempC: tempC ?? 0,
        tempF: tempF ?? 0);
  }
}
