import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:lottie/lottie.dart';
import 'package:weather_now/components/daily_forecast_item.dart';
import 'package:weather_now/components/weather_item.dart';
import 'package:weather_now/data/model/weather_model.dart';
import 'package:weather_now/presentation/screens/home/widgets/app_drawer.dart';
import 'package:weather_now/presentation/screens/home/widgets/home_shimmers.dart';
import 'package:weather_now/utils/app/app_initializer.dart';
import 'package:weather_now/utils/constants.dart';
import 'package:weather_now/utils/extensions/extensions.dart';
import 'package:weather_now/utils/helpers/app_helpers.dart';
import 'package:weather_now/utils/routes/app_routes.dart';
import 'package:weather_now/utils/theme/app_text_styles.dart';

import '../../../components/primary_floating_action_button.dart';
import '../../../data/data_source/service/api_call_status.dart';
import '../../../utils/theme/colors.dart';
import '../../bloc/home/home_bloc.dart';

// ignore: must_be_immutable
class HomeScreen extends StatefulWidget {

  String? location;
  HomeScreen({super.key}) {

    try {
      final args = Get.arguments;
      location = args['location'];
    }
    catch(e) {}

    Constants.logger.wtf("get from search: $location");
  }

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final HomeBloc _bloc = serviceLocator<HomeBloc>();
  late double width;
  late double height;

  bool _isVisible = true;
  final duration = const Duration(milliseconds: 300);
  final ScrollController _hideButtonController = ScrollController();
  final ScrollController _todayForecastListScrollController = ScrollController();

  final InternetConnectionChecker networkChecker = InternetConnectionChecker();


  void _scrollToNow(int index) {

    if (index != -1) {
      const itemWidth = 140.0;
      const separatorWidth = 16.0;
      final offset = index * (itemWidth + separatorWidth);

      _todayForecastListScrollController.animateTo(
        offset,
        duration: const Duration(seconds: 1),
        curve: Curves.easeInOut,
      );
    }
  }

  void _listenForConnectionChanges() {
    networkChecker.onStatusChange.listen((status) {
      if (status == InternetConnectionStatus.connected) {

      }
    });
  }



  @override
  void dispose() {
    super.dispose();

    networkChecker.onStatusChange.drain();
    _bloc.close();
  }


