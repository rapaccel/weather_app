class CityEntity {
  final String name;
  final double lat;
  final double lon;
  final String country;
  final String? state;

  CityEntity({
    required this.name,
    required this.lat,
    required this.lon,
    required this.country,
    this.state,
  });
}
