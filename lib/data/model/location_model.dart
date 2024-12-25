class Location {
  String name;
  String region;
  String country;
  double lat;
  double lon;
  String tzId;
  String localtimeEpoch;
  String localtime;

  Location({
    required this.name,
    required this.region,
    required this.country,
    required this.lat,
    required this.lon,
    required this.tzId,
    required this.localtimeEpoch,
    required this.localtime,
  });

  factory Location.fromJson(Map<String, dynamic> json) => Location(
    name: json['name'],
    region: json['region'],
    country: json['country'],
    lat: json['lat']?.toDouble(),
    lon: json['lon']?.toDouble(),
    tzId: json['tz_id'],
    localtimeEpoch: json['localtime_epoch'].toString(),
    localtime: json['localtime'],
  );

  @override
  String toString() {
    return 'Location{name: $name, region: $region, lat: $lat, lon: $lon}';
  }
}