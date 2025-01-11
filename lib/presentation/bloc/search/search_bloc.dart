import 'package:bloc/bloc.dart';
import 'package:get/get.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:weather_now/data/model/favourite_model.dart';
import 'package:weather_now/data/model/searched_weather_model.dart';
import 'package:weather_now/data/source/local/weather_entity.dart';

import '../../../data/data_source/service/api_call_status.dart';
import '../../../data/data_source/service/api_exceptions.dart';
import '../../../data/data_source/service/base_client.dart';
import '../../../data/model/weather_model.dart';
import '../../../utils/constants.dart';
import '../../../utils/helpers/app_helpers.dart';
import '../../../utils/isar_helper/weather_hive_helper.dart';
import '../../../utils/routes/app_routes.dart';
import '../../../utils/translations/localization_service.dart';

part 'search_event.dart';
part 'search_state.dart';

class SearchBloc extends Bloc<SearchEvent, SearchState> {
  final InternetConnectionChecker networkChecker = InternetConnectionChecker();

  var currentLanguage = LocalizationService.getCurrentLocal().languageCode;

  SearchBloc() : super(SearchState(isLoading: false, weathers: [])) {
    on<SearchingEvent>((event, emit) async {
      final bool hasConnection = await networkChecker.hasConnection;

      if (hasConnection == false) {
        emit(state.copyWith(status: ApiCallStatus.cache, errorToastMessage: "Weak Network"));
        return;
      }

      await BaseClient.safeApiCall(
        Constants.searchWeatherApiUrl,
        RequestType.get,
        queryParameters: {
          Constants.key: Constants.apiKey,
          Constants.q: event.searchQuery
        },
        onSuccess: (response) {
          List<SearchedWeatherModel> searchedWeatherModelList =
              (response.data as List)
                  .map((e) => SearchedWeatherModel.fromJson(e))
                  .toList();

          if (searchedWeatherModelList.isEmpty) {
            emit(state.copyWith(isEmptyFounded: true));
            return;
          }

          Constants.logger
              .t('Find after search: ${searchedWeatherModelList[0].name}');

          emit(state.copyWith(
              weathers: searchedWeatherModelList
                  .map((e) => e.toFavouriteModel())
                  .toList()));
        },
        onError: (ApiException error) async {
          Constants.logger.e(BaseClient.handleApiError(error));

          emit(state.copyWith(
              errorToastMessage: BaseClient.handleApiError(error)));
        },
      );
    });

    on<InitEvent>((event, emit) async {
      emit(state.copyWith(weathers: await _getFavouritesFromLocal(), currentWeatherIndex: await WeatherHiveHelper.getCurrentWeatherIndex()));
    });

    on<AddFavouriteEvent>((event, emit) async {

      if (event.favouriteModel.isSaved) {
        Get.offNamed(AppRoutes.home, arguments: {
          'location': "${event.favouriteModel.lat},${event.favouriteModel.lon}"
        });

        return;
      }

      emit(state.copyWith(isLoading: true));

      final bool hasConnection = await networkChecker.hasConnection;

      if (hasConnection == false) {
        emit(state.copyWith(status: ApiCallStatus.cache, errorToastMessage: "Weak Network"));
        return;
      }

      if (WeatherHiveHelper.getByLocation(region: event.favouriteModel.region, name:  event.favouriteModel.name, country: event.favouriteModel.country) != null) {
        Constants.logger.i("adding data is founded");
        emit(state.copyWith());
        return;
      }

      await BaseClient.safeApiCall(
        Constants.forecastWeatherApiUrl,
        RequestType.get,
        queryParameters: {
          Constants.key: Constants.apiKey,
          Constants.q: "${event.favouriteModel.lat},${event.favouriteModel.lon}",
          Constants.days: 7,
          Constants.lang: currentLanguage,
        },
        onSuccess: (response) async {
          WeatherModel weatherModel = WeatherModel.fromJson(response.data);

          await WeatherHiveHelper
              .addWeatherEntity(
              AppHelpers.getWeatherEntityByModel(weatherModel)
          );
        },
      );

      Get.offNamed(AppRoutes.home, arguments: {
        'location': "${event.favouriteModel.lat},${event.favouriteModel.lon}"
      });

      emit(state.copyWith(weathers: await _getFavouritesFromLocal()));
    });

    on<DeleteFavouriteEvent>((event, emit) async {
      emit(state.copyWith(isLoading: true));

      final bool hasConnection = await networkChecker.hasConnection;

      if (hasConnection == false) {
        emit(state.copyWith(status: ApiCallStatus.cache, errorToastMessage: "Weak Network"));
        return;
      }

      await WeatherHiveHelper.deleteWeatherEntity(event.index);

      emit(state.copyWith(weathers: await _getFavouritesFromLocal()));
    });
  }

  Future<List<FavouriteModel>> _getFavouritesFromLocal() async {
    List<WeatherEntity> favouriteEntityList = WeatherHiveHelper.getAllWeatherEntities();
    List<FavouriteModel> favouriteModelList = favouriteEntityList.map((e) => AppHelpers.getFavouriteModelByWeatherEntity(e)).toList();

    return favouriteModelList;
  }
}
