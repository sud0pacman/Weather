import 'package:hive/hive.dart';
import 'package:weather_now/data/source/local/forecast_day_entity.dart';

part 'forecast_entity.g.dart';

@HiveType(typeId: 1)
class ForecastEntity {
  @HiveField(0)
  List<ForecastDayEntity> forecastDays;

  ForecastEntity({required this.forecastDays});
}
