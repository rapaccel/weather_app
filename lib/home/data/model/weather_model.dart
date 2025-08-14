import 'package:weather_app/home/domain/entities/weather_entity.dart';

class WeatherModel {
  final CoordModel coord;
  final List<WeatherDetailModel> weather;
  final String base;
  final MainModel main;
  final int visibility;
  final WindModel wind;
  final CloudsModel clouds;
  final int dt;
  final SysModel sys;
  final int timezone;
  final int id;
  final String name;
  final int cod;

  WeatherModel({
    required this.coord,
    required this.weather,
    required this.base,
    required this.main,
    required this.visibility,
    required this.wind,
    required this.clouds,
    required this.dt,
    required this.sys,
    required this.timezone,
    required this.id,
    required this.name,
    required this.cod,
  });

  factory WeatherModel.fromJson(Map<String, dynamic> json) {
    return WeatherModel(
      coord: CoordModel.fromJson(json['coord']),
      weather: (json['weather'] as List)
          .map((e) => WeatherDetailModel.fromJson(e))
          .toList(),
      base: json['base'],
      main: MainModel.fromJson(json['main']),
      visibility: json['visibility'],
      wind: WindModel.fromJson(json['wind']),
      clouds: CloudsModel.fromJson(json['clouds']),
      dt: json['dt'],
      sys: SysModel.fromJson(json['sys']),
      timezone: json['timezone'],
      id: json['id'],
      name: json['name'],
      cod: json['cod'],
    );
  }

  WeatherEntity toEntity() {
    return WeatherEntity(
      coord: coord.toEntity(),
      weather: weather.map((e) => e.toEntity()).toList(),
      base: base,
      main: main.toEntity(),
      visibility: visibility,
      wind: wind.toEntity(),
      clouds: clouds.toEntity(),
      dt: dt,
      sys: sys.toEntity(),
      timezone: timezone,
      id: id,
      name: name,
      cod: cod,
    );
  }
}

class CoordModel {
  final double lon;
  final double lat;

  CoordModel({required this.lon, required this.lat});

  factory CoordModel.fromJson(Map<String, dynamic> json) {
    return CoordModel(
      lon: (json['lon'] ?? 0).toDouble(),
      lat: (json['lat'] ?? 0).toDouble(),
    );
  }

  CoordEntity toEntity() => CoordEntity(lon: lon, lat: lat);
}

class WeatherDetailModel {
  final int id;
  final String main;
  final String description;
  final String icon;

  WeatherDetailModel({
    required this.id,
    required this.main,
    required this.description,
    required this.icon,
  });

  factory WeatherDetailModel.fromJson(Map<String, dynamic> json) {
    return WeatherDetailModel(
      id: json['id'],
      main: json['main'],
      description: json['description'],
      icon: json['icon'],
    );
  }

  WeatherDetailEntity toEntity() => WeatherDetailEntity(
    id: id,
    main: main,
    description: description,
    icon: icon,
  );
}

class MainModel {
  final double temp;
  final double feelsLike;
  final double tempMin;
  final double tempMax;
  final int pressure;
  final int humidity;
  final int seaLevel;
  final int grndLevel;

  MainModel({
    required this.temp,
    required this.feelsLike,
    required this.tempMin,
    required this.tempMax,
    required this.pressure,
    required this.humidity,
    required this.seaLevel,
    required this.grndLevel,
  });

  factory MainModel.fromJson(Map<String, dynamic> json) {
    return MainModel(
      temp: (json['temp'] ?? 0).toDouble(),
      feelsLike: (json['feels_like'] ?? 0).toDouble(),
      tempMin: (json['temp_min'] ?? 0).toDouble(),
      tempMax: (json['temp_max'] ?? 0).toDouble(),
      pressure: json['pressure'],
      humidity: json['humidity'],
      seaLevel: json['sea_level'],
      grndLevel: json['grnd_level'],
    );
  }

  MainEntity toEntity() => MainEntity(
    temp: temp,
    feelsLike: feelsLike,
    tempMin: tempMin,
    tempMax: tempMax,
    pressure: pressure,
    humidity: humidity,
    seaLevel: seaLevel,
    grndLevel: grndLevel,
  );
}

class WindModel {
  final double speed;
  final int deg;
  final double gust;

  WindModel({required this.speed, required this.deg, required this.gust});

  factory WindModel.fromJson(Map<String, dynamic> json) {
    return WindModel(
      speed: (json['speed'] ?? 0).toDouble(),
      deg: json['deg'],
      gust: (json['gust'] ?? 0).toDouble(),
    );
  }

  WindEntity toEntity() => WindEntity(speed: speed, deg: deg, gust: gust);
}

class CloudsModel {
  final int all;

  CloudsModel({required this.all});

  factory CloudsModel.fromJson(Map<String, dynamic> json) {
    return CloudsModel(all: json['all']);
  }

  CloudsEntity toEntity() => CloudsEntity(all: all);
}

class SysModel {
  final String country;
  final int sunrise;
  final int sunset;

  SysModel({
    required this.country,
    required this.sunrise,
    required this.sunset,
  });

  factory SysModel.fromJson(Map<String, dynamic> json) {
    return SysModel(
      country: json['country'],
      sunrise: json['sunrise'],
      sunset: json['sunset'],
    );
  }

  SysEntity toEntity() =>
      SysEntity(country: country, sunrise: sunrise, sunset: sunset);
}
