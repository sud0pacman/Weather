import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:weather_now/data/model/weather_model.dart';
import 'package:weather_now/presentation/bloc/home/home_bloc.dart';
import 'package:weather_now/utils/constants.dart';
import 'package:weather_now/utils/extensions/extensions.dart';

import '../../../../utils/helpers/app_helpers.dart';
import '../../../../utils/routes/app_routes.dart';
import '../../../../utils/theme/app_styles.dart';
import '../../../../utils/theme/colors.dart';
import 'drawer_location_widget.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({
    super.key,
    required this.state,
    required this.onSelectLocation
  });

  final HomeDrawerState state;
  final Function(String?) onSelectLocation;

  @override
  Widget build(BuildContext context) {
    late final Map<int, WeatherModel> tempWeathers;

    if (state.weathers.isNotEmpty) {
      tempWeathers = state.weathers;

      for (var tempWeather in tempWeathers.values) {
        Constants.logger.t("AppDrawer weather: ${tempWeather.location.name} => lat: ${tempWeather.location.lat}, lon: ${tempWeather.location.lon}");
      }
    }

    return Drawer(
      width: AppHelpers.screenWidth(context) / 1.2,
      child: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: AppColors.mainBackgroundLinear,
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter
          )
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
          child: state.isLoading == true || state.weathers.isEmpty
              ? Center(
                  child: Lottie.asset(Constants.loadingLottie),
                )
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Row(
                      children: [
                        const Spacer(),

                        IconButton(
                          iconSize: 24,
                          onPressed: () {
                            Get.back();
                            Get.toNamed(AppRoutes.search);
                          },
                          icon: const Icon(Icons.search),
                        ),

                        IconButton(
                          iconSize: 24,
                          onPressed: () {
                            // Get.back();
                            // onSelectLocation(null);
                          },
                          icon: const Icon(Icons.settings),
                        ),
                      ],
                    ),

                    Expanded(
                      child: ListView.builder(
                        itemCount: tempWeathers.length,
                        shrinkWrap: true,
                        itemBuilder: (context, index) => DrawerLocationWidget(
                          icon: index == state.currentWeather ? Icons.location_on : null,
                          locationName: tempWeathers[index]!.location.name,
                          imageUrl: tempWeathers[index]!.current.condition.code.getCustomIcon(),
                          temp: "${tempWeathers[index]!.current.tempC}°",
                          onTap: () {
                            onSelectLocation("${tempWeathers[index]!.location.lat},${tempWeathers[index]!.location.lon}");
                            Get.back();
                          },
                        ),
                      ),
                    ),

                    MaterialButton(
                      onPressed: () {
                        Get.back();
                        Get.toNamed(AppRoutes.locations);
                      },
                      padding: const EdgeInsets.symmetric(
                          horizontal: 50, vertical: 7),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      color: const Color(0xFF474646),
                      elevation: 0,
                      child: const Text(
                        "Manage locations",
                        style: AppStyles.bodyMediumL,
                      ),
                    ),
                    const SizedBox(height: 10),
                    customDivider(context),
                    const Spacer()
                  ],
                ),
        ),
      ),
    );
  }

  Row titleRow(
    BuildContext ctx,
    IconData icon,
    String title,
  ) {
    return Row(
      children: [
        Icon(
          icon,
          size: 25,
          color: Colors.grey,
        ),
        const SizedBox(width: 10),
        Text(title, style: AppStyles.bodyMediumL),
      ],
    );
  }

  Row customDivider(BuildContext ctx) {
    return Row(
      children: List.generate(
        AppHelpers.screenWidth(ctx) ~/ 4,
        (index) => Expanded(
          child: Container(
            width: 2,
            height: 2,
            decoration: BoxDecoration(
              color: index % 2 == 0 ? Colors.transparent : Colors.grey,
              borderRadius: BorderRadius.circular(30),
            ),
          ),
        ),
      ),
    );
  }

  Widget topRightSection() {
    return Positioned(
      top: -100,
      right: -100,
      child: Stack(
        children: [
          Container(
            width: 250,
            height: 250,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                begin: Alignment.centerLeft,
                end: Alignment.topLeft,
                colors: AppColors.subBackgroundLinear,
              ),
            ),
          ),
          Positioned.fill(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 50.0, sigmaY: 50.0),
              child: Container(
                color: Colors.transparent,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
