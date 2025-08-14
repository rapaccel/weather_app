import 'package:weather_app/home/domain/entities/city_entity.dart';
import 'package:weather_app/home/domain/entities/weather_entity.dart';

abstract class WeatherRepository {
  Future<WeatherEntity> getWeather(double lat, double lon);
  Future<List<CityEntity>> getWeatherByCityName(String cityName);
}
