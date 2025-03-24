import 'package:flutter/cupertino.dart';
import '../../../core/repo/repository_weather.dart';
import 'models/city_model.dart';
import 'models/day_model.dart';

class WeatherProvider with ChangeNotifier {
  List<DayModel> days = [];
  String locationName = 'Loading...';
  double currentTemperature = 0.0;
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
      final dailyModel = await RepositoryWeather.getWeather(
        latitude: city.latitude,
        longitude: city.longitude,
      );

      // Fetch the location name
      locationName = await RepositoryWeather.getLocationName(
        latitude: city.latitude,
        longitude: city.longitude,
      );

      // Fetch the current weather data
      final currentWeather = await RepositoryWeather.getCurrentWeather(
        latitude: city.latitude,
        longitude: city.longitude,
      );

      currentTemperature = currentWeather['temperature_2m'];
      currentWeatherCode = currentWeather['weather_code'];

      // Parse daily weather data
      days.clear();
      for (var i = 0; i < dailyModel.time.length; i++) {
        days.add(DayModel(
          date: dailyModel.time[i],
          minTemperature: dailyModel.temperature2mMin[i],
          maxTemperature: dailyModel.temperature2mMax[i],
          uvIndex: dailyModel.uvIndexMax[i],
          weatherCode: dailyModel.weatherCode[i],
        ));
      }

      notifyListeners();
    } catch (e) {
      print("Error: $e");
      locationName = 'Unable to fetch location';
      notifyListeners();
    }
  }

  void setCity(CityModel city) {
    currentCity = city;
    fetchWeatherData(city);
  }

// Future<Position> _getCurrentLocation() async {
//   bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
//   if (!serviceEnabled) {
//     return Future.error('Location services are disabled.');
//   }
//
//   LocationPermission permission = await Geolocator.checkPermission();
//   if (permission == LocationPermission.denied) {
//     permission = await Geolocator.requestPermission();
//     if (permission == LocationPermission.denied) {
//       return Future.error('Location permissions are denied');
//     }
//   }
//
//   if (permission == LocationPermission.deniedForever) {
//     return Future.error('Location permissions are permanently denied, we cannot request permissions.');
//   }
//
//   return await Geolocator.getCurrentPosition();
// }
}
