import 'package:hive/hive.dart';
import 'package:weather_now/data/source/local/condition_entity.dart';

import '../../model/current_model.dart';

part 'current_entity.g.dart';

@HiveType(typeId: 2)
class CurrentEntity extends HiveObject {
  @HiveField(0)
  final int lastUpdatedEpoch;

  @HiveField(1)
  final String lastUpdated;

  @HiveField(2)
  final double tempC;

  @HiveField(3)
  final double tempF;

  @HiveField(4)
  final int isDay;

  @HiveField(5)
  final ConditionEntity condition;

  @HiveField(6)
  final double windMph;

  @HiveField(7)
  final double windKph;

  @HiveField(8)
  final int windDegree;

  @HiveField(9)
  final String windDir;

  @HiveField(10)
  final double pressureMb;

  @HiveField(11)
  final double pressureIn;

  @HiveField(12)
  final double precipMm;

  @HiveField(13)
  final double precipIn;

  @HiveField(14)
  final int humidity;

  @HiveField(15)
  final int cloud;

  @HiveField(16)
  final double feelslikeC;

  @HiveField(17)
  final double feelslikeF;

  @HiveField(18)
  final double visKm;

  @HiveField(19)
  final double visMiles;

  @HiveField(20)
  final double uv;

  @HiveField(21)
  final double gustMph;

  @HiveField(22)
  final double gustKph;

  CurrentEntity({
    required this.lastUpdatedEpoch,
    required this.lastUpdated,
    required this.tempC,
    required this.tempF,
    required this.isDay,
    required this.condition,
    required this.windMph,
    required this.windKph,
    required this.windDegree,
    required this.windDir,
    required this.pressureMb,
    required this.pressureIn,
    required this.precipMm,
    required this.precipIn,
    required this.humidity,
    required this.cloud,
    required this.feelslikeC,
    required this.feelslikeF,
    required this.visKm,
    required this.visMiles,
    required this.uv,
    required this.gustMph,
    required this.gustKph,
  });

  // Network modeldan local modelga o'tkazish uchun factory
  factory CurrentEntity.fromCurrent(Current current) {
    return CurrentEntity(
      lastUpdatedEpoch: current.lastUpdatedEpoch,
      lastUpdated: current.lastUpdated,
      tempC: current.tempC,
      tempF: current.tempF,
      isDay: current.isDay,
      condition: ConditionEntity.fromCondition(current.condition),
      windMph: current.windMph,
      windKph: current.windKph,
      windDegree: current.windDegree,
      windDir: current.windDir,
      pressureMb: current.pressureMb,
      pressureIn: current.pressureIn,
      precipMm: current.precipMm,
      precipIn: current.precipIn,
      humidity: current.humidity,
      cloud: current.cloud,
      feelslikeC: current.feelslikeC,
      feelslikeF: current.feelslikeF,
      visKm: current.visKm,
      visMiles: current.visMiles,
      uv: current.uv,
      gustMph: current.gustMph,
      gustKph: current.gustKph,
    );
  }

  // Local modeldan network modelga o'tkazish uchun metod
  Current toCurrent() {
    return Current(
      lastUpdatedEpoch: lastUpdatedEpoch,
      lastUpdated: lastUpdated,
      tempC: tempC,
      tempF: tempF,
      isDay: isDay,
      condition: condition.toCondition(),
      windMph: windMph,
      windKph: windKph,
      windDegree: windDegree,
      windDir: windDir,
      pressureMb: pressureMb,
      pressureIn: pressureIn,
      precipMm: precipMm,
      precipIn: precipIn,
      humidity: humidity,
      cloud: cloud,
      feelslikeC: feelslikeC,
      feelslikeF: feelslikeF,
      visKm: visKm,
      visMiles: visMiles,
      uv: uv,
      gustMph: gustMph,
      gustKph: gustKph,
    );
  }
}
