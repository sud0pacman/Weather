import 'package:hive/hive.dart';
import 'package:weather_now/data/source/local/weather_entity.dart';

import '../../data/source/local/favourite_entity.dart';
import '../app_preferences/app_preference.dart';
import '../constants.dart';

class PreferencesManager {
  static Future<void> initBoxes() async {
    await Hive.openBox("preferences");
    await Hive.openBox<FavouriteEntity>(Constants.favouriteBox);
    await Hive.openBox<WeatherEntity>(Constants.weatherBox);
  }

  static AppPreferences providePreferencesStorage() {
    final box = Hive.box("preferences");
    return AppPreferences(box: box);
  }
}
