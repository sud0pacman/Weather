import 'package:hive_flutter/hive_flutter.dart';
import 'package:weather_now/data/source/local/condition_entity.dart';

part 'day_entity.g.dart';

@HiveType(typeId: 3)
class DayEntity {
  @HiveField(0)
  double tempC;

  @HiveField(1)
  double tempF;

  @HiveField(2)
  ConditionEntity condition;

  DayEntity({
    required this.tempC,
    required this.tempF,
    required this.condition,
  });
}
