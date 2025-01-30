import 'dart:ffi';

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
  double maxTempC;

  @HiveField(3)
  double maxTempF;

  @HiveField(4)
  double minTempC;

  @HiveField(5)
  double minTempF;

  @HiveField(6)
  ConditionEntity condition;

  DayEntity({
    required this.tempC,
    required this.tempF,
    required this.maxTempC,
    required this.maxTempF,
    required this.minTempC,
    required this.minTempF,
    required this.condition,
  });
}
