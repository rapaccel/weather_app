import 'package:weather_app/home/domain/entities/city_entity.dart';

class CityModel {
  final String name;
  final Map<String, String>? localNames;
  final double lat;
  final double lon;
  final String country;
  final String? state;

  CityModel({
    required this.name,
    required this.lat,
    required this.lon,
    required this.country,
    this.localNames,
    this.state,
  });

  factory CityModel.fromJson(Map<String, dynamic> json) {
    return CityModel(
      name: json['name'],
      localNames: json['local_names'] != null
          ? Map<String, String>.from(json['local_names'])
          : null,
      lat: (json['lat'] as num).toDouble(),
      lon: (json['lon'] as num).toDouble(),
      country: json['country'],
      state: json['state'] != null ? json['state'] : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'local_names': localNames,
      'lat': lat,
      'lon': lon,
      'country': country,
      'state': state, // Optional, can be null
    };
  }

  /// Konversi ke entity (domain layer)
  CityEntity toEntity() {
    return CityEntity(
      name: name,
      lat: lat,
      lon: lon,
      country: country,
      state: state,
    );
  }
}
