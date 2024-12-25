import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:weather_now/data/model/current_model.dart';
import 'package:weather_now/data/model/favourite_model.dart';
import 'package:weather_now/data/model/location_model.dart';
import 'package:weather_now/data/model/weather_model.dart';
// ignore: library_prefixes
import 'package:weather_now/data/model/condition_model.dart' as ConditionModel;
import 'package:weather_now/data/source/local/condition_entity.dart';
import 'package:weather_now/data/source/local/current_entity.dart';
import 'package:weather_now/data/source/local/day_entity.dart';
import 'package:weather_now/data/source/local/forecast_day_entity.dart';
import 'package:weather_now/data/source/local/forecast_entity.dart';
import 'package:weather_now/data/source/local/hour_entity.dart';
import 'package:weather_now/data/source/local/location_entity.dart';
import 'package:weather_now/data/source/local/weather_entity.dart';

import '../theme/app_styles.dart';

class AppHelpers {
  static double screenWidth(BuildContext ctx) => MediaQuery.of(ctx).size.width;
  static double screenHight(BuildContext ctx) => MediaQuery.of(ctx).size.height;

  static SnackbarController showSnackbar({
    required String title,
    required String message,
    bool isError = true,
  }) {
    return Get.snackbar(
      title,
      message,
      snackPosition: SnackPosition.BOTTOM,
      isDismissible: true,
      backgroundColor: isError ? Colors.red[400] : Colors.green,
      colorText: Colors.white,
    );
  }

  static String getHumanReadableDate(String dateString) {
    DateTime inputDate = DateTime.parse(dateString);
    DateTime now = DateTime.now();
    DateTime today = DateTime(now.year, now.month, now.day);
    DateTime yesterday = today.subtract(const Duration(days: 1));

    if (inputDate == today) {
      return 'Today';
    } else if (inputDate == yesterday) {
      return 'Yesterday';
    } else {
      return DateFormat('EEEE').format(inputDate); //Returns day of the week
    }
  }

  static String getUVIndexDescription(double uvIndex) {
    if (uvIndex <= 2.0) {
      return 'Low';
    } else if (uvIndex <= 5.0) {
      return 'Moderate';
    } else if (uvIndex <= 7.0) {
      return 'High';
    } else if (uvIndex <= 10.0) {
      return 'Very High';
    } else {
      return 'Extreme';
    }
  }

