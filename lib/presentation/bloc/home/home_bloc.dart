import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:location/location.dart';
import 'package:weather_now/data/data_source/service/api_call_status.dart';
import 'package:weather_now/data/model/searched_weather_model.dart';
import 'package:weather_now/data/model/weather_model.dart';
import 'package:weather_now/data/source/local/favourite_entity.dart';
import 'package:weather_now/utils/constants.dart';
import 'package:weather_now/utils/helpers/app_helpers.dart';
import 'package:weather_now/utils/isar_helper/hive_helper.dart';
import 'package:weather_now/utils/isar_helper/weather_hive_helper.dart';

import '../../../data/data_source/service/api_exceptions.dart';
import '../../../data/data_source/service/base_client.dart';
import '../../../data/data_source/service/location_service.dart';
import '../../../data/model/favourite_model.dart';
import '../../../data/source/local/weather_entity.dart';
import '../../../utils/translations/localization_service.dart';

part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  var currentLanguage = LocalizationService.getCurrentLocal().languageCode;
  final hiveHelper = HiveHelper();
  final InternetConnectionChecker networkChecker = InternetConnectionChecker();
  Future<LocationData?>? _cachedLocationFuture;

  HomeBloc()
      : super(HomeState(homeDrawerState: HomeDrawerState(weathers: []))) {
    on<HomeInitEvent>((event, emit) async {
      emit(state.copyWith(isLoading: true));
      final bool hasConnection = await networkChecker.hasConnection;

      if (state.currentWeather != null && event.locationData == "${state.currentWeather?.location.lat.toString()},${state.currentWeather?.location.lat.toString()}") {
        emit(state.copyWith());
        return;
      }

      bool isCurrentLocation = false;

      if (hasConnection == false) {
        emit(state.copyWith(status: ApiCallStatus.cache, errorToastMessage: "Weak Network"));
        var cachedCurrentWeather = await WeatherHiveHelper.getCurrentWeather();

        if (cachedCurrentWeather != null) {
          emit(state.copyWith(currentWeather: AppHelpers.getWeatherModelByEntity(cachedCurrentWeather)));
        }
        else {
          var favoriteEntityList = WeatherHiveHelper.getAllWeatherEntities();

          if (favoriteEntityList.isNotEmpty) {
            emit(state.copyWith(currentWeather: AppHelpers.getWeatherModelByEntity(favoriteEntityList[0])));
          }
          else {
            emit(state.copyWith(currentWeather: null));
          }
        }

        return;
      }

      String location = '';

      if (event.locationData != null) {
        location = event.locationData!;
      } else {
        var locationData = await getUserLocation();

        if (locationData != null) {
          location = '${locationData.latitude},${locationData.longitude}';
          isCurrentLocation = true;
        }
      }

      if (location.isNotEmpty) {
        await BaseClient.safeApiCall(
          Constants.forecastWeatherApiUrl,
          RequestType.get,
          queryParameters: {
            Constants.key: Constants.apiKey,
            Constants.q: location,
            Constants.days: 7,
            Constants.lang: currentLanguage,
          },
          onSuccess: (response) async {
            WeatherModel weatherModel = WeatherModel.fromJson(response.data);
            Constants.logger.t("HomeInitEvent ${WeatherModel.fromJson(response.data)}");

            int savedCurrentWeatherIndex = await WeatherHiveHelper.getCurrentWeatherIndex();
            if (isCurrentLocation && savedCurrentWeatherIndex == -1) {
              int currentWeatherIndex = await WeatherHiveHelper
                  .addWeatherEntity(
                  AppHelpers.getWeatherEntityByModel(weatherModel)
              );

              await WeatherHiveHelper.saveCurrentWeatherIndex(
                  currentWeatherIndex);
            }

            emit(state.copyWith(
                currentWeather: weatherModel, homeDrawerState: state.homeDrawerState.copyWith(weathers: await _getWeatherFromLocal())));
          },
          onError: (ApiException error) async {
            Constants.logger.e(BaseClient.handleApiError(error));

            emit(state.copyWith(
                errorToastMessage: BaseClient.handleApiError(error)));
          },
        );
      }
    });

    on<HomeGetSavedLocations>((event, emit) async {
      emit(state.copyWith(
          homeDrawerState: state.homeDrawerState.copyWith(isLoading: true), isLoading: state.currentWeather == null ? true : false));

      List<WeatherModel> savedWeatherModelList = [];
      savedWeatherModelList.addAll(await _getWeatherFromLocal());

      var hasNetwork = await networkChecker.hasConnection;

      if (hasNetwork == true) {
        var currentWeatherIndex = await WeatherHiveHelper.getCurrentWeatherIndex();
        for (int i = 0; i < savedWeatherModelList.length; ++i) {
          if (currentWeatherIndex == i) continue;

          await BaseClient.safeApiCall(
            Constants.forecastWeatherApiUrl,
            RequestType.get,
            queryParameters: {
              Constants.key: Constants.apiKey,
              Constants.q: "${savedWeatherModelList[i].location.lat},${savedWeatherModelList[i].location.lon}",
              Constants.days: 7,
              Constants.lang: currentLanguage,
            },
            onSuccess: (response) async {
              var weatherData = WeatherModel.fromJson(response.data);

              savedWeatherModelList[i] = weatherData;

              Constants.logger.t("HomeGetSavedLocations save $i => ${savedWeatherModelList[i].location.name}");
            },
          );

        }

        for (int i = 0; i < savedWeatherModelList.length; ++i) {
          await _saveWeatherModel(savedWeatherModelList[i], i);
        }
      }


      emit(state.copyWith(homeDrawerState:
            state.homeDrawerState.copyWith(weathers: savedWeatherModelList), isLoading: state.currentWeather == null ? true : false));
    });
  }

  /// get the user location
  Future<LocationData?> getUserLocation() async {
    // Agar caching mavjud bo'lsa, shu natijani qaytaradi
    if (_cachedLocationFuture != null) {
      return _cachedLocationFuture;
    }

    // Aks holda, lokatsiyani olishga kirishadi
    _cachedLocationFuture = LocationService().getUserLocation();

    try {
      return await _cachedLocationFuture;
    } catch (e) {
      // Hatolik yuz berganda cachingni tozalash
      _cachedLocationFuture = null;
      rethrow;
    }
  }

  /// get selected location
  LocationData? getSelectedLocation(SearchedWeatherModel? searchedWeather) {
    if (searchedWeather == null) {
      return null;
    }

    return LocationData.fromMap({});
  }

  Future<void> _saveWeatherModel(WeatherModel weatherModel, int initIndex) async {
      await WeatherHiveHelper.updateWeatherEntity(AppHelpers.getWeatherEntityByModel(weatherModel), initIndex);
  }

  Future<List<WeatherModel>> _getWeatherFromLocal() async {
    List<WeatherEntity> favouriteEntityList = WeatherHiveHelper.getAllWeatherEntities();
    List<WeatherModel> favouriteModelList = favouriteEntityList.map((e) => AppHelpers.getWeatherModelByEntity(e)).toList();

    return favouriteModelList;
  }
}
