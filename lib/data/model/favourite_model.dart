import 'package:weather_now/data/source/local/favourite_entity.dart';

class FavouriteModel {
  final String name;
  final String region;
  final String country;
  final double lat;
  final double lon;
  final bool isSaved;
  final int? iconCode;
  final double? tempC;
  final double? tempF;

  FavouriteModel(
      {required this.name,
      required this.region,
      required this.country,
      required this.lat,
      required this.lon,
      this.isSaved = false,
      required this.iconCode,
      required this.tempC,
      required this.tempF});

  
  FavouriteModel copyWith({String? name, String? region, String? country, double? lat, double? lon, bool? isSaved, int? iconCode, double? tempC, double? tempF}) {
    return FavouriteModel(
      country: country ?? this.country,
      name: name ?? this.name,
      region: region ?? this.region,
      lat: lat ?? this.lat,
      lon: lon ?? this.lon,
      isSaved: isSaved ?? this.isSaved,
      iconCode: iconCode ?? this.iconCode,
      tempC: tempC ?? this.tempC,
      tempF: tempF ?? this.tempF,
    );
  }
}
