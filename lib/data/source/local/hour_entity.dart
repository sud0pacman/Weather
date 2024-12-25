
import 'package:hive/hive.dart';
import 'package:weather_now/data/source/local/condition_entity.dart';

part 'hour_entity.g.dart';


@HiveType(typeId: 4)
class HourEntity {
  @HiveField(0)
  num timeEpoch;

  @HiveField(1)
  String time;

  @HiveField(2)
  double tempC;

  @HiveField(3)
  double tempF;

  @HiveField(4)
  num isDay;

  @HiveField(5)
  ConditionEntity condition;

  @HiveField(6)
  double windMph;

  @HiveField(7)
  double windKph;

  // Qo'shimcha maydonlar xuddi shu usulda davom etadi...

  HourEntity({
    required this.timeEpoch,
    required this.time,
    required this.tempC,
    required this.tempF,
    required this.isDay,
    required this.condition,
    required this.windMph,
    required this.windKph,
    // Qo'shimcha maydonlarni ham qo'shing...
  });
}
