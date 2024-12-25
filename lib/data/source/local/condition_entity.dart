import 'package:hive/hive.dart';

import '../../model/condition_model.dart';

part 'condition_entity.g.dart';

@HiveType(typeId: 5)
class ConditionEntity {
  @HiveField(0)
  String text;

  @HiveField(1)
  String icon;

  @HiveField(2)
  num code;

  ConditionEntity({
    required this.text,
    required this.icon,
    required this.code,
  });

  // Add this factory constructor to convert from a network model (Condition) to a local model (ConditionEntity)
  factory ConditionEntity.fromCondition(Condition condition) {
    return ConditionEntity(
      text: condition.text,
      icon: condition.icon,
      code: condition.code,
    );
  }

  // Add this method if you need to convert back from a local model to the network model
  Condition toCondition() {
    return Condition(
      text: text,
      icon: icon,
      code: code.toInt(),
    );
  }
}
