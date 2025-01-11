part of 'locations_bloc.dart';

class LocationsState {
  List<WeatherEntity> savedLocation;
  bool isLoading;
  String? errorToastMessage;
  int currentLocationId;
  bool isSelectable;

  LocationsState(
      {required this.savedLocation,
      this.isLoading = false,
      this.errorToastMessage,
      this.currentLocationId = -1,
      this.isSelectable = false});

  LocationsState copyWith(
      {List<WeatherEntity>? savedLocation,
      bool? isLoading,
      String? errorToastMessage,
      int? currentLocationId,
        bool? isSelectable}) {
    return LocationsState(
      savedLocation: savedLocation ?? this.savedLocation,
      isLoading: isLoading ?? false,
      errorToastMessage: errorToastMessage,
      currentLocationId: currentLocationId ?? this.currentLocationId,
      isSelectable: isSelectable ?? false,
    );
  }

  @override
  String toString() {
    return 'LocationsState{savedLocation: ${savedLocation.length}, currentLocationId: $currentLocationId, isLoading: $isLoading, errorToastMessage: $errorToastMessage}';
  }
}
