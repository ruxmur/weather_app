import 'package:flutter/material.dart';

import '../../../../core/utils/weather_utils.dart';

class WeatherIconData {
  final String iconPath;

  WeatherIconData(this.iconPath);
}

WeatherIconData getWeatherIconData(DateTime dateTime, int weatherCode, {bool forceDayIcon = false}) {
  final hour = dateTime.hour;
  final isDayTime = forceDayIcon ? true : (hour >= 6 && hour < 18);

  // Get the weather type based on the code
  final weatherType = WeatherUtils.getWeatherTypeFromCode(weatherCode);
  String iconPath;

  // Determine icon path based on weather type and time of day
  switch (weatherType) {
    case WeatherType.clear:
      iconPath = isDayTime
          ? 'assets/icons/sunny.png'
          : 'assets/icons/clear_night.png';
      break;
    case WeatherType.cloudy:
      iconPath = isDayTime
          ? 'assets/icons/cloudy.png'
          : 'assets/icons/cloudy_night.png';
      break;
    case WeatherType.rainy:
      iconPath = isDayTime
          ? 'assets/icons/rainy.png'
          : 'assets/icons/rainy_night.png';
      break;
    case WeatherType.stormy:
      iconPath = 'assets/icons/storm.png';
      break;
    case WeatherType.sunnyRainy:
      iconPath = 'assets/icons/sunny_rainy.png';
      break;
    default:
      iconPath = isDayTime
          ? 'assets/icons/sunny.png'
          : 'assets/icons/clear_night.png';
  }

  return WeatherIconData(iconPath);
}