  /// Checks internet connection, Returns `true` if online, `false` if offline
  static Future<bool> checkInternet() async {
    try {
      var result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty) {
        return true;
      } else {
        return false;
      }
    } on SocketException catch (_) {
      return false;
    }
  }

  /// The default dialog template for the app
  static Future showDialog({
    required String title,
    required String message,
    required String cancelButtonText,
    required String confirmButtonText,
    required void Function()? onPressCancel,
    required void Function()? onPressConfirm,
  }) async {
    return await Get.dialog(
      AlertDialog(
        title: Text(title),
        titleTextStyle: AppStyles.bodyMediumXL,
        content: Text(message),
        contentTextStyle:
            AppStyles.bodyRegularL.copyWith(color: Colors.grey[400]),
        actions: [
          MaterialButton(
            onPressed: onPressCancel,
            child: Text(cancelButtonText),
          ),
          MaterialButton(
            onPressed: onPressConfirm,
            color: Colors.blue.shade700,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(confirmButtonText),
          )
        ],
      ),
      barrierDismissible: false,
    );
  }

  /// Dialog for offline case
  static Future showOffLineDialog(
      {required void Function()? cancelFunction,
      required void Function()? confirmFunction}) {
    return AppHelpers.showDialog(
      title: "No Internet connection",
      message: "Make sure you have stable internet connection and try again.",
      cancelButtonText: "Discard",
      confirmButtonText: "Try again",
      onPressCancel: cancelFunction,
      onPressConfirm: confirmFunction,
    );
  }

  /// \nDialog for Not-enabled location service case
  static Future notEnabledDialog(
      {required void Function()? cancelFunction,
      required void Function()? confirmFunction}) {
    return AppHelpers.showDialog(
      title: "Location services not enabled",
      message:
          "Make sure to enable location service on your phone and try again.",
      cancelButtonText: "Discard",
      confirmButtonText: "Try again",
      onPressCancel: cancelFunction,
      onPressConfirm: confirmFunction,
    );
  }

  /// Dialog for *Denied* location service case
  static Future deniedDialog(
      {required void Function()? cancelFunction,
      required void Function()? confirmFunction}) {
    return AppHelpers.showDialog(
      title: "Location services denied",
      message:
          "Make sure to allow location access for this app from app settings.",
      cancelButtonText: "Discard",
      confirmButtonText: "Allow",
      onPressCancel: cancelFunction,
      onPressConfirm: confirmFunction,
    );
  }

  /// Toast message template
  static Future<bool?> showToast(String message) {
    return Fluttertoast.showToast(
      msg: message,
      backgroundColor: Colors.black87,
    );
  }

  static String getWeekdayByDate(String dateString) {
    // Stringni DateTime ob'ektiga aylantirish
    DateTime date = DateFormat("yyyy-MM-dd").parse(dateString);

    // Kun nomini olish
    String dayOfWeek = DateFormat('EEEE').format(date); // Monday, Tuesday kabi

    return dayOfWeek;
  }

  static bool isSameHour(String dateTimeString) {
    // Sana va vaqtni pars qilish
    DateTime dateTime = DateFormat("yyyy-MM-dd HH:mm").parse(dateTimeString);

    // Hozirgi vaqtni olish
    DateTime now = DateTime.now();

    // Soatlarni solishtirish
    return dateTime.hour == now.hour;
  }

  static WeatherEntity getWeatherEntityByModel(WeatherModel weatherModel) {
    return WeatherEntity(
      location: _getLocationEntityByModel(weatherModel.location),
      current: _getCurrentEntityByModel(weatherModel.current),
      forecast: _getForecastEntityByModel(weatherModel.forecast),
    );
  }

  static LocationEntity _getLocationEntityByModel(Location location) {
    return LocationEntity(
      name: location.name,
      region: location.region,
      lat: location.lat,
      lon: location.lon,
      country: location.country,
      tzId: location.tzId,
      localtimeEpoch: location.localtimeEpoch,
      localtime: location.localtime,
    );
  }

  static CurrentEntity _getCurrentEntityByModel(Current current) {
    return CurrentEntity(
      lastUpdatedEpoch: current.lastUpdatedEpoch,
      lastUpdated: current.lastUpdated,
      tempC: current.tempC,
      tempF: current.tempF,
      isDay: current.isDay,
      condition: _getConditionEntityByModel(current.condition),
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

  static ConditionEntity _getConditionEntityByModel(
      ConditionModel.Condition condition) {
    return ConditionEntity(
      text: condition.text,
      icon: condition.icon,
      code: condition.code,
    );
  }

  static ForecastEntity _getForecastEntityByModel(Forecast forecastModel) {
    return ForecastEntity(
      forecastDays: forecastModel.forecastday.map((element) => _getForecastDayEntityByModel(element)).toList(),
    );
  }

  static ForecastDayEntity _getForecastDayEntityByModel(ForecastDay forecastDay) {
    return ForecastDayEntity(
      date: forecastDay.date,
      day: _getDayEntityByModel(forecastDay.day),
      hours: forecastDay.hour.map((element) => _getHourEntityByModel(element)).toList(),
    );
  }

  static DayEntity _getDayEntityByModel(Day day) {
    return DayEntity(
      tempC: day.tempC,
      tempF: day.tempF,
      condition: _getConditionEntityByModel(day.condition),
    );
  }

  static HourEntity _getHourEntityByModel(Hour hour) {
    return HourEntity(
      time: hour.time,
      tempC: hour.tempC,
      tempF: hour.tempF,
      condition: _getConditionEntityByModel(hour.condition),
      windMph: hour.windMph,
      timeEpoch: hour.timeEpoch,
      isDay: hour.isDay,
      windKph: hour.windKph,
    );
  }

  static WeatherModel getWeatherModelByEntity(WeatherEntity entity) {
    return WeatherModel(
      location: _getLocationByEntity(entity.location),
      current: getCurrentByEntity(entity.current),
      forecast: _getForecastByEntity(entity.forecast),
    );
  }

  static Forecast _getForecastByEntity(ForecastEntity entity) {
    return Forecast(
      forecastday: entity.forecastDays.map((e) => _getForecastDayByEntity(e)).toList(),
    );
  }

  static ForecastDay _getForecastDayByEntity(ForecastDayEntity entity) {
    return ForecastDay(
      date: entity.date,
      day: _getDayByEntity(entity.day),
      hour: entity.hours.map((e) => _getHourByEntity(e)).toList(),
    );
  }

  static Day _getDayByEntity(DayEntity entity) {
    return Day(
      tempC: entity.tempC,
      tempF: entity.tempF,
      condition: _getConditionByEntity(entity.condition),
    );
  }

  static Hour _getHourByEntity(HourEntity entity) {
    return Hour(
      time: entity.time,
      tempC: entity.tempC,
      tempF: entity.tempF,
      condition: _getConditionByEntity(entity.condition),
      windMph: entity.windMph,
      timeEpoch: entity.timeEpoch,
      isDay: entity.isDay,
      windKph: entity.windKph,
    );
  }

  static Current getCurrentByEntity(CurrentEntity entity) {
    return Current(
      lastUpdatedEpoch: entity.lastUpdatedEpoch,
      lastUpdated: entity.lastUpdated,
      tempC: entity.tempC,
      tempF: entity.tempF,
      isDay: entity.isDay,
      condition: _getConditionByEntity(entity.condition),
      windMph: entity.windMph,
      windKph: entity.windKph,
      windDegree: entity.windDegree,
      windDir: entity.windDir,
      pressureMb: entity.pressureMb,
      pressureIn: entity.pressureIn,
      precipMm: entity.precipMm,
      precipIn: entity.precipIn,
      humidity: entity.humidity,
      cloud: entity.cloud,
      feelslikeC: entity.feelslikeC,
      feelslikeF: entity.feelslikeF,
      visKm: entity.visKm,
      visMiles: entity.visMiles,
      uv: entity.uv,
      gustMph: entity.gustMph,
      gustKph: entity.gustKph,
    );
  }

  static ConditionModel.Condition _getConditionByEntity(ConditionEntity entity) {
    return ConditionModel.Condition(
      text: entity.text,
      icon: entity.icon,
      code: entity.code.toInt(),
    );
  }

  static Location _getLocationByEntity(LocationEntity entity) {
    return Location(
      name: entity.name,
      region: entity.region,
      country: entity.country,
      lat: entity.lat,
      lon: entity.lon,
      tzId: entity.tzId,
      localtimeEpoch: entity.localtimeEpoch,
      localtime: entity.localtime
    );
  }

  static FavouriteModel getFavouriteModelByWeatherEntity(WeatherEntity entity) {
    return FavouriteModel(
        name: entity.location.name,
        region: entity.location.region,
        country: entity.location.country,
        lat: entity.location.lat,
        lon: entity.location.lon,
        iconCode: entity.current.condition.code.toInt(),
        tempC: entity.current.tempC,
        tempF: entity.current.tempF,
      isSaved: true
    );
  }
}
