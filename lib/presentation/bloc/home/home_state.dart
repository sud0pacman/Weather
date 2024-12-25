part of 'home_bloc.dart';


class HomeState {
  bool? isLoading;
  WeatherModel? currentWeather;
  ApiCallStatus? status;
  String? errorToastMessage;
  List<WeatherModel>? getWeatherArroundTheWorld;
  HomeDrawerState homeDrawerState;


  HomeState({this.isLoading = true, this.currentWeather, this.status, this.errorToastMessage, this.getWeatherArroundTheWorld, required this.homeDrawerState});

  HomeState copyWith({bool? isLoading, WeatherModel? currentWeather, ApiCallStatus? status, String? errorToastMessage,List<WeatherModel>? getWeatherArroundTheWorld, HomeDrawerState? homeDrawerState}) {
    return HomeState(
      isLoading: isLoading,
      currentWeather: currentWeather ?? this.currentWeather,
      status: status,
      errorToastMessage: errorToastMessage ?? this.errorToastMessage,
      getWeatherArroundTheWorld: getWeatherArroundTheWorld ?? this.getWeatherArroundTheWorld,
      homeDrawerState: homeDrawerState ?? this.homeDrawerState
    );
  }

  @override
  String toString() {
    return 'HomeState{isLoading: $isLoading, currentWeather: ${currentWeather?.location.name}, status: $status, errorToastMessage: $errorToastMessage, getWeatherArroundTheWorld: $getWeatherArroundTheWorld, homeDrawerState: $homeDrawerState}';
  }
}

class HomeDrawerState {
  bool? isLoading;
  List<WeatherModel> weathers;
  bool? isEmptyFounded;
  WeatherModel? currentWeather;
  ApiCallStatus? status;

  HomeDrawerState({this.isLoading = true, required this.weathers, this.isEmptyFounded, this.currentWeather, this.status});

  HomeDrawerState copyWith({bool? isLoading, List<WeatherModel>? weathers, bool? isEmptyFounded, WeatherModel? currentWeather, ApiCallStatus? status}) {
    return HomeDrawerState(
      isLoading: isLoading ?? false,
      weathers: weathers ?? this.weathers,
      isEmptyFounded: isEmptyFounded ?? false,
      currentWeather: currentWeather ?? this.currentWeather,
      status: status
    );
  }

  @override
  String toString() {
    return 'HomeDrawerState{isLoading: $isLoading, weathers: ${weathers?.length}}';
  }
}