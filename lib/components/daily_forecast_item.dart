import 'package:flutter/material.dart';
import 'package:weather_now/components/shape.dart';
import 'package:weather_now/data/model/weather_model.dart';
import 'package:weather_now/utils/extensions/extensions.dart';
import 'package:weather_now/utils/helpers/app_helpers.dart';
import 'package:weather_now/utils/theme/app_text_styles.dart';
import 'package:weather_now/utils/theme/colors.dart';

class DailyForecastItem extends StatelessWidget {
  final ForecastDay day;
  const DailyForecastItem({super.key, required this.day});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: AppGenericShape(
          cornerRadius: 20,
          child: Container(
            decoration: BoxDecoration(color: Colors.white.withOpacity(0.05)),
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Row(
                children: [
                  Column(
                    children: [
                      Text(
                        AppHelpers.getWeekdayByDate(day.date),
                        overflow: TextOverflow.ellipsis,
                        style: sfsemiBold.copyWith(fontSize: 16),
                      ),
                      Text(
                        day.day.condition.text,
                        overflow: TextOverflow.ellipsis,
                        style: sfregular.copyWith(
                          fontSize: 14,
                          color: AppColors.secondaryText,
                        ),
                      ),
                    ],
                  ),
                  Expanded(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "${day.day.tempC} °",
                            style: sfbold.copyWith(fontSize: 32),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 8.0),
                            child: Text(
                              "C",
                              style: sfregular.copyWith(fontSize: 24),
                            ),
                          ),
                        ],
                      )),
                  SizedBox(
                    height: 70,
                    child: Image.asset(day.day.condition.code.getCustomIcon()),
                  )
                ],
              ),
            ),
          )),
    );
  }
}
