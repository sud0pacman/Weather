import 'dart:math';

import 'package:hive/hive.dart';
import 'package:weather_now/data/source/local/favourite_entity.dart';
import 'package:weather_now/data/source/local/weather_entity.dart';
import 'package:weather_now/utils/constants.dart';

class WeatherHiveHelper {
  static Box<WeatherEntity> weatherBox = Hive.box<WeatherEntity>(Constants.weatherBox);
  static Box<FavouriteEntity> favouriteBox = Hive.box<FavouriteEntity>(Constants.favouriteBox);

  static Future<int> addWeatherEntity(WeatherEntity weatherEntity) async {
    return await weatherBox.add(weatherEntity);
  }

  static WeatherEntity? getWeatherEntityById(int id) {
    return weatherBox.get(id);
  }

  static Future<void> updateWeatherEntity(WeatherEntity weatherEntity, int index) async {
    await weatherBox.put(index, weatherEntity);
  }

  static Future<void> deleteWeatherEntity(int id) async {
    if (weatherBox.containsKey(id)) {
      await weatherBox.delete(id);
      print('WeatherEntity with ID $id has been deleted');
    } else {
      print('WeatherEntity with ID $id not found');
    }
  }

  static List<WeatherEntity> getAllWeatherEntities() {
    return weatherBox.values.toList();
  }

  static Future<void> deleteAllWeatherEntities() async {
    await weatherBox.clear();
    print('All WeatherEntity objects have been deleted');
  }


  static Future<WeatherEntity?> currentWeatherEntity() async {
    final preferencesBox = await Hive.openBox(Constants.preferencesBox);
    int currentWeatherId = await preferencesBox.get(Constants.currentWeatherId);
    final weatherEntity = weatherBox.get(currentWeatherId);
    return weatherEntity;
  }

  static Future<void> updateFavouriteEntity(FavouriteEntity favouriteEntity, int index) async {
    await favouriteBox.put(index, favouriteEntity);
  }

  static WeatherEntity? getByLocation({required String country, required String region, required String name}) {
    // Search for the entity with the given latitude and longitude
    return weatherBox.values.cast<WeatherEntity?>().firstWhere(
          (favourite) => favourite?.location.region == region && favourite?.location.name == name,
      orElse: () => null, // Return null if no match is found
    );
  }


  static Future<List<double>> getCurrentLocationLatLong() async {
    final preferencesBox = await Hive.openBox(Constants.preferencesBox);
    double? lat = await preferencesBox.get(Constants.currentLocationLat);
    double? lon = await preferencesBox.get(Constants.currentLocationLong);
    if(lat == null || lon == null) return [];
    return [lat, lon];
  }

  static Future<void> saveCurrentWeatherLatLong(double lat, double lon) async {
    final preferencesBox = await Hive.openBox(Constants.preferencesBox);
    await preferencesBox.put(Constants.currentLocationLat, lat);
    await preferencesBox.put(Constants.currentLocationLong, lon);
  }

  static Future<void> saveCurrentWeatherIndex(int index) async {
    final preferencesBox = Hive.box(Constants.preferencesBox);
    await preferencesBox.put(Constants.currentWeatherId, index);
  }

  static Future<int> getCurrentWeatherIndex() async {
    final preferencesBox = Hive.box(Constants.preferencesBox);
    return await preferencesBox.get(Constants.currentWeatherId, defaultValue: -1);
  }

  static Future<WeatherEntity?> getCurrentWeather() async {
    final currentWeatherIndex = await getCurrentWeatherIndex();
    return weatherBox.get(currentWeatherIndex);
  }
}
