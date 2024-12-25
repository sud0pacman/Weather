import 'condition_model.dart';
import 'current_model.dart';
import 'location_model.dart';

class WeatherModel {
  Location location;
  Current current;
  final Forecast forecast;

  WeatherModel({
    required this.location,
    required this.current,
    required this.forecast
  });

  factory WeatherModel.fromJson(Map<String, dynamic> json) => WeatherModel(
    location: Location.fromJson(json['location']),
    current: Current.fromJson(json['current']),
    forecast: Forecast.fromJson(json['forecast']),
  );


  @override
  String toString() {
    return 'WeatherModel{location: $location, current: $current, forecast: $forecast}';
  }
}

class Forecast {
  final List<ForecastDay> forecastday;

  Forecast({required this.forecastday});

  factory Forecast.fromJson(Map<String, dynamic> json) {
    var list = json['forecastday'] as List;
    List<ForecastDay> forecastList = list.map((e) => ForecastDay.fromJson(e)).toList();
    return Forecast(forecastday: forecastList);
  }

  Map<String, dynamic> toJson() {
    return {
      'forecastday': forecastday.map((e) => e.toJson()).toList(),
    };
  }

  @override
  String toString() {
    return 'Forecast{forecastday: $forecastday}';
  }
}


class ForecastDay {
  final String date;
  final Day day;
  final List<Hour> hour;

  ForecastDay({required this.date, required this.day, required this.hour});

  factory ForecastDay.fromJson(Map<String, dynamic> json) {
    var list = json['hour'] as List;

    return ForecastDay(
      date: json['date'],
      day: Day.fromJson(json['day']),
      hour: list.map((e) => Hour.fromJson(e)).toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'date': date,
      'day': day.toJson()
    };
  }

  @override
  String toString() {
    return 'ForecastDay{date: $date, day: $day, hour:${hour[0].time}';
  }
}



class Day {
  final double tempC;
  final double tempF;
  final Condition condition;

  Day({required this.tempC, required this.tempF, required this.condition});

  factory Day.fromJson(Map<String, dynamic> json) {
    return Day(
      tempC: json['avgtemp_c'],
      tempF: json['avgtemp_f'],
      condition: Condition.fromJson(json['condition'])
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'tempC': tempC,
      'tempF': tempF,
    };
  }

  @override
  String toString() {
    return 'Day{tempC: $tempC, tempF: $tempF, condition: ${condition.text}';
  }
}

class Hour {
  num timeEpoch;
  String time;
  double tempC;
  double tempF;
  num isDay;
  Condition condition;
  double windMph;
  double windKph;
  num? windDegree;
  String? windDir;
  num? pressureMb;
  double? pressureIn;
  num? precipMm;
  num? precipIn;
  num? humidity;
  num? cloud;
  double? feelslikeC;
  double? feelslikeF;
  double? windchillC;
  double? windchillF;
  double? heatindexC;
  double? heatindexF;
  double? dewpointC;
  double? dewpointF;
  num? willItRain;
  num? chanceOfRain;
  num? willItSnow;
  num? chanceOfSnow;
  num? visKm;
  num? visMiles;
  double? gustMph;
  double? gustKph;
  num? uv;

  Hour({
    required this.timeEpoch,
    required this.time,
    required this.tempC,
    required this.tempF,
    required this.isDay,
    required this.condition,
    required this.windMph,
    required this.windKph,
    this.windDegree,
    this.windDir,
    this.pressureMb,
    this.pressureIn,
    this.precipMm,
    this.precipIn,
    this.humidity,
    this.cloud,
    this.feelslikeC,
    this.feelslikeF,
    this.windchillC,
    this.windchillF,
    this.heatindexC,
    this.heatindexF,
    this.dewpointC,
    this.dewpointF,
    this.willItRain,
    this.chanceOfRain,
    this.willItSnow,
    this.chanceOfSnow,
    this.visKm,
    this.visMiles,
    this.gustMph,
    this.gustKph,
    this.uv,
  });

  factory Hour.fromJson(Map<String, dynamic> json) => Hour(
    timeEpoch: json['time_epoch'],
    time: json['time'],
    tempC: json['temp_c']?.toDouble(),
    tempF: json['temp_f']?.toDouble(),
    isDay: json['is_day'],
    condition: Condition.fromJson(json['condition']),
    windMph: json['wind_mph']?.toDouble(),
    windKph: json['wind_kph']?.toDouble(),
    windDegree: json['wind_degree'],
    windDir: json['wind_dir'],
    pressureMb: json['pressure_mb'],
    pressureIn: json['pressure_in']?.toDouble(),
    precipMm: json['precip_mm'],
    precipIn: json['precip_in'],
    humidity: json['humidity'],
    cloud: json['cloud'],
    feelslikeC: json['feelslike_c']?.toDouble(),
    feelslikeF: json['feelslike_f']?.toDouble(),
    windchillC: json['windchill_c']?.toDouble(),
    windchillF: json['windchill_f']?.toDouble(),
    heatindexC: json['heatindex_c']?.toDouble(),
    heatindexF: json['heatindex_f']?.toDouble(),
    dewpointC: json['dewpoint_c']?.toDouble(),
    dewpointF: json['dewpoint_f']?.toDouble(),
    willItRain: json['will_it_rain'],
    chanceOfRain: json['chance_of_rain'],
    willItSnow: json['will_it_snow'],
    chanceOfSnow: json['chance_of_snow'],
    visKm: json['vis_km'],
    visMiles: json['vis_miles'],
    gustMph: json['gust_mph']?.toDouble(),
    gustKph: json['gust_kph']?.toDouble(),
    uv: json['uv'],
  );

  Map<String, dynamic> toJson() => {
    'time_epoch': timeEpoch,
    'time': time,
    'temp_c': tempC,
    'temp_f': tempF,
    'is_day': isDay,
    'condition': condition.toJson(),
    'wind_mph': windMph,
    'wind_kph': windKph,
    'wind_degree': windDegree,
    'wind_dir': windDir,
    'pressure_mb': pressureMb,
    'pressure_in': pressureIn,
    'precip_mm': precipMm,
    'precip_in': precipIn,
    'humidity': humidity,
    'cloud': cloud,
    'feelslike_c': feelslikeC,
    'feelslike_f': feelslikeF,
    'windchill_c': windchillC,
    'windchill_f': windchillF,
    'heatindex_c': heatindexC,
    'heatindex_f': heatindexF,
    'dewpoint_c': dewpointC,
    'dewpoint_f': dewpointF,
    'will_it_rain': willItRain,
    'chance_of_rain': chanceOfRain,
    'will_it_snow': willItSnow,
    'chance_of_snow': chanceOfSnow,
    'vis_km': visKm,
    'vis_miles': visMiles,
    'gust_mph': gustMph,
    'gust_kph': gustKph,
    'uv': uv,
  };
}