part of 'search_bloc.dart';

class SearchState {
  final bool isLoading;
  final List<FavouriteModel> weathers;
  final bool? isEmptyFounded;
  final String? errorToastMessage;
  final ApiCallStatus? status;
  final int? currentWeatherIndex;

  SearchState({required this.isLoading, required this.weathers, this.isEmptyFounded, this.errorToastMessage, this.status, this.currentWeatherIndex});

  SearchState copyWith({bool? isLoading, List<FavouriteModel>? weathers, bool? isEmptyFounded, String? errorToastMessage, ApiCallStatus? status, int? currentWeatherIndex}) {
    return SearchState(
      isLoading: isLoading ?? false,
      weathers: weathers ?? this.weathers,
      isEmptyFounded: isEmptyFounded ?? false,
      errorToastMessage: errorToastMessage,
      status: status,
      currentWeatherIndex: currentWeatherIndex ?? this.currentWeatherIndex
    );
  }
}
