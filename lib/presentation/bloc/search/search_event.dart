part of 'search_bloc.dart';


class SearchEvent {}

class SearchingEvent extends SearchEvent {
  final String searchQuery;

  SearchingEvent(this.searchQuery);
}

class InitEvent extends SearchEvent {}

class AddFavouriteEvent extends SearchEvent {
  final FavouriteModel favouriteModel;

  AddFavouriteEvent(this.favouriteModel);
}

class DeleteFavouriteEvent extends SearchEvent {
  final int index;

  DeleteFavouriteEvent(this.index);
}