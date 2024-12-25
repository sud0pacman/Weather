part of 'locations_bloc.dart';

class LocationsEvent {}

class LocationInitialEvent extends LocationsEvent {}

class DeleteLocationEvent extends LocationsEvent {
  final int weatherModelIndex;

  DeleteLocationEvent(this.weatherModelIndex);
}
