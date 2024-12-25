part of 'home_bloc.dart';

class HomeEvent {}

class HomeInitEvent extends HomeEvent {
  final String? locationData;

  HomeInitEvent({this.locationData});
}

class HomeGetUserLocation extends HomeEvent {}

class HomeGetSavedLocations extends HomeEvent {}

