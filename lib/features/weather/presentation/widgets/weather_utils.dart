import 'package:flutter/material.dart';

class WeatherIconData {
  final IconData icon;
  final Color color;

  WeatherIconData(this.icon, this.color);
}

WeatherIconData getWeatherIconData(DateTime dateTime, int weatherCode) {
  final hour = dateTime.hour;
  final isDayTime = hour >= 6 && hour < 18;
  final isNight = !isDayTime;

  // WMO Weather code interpretation
  // todo to use icons like this Image.asset(WeatherUtils.getWeatherIconFromCode(weatherCode))
  IconData icon;
  switch (weatherCode) {
    case 0: // Clear sky
      icon = isDayTime ? Icons.wb_sunny : Icons.nightlight_round;
      break;
    case 1: // Mainly clear
    case 2: // Partly cloudy
      icon = isDayTime ? Icons.wb_cloudy : Icons.cloud_outlined;
      break;
    case 3: // Overcast
      icon = Icons.cloud;
      break;
    case 45: // Fog
    case 48: // Depositing rime fog
      icon = Icons.foggy;
      break;
    case 51: // Light drizzle
    case 53: // Moderate drizzle
    case 55: // Dense drizzle
      icon = Icons.grain;
      break;
    case 61: // Slight rain
    case 63: // Moderate rain
    case 65: // Heavy rain
      icon = Icons.beach_access;
      break;
    case 71: // Slight snow fall
    case 73: // Moderate snow fall
    case 75: // Heavy snow fall
      icon = Icons.ac_unit;
      break;
    case 95: // Thunderstorm
    case 96: // Thunderstorm with slight hail
    case 99: // Thunderstorm with heavy hail
      icon = Icons.flash_on;
      break;
    default:
      icon = isDayTime ? Icons.cloud_queue : Icons.nights_stay;
  }

  // Determine color based on weather condition
  Color color;
  if (isNight) {
    color = const Color.fromARGB(237, 7, 37, 104).withOpacity(0.5); // Nighttime color
  } else {
    switch (weatherCode) {
      // Clear sky
      case 0: color = Colors.yellow; break;
      // Mainly clear | Partly cloudy
      case 1: case 2: color = Colors.orange.withOpacity(0.6); break;
      // Overcast
      case 3: color = Colors.blueGrey; break;
      // Fog
      case 45: case 48: color = Colors.grey; break;
      // Drizzle
      case 51: case 53: case 55: color = Colors.lightBlue; break;
      // Rain
      case 61: case 63: case 65: color = Colors.blue; break;
      // Snow
      case 71: case 73: case 75: color = Colors.white; break;
      // Thunderstorm
      case 95: case 96: case 99: color = Colors.deepPurple; break;
      default: color = Colors.blueGrey;
    }
  }

  return WeatherIconData(icon, color);
}