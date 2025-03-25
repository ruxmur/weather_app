import 'package:flutter/material.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:weather_application/core/utils/timezone_utils.dart';

class CityTimeProvider with ChangeNotifier {
  late DateTime _currentCityTime;

  DateTime get currentCityTime => _currentCityTime;

  Future<void> updateCityTime(double latitude, double longitude, {String? cityName}) async {
    await TimezoneUtils.initialize();
    final location = await TimezoneUtils.getLocationForCity(
      latitude,
      longitude,
      cityName: cityName,
    );
    _currentCityTime = tz.TZDateTime.now(location);
    notifyListeners();
  }
}