part of 'locations_bloc.dart';

class LocationsState {
  List<WeatherEntity> savedLocation;
  bool? isLoading;
  String? errorToastMessage;
  int currentLocationId;

  LocationsState(
      {required this.savedLocation,
      this.isLoading,
      this.errorToastMessage,
      this.currentLocationId = -1});

  LocationsState copyWith(
      {List<WeatherEntity>? savedLocation,
      bool? isLoading,
      String? errorToastMessage,
      int? currentLocationId}) {
    return LocationsState(
        savedLocation: savedLocation ?? this.savedLocation,
        isLoading: isLoading,
        errorToastMessage: errorToastMessage,
        currentLocationId: currentLocationId ?? this.currentLocationId);
  }

  @override
  String toString() {
    return 'LocationsState{savedLocation: ${savedLocation.length}, currentLocationId: $currentLocationId, isLoading: $isLoading, errorToastMessage: $errorToastMessage}';
  }
}
