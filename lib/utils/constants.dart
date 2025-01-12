import 'package:logger/logger.dart';

class Constants {
  // api key
  static const mApiKey = 'd936fb9a49f44c6db95130350240612';
  static const apiKey = 'd936fb9a49f44c6db95130350240612';

  // api urls
  static const baseUrl = 'http://api.weatherapi.com/v1';
  static const currentWeatherApiUrl = '$baseUrl/current.json';
  static const forecastWeatherApiUrl = '$baseUrl/forecast.json';
  static const searchWeatherApiUrl = '$baseUrl/search.json';

  // api fields
  static const key = 'key';
  static const q = 'q';
  static const days = 'days';
  static const lang = 'lang';

  // logger
  static var logger = Logger();

  // storage fields
  static var currentWeatherId = 'currentWeatherId';
  static var currentLocationLat = 'currentLocationLat';
  static var currentLocationLong = 'currentLocationLong';

  // hive box names
  static const weatherBox = 'weather';
  static const preferencesBox = 'preferences';
  static const favouriteBox = 'favourites';

  // assets
  static const String background = 'assets/images/bg2.png';
  static const String house = 'assets/images/house.png';
  static const logo = 'assets/images/app_icon.png';
  static const welcome = 'assets/images/welcome.png';
  static const world = 'assets/images/world.png';
  static const world2 = 'assets/images/world2.png';
  static const noData = 'assets/images/no_data.png';
  static const search = 'assets/vectors/search.svg';
  static const language = 'assets/vectors/language.svg';
  static const category = 'assets/vectors/category.svg';
  static const downArrow = 'assets/vectors/down_arrow.svg';
  static const wind = 'assets/vectors/wind.svg';
  static const pressure = 'assets/vectors/pressure.svg';
  static const doubleChevron = 'assets/icons/double_chevron.png';

  // lottie
  static const weatherAnimation = 'assets/lottie/weather_animation.json';
  static const internetLottie = 'assets/lottie/internet_lottie.json';
  static const loadingLottie = 'assets/lottie/loading.json';
  static const searchLottie = 'assets/lottie/search.json';
  static const offlineLottie = 'assets/lottie/offline.json';
}
