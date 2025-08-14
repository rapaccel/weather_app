import 'package:weather_app/home/data/dataSources/weather_remote_data_source.dart';
import 'package:weather_app/home/domain/entities/city_entity.dart';
import 'package:weather_app/home/domain/entities/weather_entity.dart';
import 'package:weather_app/home/domain/repositories/weather_repository.dart';

class WeatherRepositoryImpl implements WeatherRepository {
  final WeatherRemoteDataSource remoteDataSource;

  WeatherRepositoryImpl(this.remoteDataSource);

  @override
  Future<WeatherEntity> getWeather(double lat, double lon) async {
    final weatherModel = await remoteDataSource.getWeather(lat, lon);
    return weatherModel.toEntity();
  }

  @override
  Future<List<CityEntity>> getWeatherByCityName(String cityName) async {
    final cityModel = await remoteDataSource.getWeatherByCityName(cityName);
    return cityModel.map((model) => model.toEntity()).toList();
  }
}
