import 'package:weather_now/data/model/favourite_model.dart';

class SearchedWeatherModel {
  int? id;
  String? name;
  String? region;
  String? country;
  double? lat;
  double? lon;
  String? url;

  SearchedWeatherModel(
      {this.id,
        this.name,
        this.region,
        this.country,
        this.lat,
        this.lon,
        this.url});

  SearchedWeatherModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    region = json['region'];
    country = json['country'];
    lat = json['lat'];
    lon = json['lon'];
    url = json['url'];
  }
  
  FavouriteModel toFavouriteModel() {
    return FavouriteModel(name: name ?? "", region: region ?? "", lat: lat ?? 0.0, lon: lon ?? 0.0, isSaved: false, iconCode: 0, tempC: 0.0, tempF: 0.0, country: country ?? '');
  }

  @override
  String toString() {
    return 'SearchedWeatherModel{id: $id, name: $name, region: $region, country: $country, lat: $lat, lon: $lon, url: $url}';
  }
}
