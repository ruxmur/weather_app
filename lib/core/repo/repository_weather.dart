import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/daily_dto.dart';

class RepositoryWeather {
  static Future<DailyDTO> getWeather(
      {required double latitude, required double longitude}) async {
    //https://api.open-meteo.com/v1/forecast?latitude=52.52&longitude=13.41&current=is_day&daily=weather_code,temperature_2m_max,temperature_2m_min,uv_index_max
    final url = Uri.https('api.open-meteo.com', 'v1/forecast', {
      'latitude': latitude.toString(),
      'longitude': longitude.toString(),
      'daily': [
        'weather_code',
        'temperature_2m_max',
        'temperature_2m_min',
        'uv_index_max'
      ],
    });
    final http.Response response = await http.get(url);
    print('API Response: ${response.body}'); // Log the response
    final Map decodedBody = jsonDecode(response.body);
    return DailyDTO.fromJson(decodedBody['daily']);
  }

  static Future<Map<String, dynamic>> getCurrentWeather({required double latitude, required double longitude}) async {
    final url = Uri.https(
      'api.open-meteo.com',
      'v1/forecast',
      {
        'latitude': latitude.toString(),
        'longitude': longitude.toString(),
        'current': ['temperature_2m', 'weather_code'],
      },
    );
    final http.Response response = await http.get(url);
    final Map decodedBody = jsonDecode(response.body);
    return decodedBody['current'];
  }

  static Future<String> getLocationName(
      {required double latitude, required double longitude}) async {
    final url = Uri.https(
      'geocoding-api.open-meteo.com',
      'v1/search',
      {
        'name': 'Limassol',
        'latitude': latitude.toString(),
        'longitude': longitude.toString(),
        'count': '1',
        'language': 'en',
        'format': 'json',
      },
    );
    final http.Response response = await http.get(url);
    final Map decodedBody = jsonDecode(response.body);
    if (decodedBody['results'] != null && decodedBody['results'].isNotEmpty) {
      return decodedBody['results'][0]['name'];
    }
    return 'Unknown Location';
  }

  static Future<Map<String, dynamic>> getWeatherDetails({
    required double latitude,
    required double longitude,
  }) async {
    // Fetch hourly weather data
    final weatherUrl = Uri.https('api.open-meteo.com', 'v1/forecast', {
      'latitude': latitude.toString(),
      'longitude': longitude.toString(),
      'hourly': 'precipitation_probability,relative_humidity_2m,wind_speed_10m',
    });

    // Fetch air quality data
    final airQualityUrl =
        Uri.https('air-quality-api.open-meteo.com', 'v1/air-quality', {
      'latitude': latitude.toString(),
      'longitude': longitude.toString(),
      'hourly': 'pm10,pm2_5',
    });

    //     final http.Response response = await http.get(weatherUrl);
//     final airQualityResponse = await http.get(airQualityUrl);
//     final Map decodedBody = jsonDecode(response.body);
//     return decodedBody['current'];
//   }
// }

    try {
      // Fetch weather data
      final weatherResponse = await http.get(weatherUrl);
      // Fetch air quality data
      final airQualityResponse = await http.get(airQualityUrl);

      if (weatherResponse.statusCode == 200 &&
          airQualityResponse.statusCode == 200) {
        final Map<String, dynamic> weatherData =
            jsonDecode(weatherResponse.body);
        final Map<String, dynamic> airQualityData =
            jsonDecode(airQualityResponse.body);

        // Extract hourly weather data
        final Map<String, dynamic>? hourlyWeather = weatherData['hourly'];
        final Map<String, dynamic>? hourlyAirQuality = airQualityData['hourly'];

        if (hourlyWeather != null && hourlyAirQuality != null) {
          // Get the latest values from the hourly data
          final List<dynamic> precipitation =
              hourlyWeather['precipitation_probability'] ?? [];
          final List<dynamic> humidity =
              hourlyWeather['relative_humidity_2m'] ?? [];
          final List<dynamic> windSpeed = hourlyWeather['wind_speed_10m'] ?? [];
          final List<dynamic> pm10 = hourlyAirQuality['pm10'] ?? [];
          final List<dynamic> pm2_5 = hourlyAirQuality['pm2_5'] ?? [];

          return {
            'precipitation':
                precipitation.isNotEmpty ? precipitation.last : 0.0,
            'humidity': humidity.isNotEmpty ? humidity.last : 0.0,
            'wind_speed_10m': windSpeed.isNotEmpty ? windSpeed.last : 0.0,
            'air_quality': pm10.isNotEmpty ? pm10.last : 0.0,
            // Use PM10 as air quality index
          };
        } else {
          throw Exception('Hourly data not found in API response');
        }
      } else {
        throw Exception(
            'Failed to load data: Weather (${weatherResponse.statusCode}), Air Quality (${airQualityResponse.statusCode})');
      }
    } catch (e) {
      throw Exception('Failed to fetch weather details: $e');
    }
  }
}
