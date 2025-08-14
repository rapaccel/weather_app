import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:weather_app/home/data/dataSources/weather_remote_data_source.dart';
import 'package:weather_app/home/data/repositories/weather_repository_impl.dart';
import 'package:weather_app/home/domain/repositories/weather_repository.dart';
import 'package:weather_app/home/domain/useCases/get_city.dart';
import 'package:weather_app/home/domain/useCases/get_weather.dart';
import 'package:weather_app/home/presentation/provider/city_notifier.dart';
import 'package:weather_app/home/presentation/provider/weather_notifier.dart';

final locator = GetIt.instance;

Future<void> init() async {
  // Register repositories
  locator.registerLazySingleton<WeatherRepository>(
    () => WeatherRepositoryImpl(locator()),
  );

  // Register data sources
  locator.registerLazySingleton<WeatherRemoteDataSource>(
    () => WeatherRemoteDataSourceImpl(locator()),
  );

  // Register use cases
  locator.registerFactory(() => GetWeather(locator()));
  locator.registerFactory(() => GetCity(locator()));

  // Register notifiers
  locator.registerFactory(() => WeatherNotifier(getWeather: locator()));
  locator.registerFactory(() => CityNotifier(getCity: locator()));

  // dio
  locator.registerLazySingleton<Dio>(() => Dio());
}
