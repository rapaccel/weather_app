class WeatherEntity {
  final CoordEntity coord;
  final List<WeatherDetailEntity> weather;
  final String base;
  final MainEntity main;
  final int visibility;
  final WindEntity wind;
  final CloudsEntity clouds;
  final int dt;
  final SysEntity sys;
  final int timezone;
  final int id;
  final String name;
  final int cod;

  WeatherEntity({
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
}

class CoordEntity {
  final double lon;
  final double lat;

  CoordEntity({required this.lon, required this.lat});
}

class WeatherDetailEntity {
  final int id;
  final String main;
  final String description;
  final String icon;

  WeatherDetailEntity({
    required this.id,
    required this.main,
    required this.description,
    required this.icon,
  });
}

class MainEntity {
  final double temp;
  final double feelsLike;
  final double tempMin;
  final double tempMax;
  final int pressure;
  final int humidity;
  final int seaLevel;
  final int grndLevel;

  MainEntity({
    required this.temp,
    required this.feelsLike,
    required this.tempMin,
    required this.tempMax,
    required this.pressure,
    required this.humidity,
    required this.seaLevel,
    required this.grndLevel,
  });
}

class WindEntity {
  final double speed;
  final int deg;
  final double gust;

  WindEntity({required this.speed, required this.deg, required this.gust});
}

class CloudsEntity {
  final int all;

  CloudsEntity({required this.all});
}

class SysEntity {
  final String country;
  final int sunrise;
  final int sunset;

  SysEntity({
    required this.country,
    required this.sunrise,
    required this.sunset,
  });
}
