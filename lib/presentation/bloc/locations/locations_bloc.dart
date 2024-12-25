import 'package:bloc/bloc.dart';
import 'package:weather_now/data/source/local/weather_entity.dart';

import '../../../utils/isar_helper/weather_hive_helper.dart';

part 'locations_event.dart';
part 'locations_state.dart';

class LocationsBloc extends Bloc<LocationsEvent, LocationsState> {
  LocationsBloc() : super(LocationsState(savedLocation: [])) {
    on<LocationInitialEvent>((event, emit) async {
      emit(state.copyWith(isLoading: true));

      var savedLocation = await _getSavedLocationWithCurrentLocationIndex();

      emit(state.copyWith(savedLocation: savedLocation[0], currentLocationId: savedLocation[1]));
    });

    on<DeleteLocationEvent>((event, emit) async {
      emit(state.copyWith(isLoading: true));
      await WeatherHiveHelper.deleteWeatherEntity(event.weatherModelIndex);
      var savedLocation = await _getSavedLocationWithCurrentLocationIndex();
      emit(state.copyWith(savedLocation: savedLocation[0], currentLocationId: savedLocation[1]));
    });
  }

  Future<List<dynamic>> _getSavedLocationWithCurrentLocationIndex() async {
    final savedLocation = WeatherHiveHelper.getAllWeatherEntities();
    var currentLatLong = await WeatherHiveHelper.getCurrentLocationLatLong();
    var currentLocationIndex = -1;

    if (currentLatLong.isEmpty){
      return [savedLocation, -1];
    }

    for (int i = 0; i < savedLocation.length; i++) {
      if (savedLocation[i].location.lat == currentLatLong[0] &&
          savedLocation[i].location.lon == currentLatLong[1]) {
        currentLocationIndex = i;
      }
    }
    return [savedLocation, currentLocationIndex];
  }
}