  @override
  void initState() {
    _bloc.add(HomeInitEvent(locationData: widget.location));
    _bloc.add(HomeGetSavedLocations());
    super.initState();

    _listenForConnectionChanges();

    _hideButtonController.addListener(() {
      if (_hideButtonController.position.userScrollDirection ==
          ScrollDirection.reverse) {
        if (_isVisible == true) {
          /* only set when the previous state is false
             * Less widget rebuilds
             */
          setState(() {
            _isVisible = false;
          });
        }
      } else {
        if (_hideButtonController.position.userScrollDirection ==
            ScrollDirection.forward) {
          if (_isVisible == false) {
            /* only set when the previous state is false
               * Less widget rebuilds
               */
            setState(() {
              _isVisible = true;
            });
          }
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    double statusBarHeight = MediaQuery.of(context).padding.top;
    double navigationBarHeight = MediaQuery.of(context).padding.bottom;

    return BlocProvider.value(
      value: _bloc,
      child: BlocConsumer<HomeBloc, HomeState>(
        listener: (context, state) {
          Constants.logger.d(state.toString());

          if (state.currentWeather != null && state.status != ApiCallStatus.cache) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              int index = state.currentWeather!.forecast.forecastday[0].hour.indexWhere(
                    (hour) => AppHelpers.isSameHour(hour.time),
              );
              if (index != -1) {
                Future.delayed(const Duration(milliseconds: 700), () {
                  _scrollToNow(index);
                });
              }
            });
          }
        },
        builder: (context, state) {
          return RefreshIndicator(
            onRefresh: () => onRefreshIndicator(),
            child: Scaffold(
              key: _scaffoldKey,
              drawer: AppDrawer(
                state: state.homeDrawerState,
                onSelectLocation: (String? location) {
                  _bloc.add(HomeInitEvent(locationData: location));
                },
              ),
              floatingActionButton: state.status == ApiCallStatus.cache ? null : PrimaryFloatingActionButton(
                duration: duration,
                isVisible: _isVisible,
                icon: Icons.search,
                onTap: () {
                 Get.toNamed(AppRoutes.search);
                },
              ),
              body:
                Container(
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      colors: AppColors.mainBackgroundLinear,
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter
                    )
                  ),
                  child: state.status == ApiCallStatus.cache ? Center(child: Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Lottie.asset(Constants.internetLottie),
                  ))
                  : Stack(
                    children: [
                      topRightSection(),

                      SizedBox(
                        height: AppHelpers.screenHight(context),
                        width: AppHelpers.screenWidth(context),
                        child: SingleChildScrollView(
                          controller: _hideButtonController,
                          padding: EdgeInsets.only(
                              top: statusBarHeight, bottom: navigationBarHeight),
                          child: Center(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                24.verticalSpace,

                                SizedBox(
                                  height: 56,
                                  width: AppHelpers.screenWidth(context),
                                  child: Stack(
                                    children: [
                                      Positioned(
                                        left: 0,
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(horizontal: 24),
                                          child: InkWell(
                                            splashColor: AppColors.transparent,
                                            hoverColor: AppColors.transparent,
                                            onTap: () {
                                              _scaffoldKey.currentState?.openDrawer();
                                            },
                                            child: Container(
                                              margin: const EdgeInsets.only(right: 16),
                                              decoration: const BoxDecoration(shape: BoxShape.circle),
                                              child: const Icon(Icons.menu),
                                            ),
                                          ),
                                        ),
                                      ),

                                      Center(
                                        child: Text(
                                          state.isLoading == true ? "Loading.." : state.currentWeather!.location.name,
                                          style: sfbold.copyWith(fontSize: 24),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),

                                Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 16),
                                  child: Text(state.isLoading == true ? '' : state.currentWeather!.current.lastUpdated,
                                    style: sfregular.copyWith(fontSize: 14, color: AppColors.secondaryText),
                                  ),
                                ),


                                SizedBox(
                                  height: 300,
                                  width: 290,
                                  child: state.isLoading == true
                                      ? HomeShimmers.mainIconShimmer()
                                      : Image.asset(
                                    state.currentWeather!.current.condition.code.getCustomIcon(),
                                    fit: BoxFit.contain,
                                  )
                                ),

                                if (state.isLoading != true)
                                  Text(
                                    state.currentWeather!.current.condition.text.toString(),
                                    style: sfmedium.copyWith(
                                      fontSize: 18,
                                      color: AppColors.secondaryText
                                    ),
                                  ),

                                16.verticalSpace,

                                Padding(
                                  padding: const EdgeInsets.all(16.0),
                                  child: Row(
                                    children: [
                                      Expanded(
                                          child: Column(
                                            children: [
                                              Text(
                                                "Temp",
                                                style: sfregular.copyWith(fontSize: 18),
                                              ),
                                              if (state.currentWeather != null) Text(
                                                '${state.currentWeather!.current.tempC}° C',
                                                style: sfbold.copyWith(fontSize: 20),
                                              ),
                                            ],
                                          )),
                                      Expanded(
                                          child: Column(
                                            children: [
                                              Text(
                                                "Wind",
                                                style: sfregular.copyWith(fontSize: 18),
                                              ),
                                              if (state.currentWeather != null) Text(
                                                '${state.currentWeather!.current.windKph}kmh',
                                                style: sfbold.copyWith(fontSize: 20),
                                              ),
                                            ],
                                          )),
                                      Expanded(
                                          child: Column(
                                            children: [
                                              Text(
                                                "Humidity",
                                                style: sfregular.copyWith(fontSize: 18),
                                              ),
                                              if (state.currentWeather != null) Text(
                                                 '${state.currentWeather!.current.humidity} %',
                                                  style: sfbold.copyWith(fontSize: 20),
                                              ),
                                            ],
                                          )
                                      ),
                                    ],
                                  ),
                                ),

                                24.verticalSpace,

                                sectionNameSection("Today"),

                                24.verticalSpace,

                                if (state.isLoading == true) HomeShimmers.hourlyForecastShimmer()
                                else todayForecastSection(state.currentWeather!.forecast.forecastday[0].hour),

                                24.verticalSpace,

                                sectionNameSection("Next Forecasts"),

                                if (state.isLoading == true) HomeShimmers.dailyForecastShimmer()
                                else dailyForecastSection(state.currentWeather!.forecast.forecastday),

                                24.verticalSpace
                              ],
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
            ),
          );
        },
      ),
    );
  }


  Widget dailyForecastSection(List<ForecastDay> forecastDayList) {
    return ListView.separated(
      shrinkWrap: true,
      itemCount: forecastDayList.length,
      physics: const NeverScrollableScrollPhysics(),
      separatorBuilder: (context, index) => 12.verticalSpace,
      itemBuilder: (context, index) => DailyForecastItem(day: forecastDayList[index]),
    );
  }


  Widget todayForecastSection(List<Hour> hourDetailList) {
    return SizedBox(
      height: 80,
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        scrollDirection: Axis.horizontal,
        itemCount: hourDetailList.length,
        controller: _todayForecastListScrollController,
        separatorBuilder: (context, index) => 16.horizontalSpace,
        itemBuilder: (context, index) {
          bool isNow = AppHelpers.isSameHour(hourDetailList[index].time);

          // Agar `isNow` true bo'lsa, u pozitsiyaga scroll bo'lishni boshlaydi
          if (isNow) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              _todayForecastListScrollController.animateTo(
                index * (140.0 + 16), // Taxminiy element kengligi
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
              );
            });
          }

          return WeatherItem(hour: hourDetailList[index], isNow: isNow);
        },
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

  Widget sectionNameSection(String name) {
    return Align(
      alignment: Alignment.topLeft,
      child: Padding(
        padding: const EdgeInsets.only(
          left: 24,
        ),
        // bottom: 16),
        child: Text(
          name,
          style: sfregular.copyWith(fontSize: 20),
        ),
      ),
    );
  }


  Future<void> onRefreshIndicator() async {
    _bloc.add(HomeInitEvent(locationData: widget.location));
  }
}
