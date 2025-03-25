import 'package:flutter/material.dart';
import 'package:weather_application/core/domain/location/city.dart';
import 'package:weather_application/core/domain/weather/weather_details.dart';
import 'package:weather_application/core/api/weather_repository.dart';

class WeatherController extends ChangeNotifier {
  final CityModel city;
  WeatherDetailsModel? weatherDetailsModel;
  bool isLoading = true;
  String errorMessage = '';

  WeatherController({required this.city});

  Future<void> initialize() async {
    await _fetchWeatherDetails();
  }

  Future<void> _fetchWeatherDetails() async {
    try {
      final details = await RepositoryWeather.getWeatherDetails(latitude: city.latitude, longitude: city.longitude,);
      weatherDetailsModel = WeatherDetailsModel.fromJson(details);
      isLoading = false;
    } catch (e) {
      errorMessage = 'Failed to load weather details: ${e.toString()}';
      weatherDetailsModel = WeatherDetailsModel(
        // Set default values to prevent null errors
        precipitation: 0,
        humidity: 0,
        windSpeed: 0,
        airQuality: 0,
      );
      isLoading = false;
    }
    notifyListeners();
  }
}