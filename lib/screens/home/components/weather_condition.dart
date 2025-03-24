import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../styles/styles.dart';

Widget getWeatherCondition(List<dynamic> currentCityWeather) {
  if (currentCityWeather.isEmpty) {
    return SizedBox.shrink(); // Return an empty widget if there's no weather data
  }

  return Column(
    children: [
      Text(
        weatherCode(currentCityWeather.first.weatherCode),
        style: weatherConditionTextStyle,
      ),
      ...currentCityWeather.map((day) => dayWeather(
        weather: weatherCode(day.weatherCode),
        dayOfWeek: DateFormat('d MMM').format(day.date),
        maxTemp: day.maxTemperature.toInt(),
        minTemp: day.minTemperature.toInt(),
        iconData: iconWeatherCode(day.weatherCode),
      )),
    ],
  );
}

String weatherCode(int code) {
  switch (code) {
    case 3:
      return 'Clear';
    case 61 || 65:
      return 'Rainy';
    case 80:
      return 'Cloudy';
    default:
      return 'Sunny';
  }
}

IconData iconWeatherCode(int code) {
  switch (code) {
    case 3:
      return Icons.sunny;
    case 61 || 65:
      return Icons.cloudy_snowing;
    case 80:
      return Icons.cloud;
    default:
      return Icons.cloud_queue_sharp;
  }
}

Widget dayWeather({
  required String weather,
  required String dayOfWeek,
  required int maxTemp,
  required int minTemp,
  required IconData iconData,
}) {
  return Padding(
    padding: const EdgeInsets.only(
      left: 20,
      right: 20,
      bottom: 20,
    ),
  );
}
