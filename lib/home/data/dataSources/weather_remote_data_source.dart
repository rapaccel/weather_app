import 'package:dio/dio.dart';
import 'package:weather_app/home/data/model/city_model.dart';
import 'package:weather_app/home/data/model/weather_model.dart';

abstract class WeatherRemoteDataSource {
  Future<WeatherModel> getWeather(double lat, double lon);
  Future<List<CityModel>> getWeatherByCityName(String cityName);
}

class WeatherRemoteDataSourceImpl implements WeatherRemoteDataSource {
  final Dio dio;

  WeatherRemoteDataSourceImpl(this.dio);

  @override
  Future<WeatherModel> getWeather(double lat, double lon) async {
    final response = await dio.get(
      'https://api.openweathermap.org/data/2.5/weather',
      queryParameters: {
        'lat': lat,
        'lon': lon,
        'appid': 'a0941b22c7073ae9040ced149ac9131a',
        'exclude': 'hourly,daily',
        'units': 'metric',
        'lang': 'id',
      },
    );
    if (response.statusCode == 200) {
      return WeatherModel.fromJson(response.data);
    } else {
      throw Exception('Failed to load weather data');
    }
  }

  @override
  Future<List<CityModel>> getWeatherByCityName(String cityName) async {
    final response = await dio.get(
      'https://api.openweathermap.org/geo/1.0/direct',
      queryParameters: {
        'q': cityName,
        'appid': 'a0941b22c7073ae9040ced149ac9131a',
        'country': 'ID',
        'limit': 5,
      },
    );

    if (response.statusCode == 200) {
      final data = response.data;
      if (data is List && data.isNotEmpty) {
        print('City data fetched: $data');

        return data.map((item) => CityModel.fromJson(item)).toList();
      } else {
        throw Exception('City not found: $cityName');
      }
    } else {
      throw Exception('Failed to load weather data for city: $cityName');
    }
  }
}
