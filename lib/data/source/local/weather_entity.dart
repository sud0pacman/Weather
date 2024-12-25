import 'package:hive/hive.dart';
import 'package:weather_now/data/source/local/current_entity.dart';
import 'package:weather_now/data/source/local/forecast_entity.dart';
import 'package:weather_now/data/source/local/location_entity.dart';

part 'weather_entity.g.dart';

@HiveType(typeId: 7)
class WeatherEntity {

  @HiveField(0)
  LocationEntity location;

  @HiveField(1)
  CurrentEntity current;

  @HiveField(2)
  ForecastEntity forecast;

  WeatherEntity({
    required this.location,
    required this.current,
    required this.forecast,
  });
}
