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
        lat: json['lat'],
        lon: json['lon'],
        tzId: json['tz_id'],
        localtimeEpoch: json['localtime_epoch'].toString(),
        localtime: json['localtime'],
      );

  Location copyWith(
      {String? name,
      String? region,
      String? country,
      double? lat,
      double? lon,
      String? tzId,
      String? localtimeEpoch,
      String? localtime}) {
    return Location(
      name: name ?? this.name,
      region: region ?? this.region,
      country: country ?? this.country,
      lat: lat ?? this.lat,
      lon: lon ?? this.lon,
      tzId: tzId ?? this.tzId,
      localtimeEpoch: localtimeEpoch ?? this.localtimeEpoch,
      localtime: localtime ?? this.localtime,
    );
  }

  @override
  String toString() {
    return 'Location{name: $name, region: $region, lat: $lat, lon: $lon}';
  }
}
