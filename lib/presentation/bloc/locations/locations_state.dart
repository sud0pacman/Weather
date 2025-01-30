part of 'locations_bloc.dart';

class LocationsState {
  List<WeatherModel> savedLocations;
  bool isLoading;
  String? errorToastMessage;
  int currentLocationId;
  bool isSelectable;

  LocationsState(
      {required this.savedLocations,
      this.isLoading = false,
      this.errorToastMessage,
      this.currentLocationId = -1,
      this.isSelectable = false});

  LocationsState copyWith(
      {List<WeatherModel>? savedLocations,
      bool? isLoading,
      String? errorToastMessage,
      int? currentLocationId,
        bool? isSelectable}) {
    return LocationsState(
      savedLocations: savedLocations ?? this.savedLocations,
      isLoading: isLoading ?? false,
      errorToastMessage: errorToastMessage,
      currentLocationId: currentLocationId ?? this.currentLocationId,
      isSelectable: isSelectable ?? false,
    );
  }

  @override
  String toString() {
    return 'LocationsState{savedLocation: ${savedLocations.length}, currentLocationId: $currentLocationId, isLoading: $isLoading, errorToastMessage: $errorToastMessage}';
  }
}
