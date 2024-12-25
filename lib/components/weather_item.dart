import 'package:flutter/material.dart';
import 'package:weather_now/components/shape.dart';
import 'package:weather_now/utils/extensions/extensions.dart';
import 'package:weather_now/utils/theme/app_text_styles.dart';

import '../data/model/weather_model.dart';

class WeatherItem extends StatelessWidget {
  final bool isNow;
  final Hour hour;

  const WeatherItem({super.key, this.isNow = false, required this.hour});

  @override
  Widget build(BuildContext context) {
    return AppGenericShape(
      cornerRadius: 30,
      child: Container(
        decoration: BoxDecoration(
          color: isNow
              ? Colors.blue
              : Colors.white.withOpacity(0.05),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(
              horizontal: 16.0, vertical: 16),
          child: Row(
            children: [
              SizedBox(
                child: Image.asset(hour.condition.code.getCustomIcon()),
              ),
              const SizedBox(width: 16),
              Column(
                children: [
                  Text(
                    hour.time.substring(11),
                    style: sfsemiBold.copyWith(fontSize: 14),
                  ),
                  Text(
                    "${hour.tempC} °",
                    style: sfsemiBold.copyWith(fontSize: 18),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
