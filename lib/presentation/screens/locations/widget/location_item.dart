import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:weather_now/components/daily_forecast_item.dart';
import 'package:weather_now/components/shape.dart';
import 'package:weather_now/utils/extensions/extensions.dart';
import 'package:weather_now/utils/helpers/app_helpers.dart';
import 'package:weather_now/utils/theme/app_styles.dart';

import '../../../../utils/theme/colors.dart';

class LocationItem extends StatelessWidget {
  final bool isCurrent;

  const LocationItem({super.key, required this.isCurrent});

  @override
  Widget build(BuildContext context) {
    return AppGenericShape(
      cornerRadius: 25,
      child: Container(
        height: 115,
        width: AppHelpers.screenWidth(context),
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.1),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (isCurrent) const Icon(
                              Icons.location_on_rounded,
                              color: AppColors.white,
                              size: 18,
                            ),

                      if (isCurrent) 6.horizontalSpace,

                      const Expanded(
                        child: Text(
                          "Moskva",
                          style: AppStyles.bodyRegularXL,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),

                  Text(
                    "Rossiya",
                    style: AppStyles.bodyRegularM.copyWith(
                      color: AppColors.secondaryText
                    ),
                  ),

                  Text(
                    "Tue, December 17 5:14 PM",
                    style: AppStyles.bodyRegularM.copyWith(
                        color: AppColors.secondaryText
                    ),
                  )
                ],
              ),
            ),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Image.asset(
                        1103.getCustomIcon(),
                        width: 32,
                        height: 32,
                      ),

                      6.horizontalSpace,

                      Flexible(
                        child: Text(
                          "11°",
                          style: AppStyles.bodyRegularXL.copyWith(
                            fontSize: 32
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),

                  Text(
                    "11°/6°",
                    style: AppStyles.bodyRegularM.copyWith(
                      color: AppColors.secondaryText
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
