import 'package:bloc/bloc.dart';
import 'package:weather_now/data/model/weather_model.dart';
import 'package:weather_now/data/source/local/weather_entity.dart';
import 'package:weather_now/utils/constants.dart';
import 'package:weather_now/utils/helpers/app_helpers.dart';

import '../../../utils/isar_helper/weather_hive_helper.dart';

part 'locations_event.dart';
part 'locations_state.dart';

class LocationsBloc extends Bloc<LocationsEvent, LocationsState> {
  LocationsBloc() : super(LocationsState()) {
    on<LocationInitialEvent>((event, emit) async {
      emit(state.copyWith(isLoading: true));

      var savedLocation = await _getWeatherFromLocal();
      var currentWeatherIndex = await WeatherHiveHelper.getCurrentWeatherIndex();

      savedLocation.forEach((key, value) {
        Constants.logger.wtf("$key => ${value.location.name}");
      });

      emit(state.copyWith(savedLocations: savedLocation, currentLocationId: currentWeatherIndex));
    });

    on<DeleteLocationEvent>((event, emit) async {
      emit(state.copyWith(isLoading: true));

      if (event.weatherModelIndex == state.currentLocationId) {
        await WeatherHiveHelper.saveCurrentWeatherIndex(-1);
        emit(state.copyWith(currentLocationId: -1));
      }

      await WeatherHiveHelper.deleteWeatherEntity(event.weatherModelIndex);
      var savedLocation = await _getWeatherFromLocal();
      emit(state.copyWith(savedLocations: savedLocation));
    });
  }

  Future<Map<int, WeatherModel>> _getWeatherFromLocal() async {
    List<WeatherEntity> favouriteEntityList = WeatherHiveHelper.getAllWeatherEntities();

    Map<int, WeatherModel> weatherMap = {};

    for (int i = 0; i < favouriteEntityList.length; i++) {
      weatherMap[i] = AppHelpers.getWeatherModelByEntity(favouriteEntityList[i], keyValue: "$i");
    }

    return weatherMap;
  }
}
