import 'package:flutter/cupertino.dart';
import '../weather/weather_day.dart';
import '../../api/weather_repository.dart';
import '../location/city.dart';

class WeatherProvider with ChangeNotifier {
  List<WeatherDayModel> days = [];
  String locationName = 'Loading...';
  double currentTemperature = 0.0;
  double feelsLikeTemperature = 0.0;
  int currentWeatherCode = 0;
  CityModel? currentCity;

  Future<void> init() async {
    if (currentCity != null) {
      await fetchWeatherData(currentCity!);
    }
  }

  Future<void> fetchWeatherData(CityModel city) async {
    try {
      // Fetch the weather data using the location
      final dailyModel = await WeatherRepository.getWeather(
        latitude: city.latitude,
        longitude: city.longitude,
      );

      // Fetch the location name
      locationName = await WeatherRepository.getLocationName(
        latitude: city.latitude,
        longitude: city.longitude,
      );

      // Fetch the current weather data
      final currentWeather = await WeatherRepository.getCurrentWeather(
        latitude: city.latitude,
        longitude: city.longitude,
      );

      currentTemperature = currentWeather['temperature_2m'];
      currentWeatherCode = currentWeather['weather_code'];
      feelsLikeTemperature = currentWeather['apparent_temperature'] ?? currentTemperature;

      // Parse daily weather data
      days = dailyModel.time.asMap().entries.map((entry) {
        final i = entry.key;
        return WeatherDayModel(
          date: entry.value,
          minTemperature: dailyModel.temperature2mMin[i],
          maxTemperature: dailyModel.temperature2mMax[i],
          feelsLike: dailyModel.apparentTemperature?[i] ?? dailyModel.temperature2mMax[i],
          uvIndex: dailyModel.uvIndexMax[i],
          weatherCode: dailyModel.weatherCode[i],
        );
      }).toList();

      notifyListeners();
    } catch (e) {
      locationName = 'Unable to fetch location';
      notifyListeners();
    }
  }

  void setCity(CityModel city) {
    currentCity = city;
    fetchWeatherData(city);
  }
}
