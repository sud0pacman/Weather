import 'package:get_it/get_it.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:weather_now/data/source/local/condition_entity.dart';
import 'package:weather_now/data/source/local/day_entity.dart';
import 'package:weather_now/data/source/local/forecast_day_entity.dart';
import 'package:weather_now/data/source/local/hour_entity.dart';
import 'package:weather_now/data/source/local/weather_entity.dart';
import 'package:weather_now/presentation/bloc/home/home_bloc.dart';
import 'package:weather_now/utils/app/preferences_manager.dart';

import '../../data/source/local/current_entity.dart';
import '../../data/source/local/favourite_entity.dart';
import '../../data/source/local/forecast_entity.dart';
import '../../data/source/local/location_entity.dart';
import '../app_preferences/app_preference.dart';
import '../app_preferences/shared_pref.dart';

final serviceLocator = GetIt.instance;

Future<void> initDependencies() async {
  await MySharedPref.init();
  await Hive.initFlutter();

  // Adapter registering
  if (!Hive.isAdapterRegistered(FavouriteEntityAdapter().typeId)) {
    Hive.registerAdapter(FavouriteEntityAdapter());
  }

  if (!Hive.isAdapterRegistered(WeatherEntityAdapter().typeId)) {
    Hive.registerAdapter(LocationEntityAdapter());
    Hive.registerAdapter(CurrentEntityAdapter());
    Hive.registerAdapter(ForecastEntityAdapter());
    Hive.registerAdapter(WeatherEntityAdapter());
    Hive.registerAdapter(DayEntityAdapter());
    Hive.registerAdapter(HourEntityAdapter());
    Hive.registerAdapter(ConditionEntityAdapter());
    Hive.registerAdapter(ForecastDayEntityAdapter());
  }

  await PreferencesManager.initBoxes();


  serviceLocator.registerSingleton<AppPreferences>(
      PreferencesManager.providePreferencesStorage());

  serviceLocator.registerSingleton<HomeBloc>(HomeBloc());
}


final sharedPref = serviceLocator.get<MySharedPref>();
