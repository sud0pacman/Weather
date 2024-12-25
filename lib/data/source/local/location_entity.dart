import 'package:hive/hive.dart';

part 'location_entity.g.dart';

@HiveType(typeId: 6)
class LocationEntity {
  @HiveField(0)
  String name;

  @HiveField(1)
  String region;

  @HiveField(2)
  String country;

  @HiveField(3)
  double lat;

  @HiveField(4)
  double lon;

  @HiveField(5)
  String tzId;

  @HiveField(6)
  String localtimeEpoch;

  @HiveField(7)
  String localtime;

  LocationEntity({
    required this.name,
    required this.region,
    required this.country,
    required this.lat,
    required this.lon,
    required this.tzId,
    required this.localtimeEpoch,
    required this.localtime,
  });
}
