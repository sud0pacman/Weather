import 'package:bloc/bloc.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:location/location.dart';
import 'package:weather_now/data/data_source/service/api_call_status.dart';
import 'package:weather_now/data/model/weather_model.dart';
import 'package:weather_now/utils/constants.dart';
import 'package:weather_now/utils/helpers/app_helpers.dart';
import 'package:weather_now/utils/isar_helper/weather_hive_helper.dart';

import '../../../data/data_source/service/api_exceptions.dart';
import '../../../data/data_source/service/base_client.dart';
import '../../../data/data_source/service/location_service.dart';
import '../../../data/source/local/weather_entity.dart';
import '../../../utils/translations/localization_service.dart';

part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  var currentLanguage = LocalizationService.getCurrentLocal().languageCode;
  final InternetConnectionChecker networkChecker = InternetConnectionChecker();
  Future<LocationData?>? _cachedLocationFuture;

  HomeBloc()
      : super(HomeState(homeDrawerState: HomeDrawerState(weathers: {}))) {
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

      Constants.logger.t("$location  $isCurrentLocation");

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
            Constants.logger.t("HomeInitEvent ${weatherModel.toString()}");

            int savedCurrentWeatherIndex = await WeatherHiveHelper.getCurrentWeatherIndex();
            if (isCurrentLocation) {
              int reg = location.indexOf(",");
              weatherModel.location = weatherModel.location.copyWith(
                lat: double.tryParse(location.substring(0, reg)),
                lon: double.tryParse(location.substring(reg+1))
              );

              if (savedCurrentWeatherIndex != -1) {
                await WeatherHiveHelper.updateWeatherEntity(AppHelpers.getWeatherEntityByModel(weatherModel), savedCurrentWeatherIndex);
              }
              else {
                int currentWeatherIndex = await WeatherHiveHelper
                    .addWeatherEntity(
                    AppHelpers.getWeatherEntityByModel(weatherModel)
                );

                await WeatherHiveHelper.saveCurrentWeatherIndex(
                    currentWeatherIndex);
              }
            }

            emit(state.copyWith(
              currentWeather: weatherModel,
              homeDrawerState: state.homeDrawerState.copyWith(
                weathers: await _getWeatherFromLocal(),
                currentWeather: await WeatherHiveHelper.getCurrentWeatherIndex())
              )
            );
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

      Map<int, WeatherModel> savedWeatherModelList = {};
      savedWeatherModelList.addAll(await _getWeatherFromLocal());

      var hasNetwork = await networkChecker.hasConnection;

      if (hasNetwork == true) {
        for (int i = 0; i < savedWeatherModelList.length; ++i) {

          await BaseClient.safeApiCall(
            Constants.forecastWeatherApiUrl,
            RequestType.get,
            queryParameters: {
              Constants.key: Constants.apiKey,
              Constants.q: "${savedWeatherModelList[i]?.location.lat},${savedWeatherModelList[i]?.location.lon}",
              Constants.days: 7,
              Constants.lang: currentLanguage,
            },
            onSuccess: (response) async {
              var weatherData = WeatherModel.fromJson(response.data);

              savedWeatherModelList[i] = weatherData;
            },
          );

        }

        for (int i = 0; i < savedWeatherModelList.length; ++i) {
          await _saveWeatherModel(savedWeatherModelList[i]!, i);
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

  Future<void> _saveWeatherModel(WeatherModel weatherModel, int initIndex) async {
      await WeatherHiveHelper.updateWeatherEntity(AppHelpers.getWeatherEntityByModel(weatherModel), initIndex);
  }

  Future<Map<int, WeatherModel>> _getWeatherFromLocal() async {
    List<WeatherEntity> favouriteEntityList = WeatherHiveHelper.getAllWeatherEntities();

    Map<int, WeatherModel> weatherMap = {};

    for (int i = 0; i < favouriteEntityList.length; ++i) {
      weatherMap[i] = AppHelpers.getWeatherModelByEntity(favouriteEntityList[i]);
    }

    return weatherMap;
  }
}
