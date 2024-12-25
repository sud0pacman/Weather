import 'package:hive_flutter/adapters.dart';
import 'package:weather_now/data/source/local/day_entity.dart';
import 'package:weather_now/data/source/local/hour_entity.dart';

part 'forecast_day_entity.g.dart';


@HiveType(typeId: 8)
class ForecastDayEntity {
  @HiveField(0)
  String date;

  @HiveField(1)
  DayEntity day;

  @HiveField(2)
  List<HourEntity> hours;

  ForecastDayEntity({
    required this.date,
    required this.day,
    required this.hours,
  });
}
