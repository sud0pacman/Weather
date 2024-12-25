import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:intl/intl.dart';

import '../app_preferences/app_preference.dart';

T inject<T extends Object>() => GetIt.I.get<T>();

Future<T> injectAsync<T extends Object>() async => GetIt.I.getAsync<T>();

extension ContextExtensions on BuildContext {
  Size get screenSize => MediaQuery.of(this).size;

  bool get isDarkThemeMode {
    final appTheme = inject<AppPreferences>().theme;
    return appTheme == ThemeMode.dark;
  }
}

extension AssetExtension on String {
  String get pngIcon => 'assets/images/$this.png';

  String get svgIcon => 'assets/icons/$this.svg';
}

extension IntAssetExtension on int {
  String getCustomIcon() {
    switch (this) {
      case 1000: // Clear sky
        return "assets/images/ic_sunny.png";
      case 1003: // Partly cloudy
        return "assets/images/ic_partly_cloudy.png";
      case 1006: // Cloudy
      case 1009: // Overcast
        return "assets/images/ic_cloudy.png";
      case 1030: // Mist
      case 1135: // Fog
        return "assets/images/ic_foggy.png";
      case 1063: // rain and sun
      case 1183: // Light rain
      case 1186: // Moderate rain
        return "assets/images/ic_sun_clouds_rain.png";
      case 1189: // Heavy rain
        return "assets/images/ic_rainy.png";
      case 1210: // Light snow
      case 1213: // Moderate snow
      case 1216: // Heavy snow
        return "assets/images/ic_snowy.png";
      case 1273: // Thunderstorm with rain
      case 1276: // Thunderstorm
        return "assets/images/ic_thunder.png";
      default:
        return "assets/images/ic_sun_clouds_rain.png"; // Default icon
    }
  }
}

String convertDate2(String inputDate) {
  DateTime date = DateTime.parse(inputDate);
  DateFormat formatter = DateFormat('dd MMMM');
  String formattedDate = formatter.format(date);
  return formattedDate;
}

String convertDate3(String inputDate) {
  DateTime date = DateTime.parse(inputDate);
  DateFormat formatter = DateFormat('MMMM');
  String formattedDate = formatter.format(date);
  return formattedDate;
}
