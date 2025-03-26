import 'package:flutter/material.dart';
import 'package:weather_application/core/domain/location/city.dart';
import 'package:weather_application/core/domain/weather/weather_details.dart';
import 'package:weather_application/core/api/weather_repository.dart';

class WeatherController extends ChangeNotifier {
  final CityModel city;
  WeatherDetailsModel? weatherDetailsModel;
  bool isLoading = true;
  String errorMessage = '';
  List<double> hourlyHumidity = List.filled(24, 0.0);

  WeatherController({required this.city});

  Future<void> initialize() async {
    await _fetchWeatherDetails();
    await _fetchHourlyHumidity();
  }

  Future<void> _fetchWeatherDetails() async {
    try {
      final details = await WeatherRepository.getWeatherDetails(latitude: city.latitude, longitude: city.longitude,);
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

  Future<void> _fetchHourlyHumidity() async {
    try {
      final data = await WeatherRepository.getHourlyHumidity(latitude: city.latitude, longitude: city.longitude);
      hourlyHumidity = data;
    } catch (e) {
      hourlyHumidity = List.filled(24, 0.0);
      errorMessage = 'Failed to load humidity data: ${e.toString()}';
    }
    notifyListeners();
  }
}
