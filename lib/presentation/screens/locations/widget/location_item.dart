import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_reorderable_list/flutter_reorderable_list.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:weather_now/components/shape.dart';
import 'package:weather_now/data/model/weather_model.dart';
import 'package:weather_now/utils/constants.dart';
import 'package:weather_now/utils/extensions/extensions.dart';
import 'package:weather_now/utils/helpers/app_helpers.dart';
import 'package:weather_now/utils/theme/app_styles.dart';

import '../../../../data/source/local/weather_entity.dart';
import '../../../../utils/theme/colors.dart';
import '../locations_screen.dart';


class LocationItem extends StatelessWidget {
  final bool isCurrent;
  final VoidCallback? onLongPress;
  final VoidCallback? onTap;
  final DraggingMode draggingMode;
  final WeatherModel data;
  final bool isFirst;
  final bool isLast;
  final bool isSelected;
  bool isSelectionMode;

  LocationItem({
    super.key,
    required this.isCurrent,
    this.onLongPress,
    this.onTap,
    this.isSelectionMode = false,
    required this.data,
    required this.draggingMode,
    required this.isFirst,
    required this.isLast,
    required this.isSelected,
  });

  Widget get dragHandle {
    return draggingMode == DraggingMode.iOS
        ? ReorderableListener(
      child: Container(
        padding: const EdgeInsets.only(right: 18.0, left: 18.0),
        child: Image.asset(
          Constants.doubleChevron,
          color: Colors.grey,
        ),
      ),
    )
        : Container();
  }

  Widget content(BuildContext context, ReorderableItemState state,
      {
    required bool isSelected,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Opacity(
        opacity: state == ReorderableItemState.placeholder ? 0.0 : 1.0,
        child: IntrinsicHeight(
          child: AppGenericShape(
            cornerRadius: 25,
            child: Container(
              height: 120,
              width: AppHelpers.screenWidth(context),
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: AppColors.item,
                borderRadius: BorderRadius.circular(25),
                border: Border.all(
                  width: 2,
                  color: state == ReorderableItemState.dragProxy ? Colors.blueAccent : Colors.transparent,
                ),
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
                  _buildSelectIcon(isSelected, data, context),
                  Expanded(
                    child: InkWell(
                      onLongPress: onLongPress,
                      onTap: onTap,
                      child: Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    if (isCurrent)
                                      const Icon(
                                        Icons.location_on_rounded,
                                        color: AppColors.white,
                                        size: 18,
                                      ),
                                    if (isCurrent) 6.horizontalSpace,
                                    Expanded(
                                      child: Text(
                                        "${data.key}",
                                        style: AppStyles.bodyRegularL,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ],
                                ),
                                Text(
                                  data.location.country,
                                  style: AppStyles.bodyRegularM.copyWith(color: AppColors.secondaryText),
                                ),
                                Text(
                                  "Tue, December 17 5:14 PM",
                                  maxLines: 1,
                                  style: AppStyles.bodyRegularM.copyWith(color: AppColors.secondaryText),
                                ),
                              ],
                            ),
                          ),

                          if (draggingMode == DraggingMode.android) Expanded(
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
                                      "${data.current.tempC}°",
                                      style: AppStyles.bodyRegularXL.copyWith(fontSize: 32),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
                              ),
                              Text(
                                "${data.forecast.forecastday[0].day.maxTempC}°/${data.forecast.forecastday[0].day.minTempC}°",
                                style: AppStyles.bodyRegularM.copyWith(color: AppColors.secondaryText),
                              ),
                            ],
                          ),
                        )
                        ],
                      ),
                    ),
                  ),

                  if (draggingMode == DraggingMode.iOS)
                    dragHandle,
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ReorderableItem(
      key: data.key!,
      childBuilder: (BuildContext context, ReorderableItemState state) => content(context, state, isSelected: isSelected),
    );
  }


  Widget _buildSelectIcon(bool isSelected, WeatherModel data, BuildContext context) {
    if (isSelected || isSelectionMode) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            isSelected ? CupertinoIcons.checkmark_circle_fill : CupertinoIcons.circle,
            color: isSelected ? Colors.blueAccent : Colors.grey,
          ),

          const SizedBox(width: 24,)
        ],
      );
    }
    else {
      return Container();
    }
  }

}

