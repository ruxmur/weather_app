import 'dart:convert';
import 'package:http/http.dart' as http;
import '../domain/weather/daily_dto.dart';

class WeatherRepository {
  static Future<DailyDTO> getWeather({required double latitude, required double longitude}) async {
    //https://api.open-meteo.com/v1/forecast?latitude=52.52&longitude=13.41&current=is_day&daily=weather_code,temperature_2m_max,temperature_2m_min,uv_index_max
    final url = Uri.https('api.open-meteo.com', 'v1/forecast', {
      'latitude': latitude.toString(),
      'longitude': longitude.toString(),
      'daily': [
        'weather_code',
        'temperature_2m_max',
        'temperature_2m_min',
        'apparent_temperature_max',
        'uv_index_max',
      ],
    });
    final response = await http.get(url);
    final Map decodedBody = jsonDecode(response.body);
    return DailyDTO.fromJson(decodedBody['daily']);
  }

  static Future<DailyDTO> getBasicWeather({required double latitude, required double longitude,}) async {
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
    final response = await http.get(url);
    final Map decodedBody = jsonDecode(response.body);
    return DailyDTO.fromJson(decodedBody['daily']);
  }

  static Future<Map<String, dynamic>> getCurrentWeather({required double latitude, required double longitude}) async {
    final url = Uri.https('api.open-meteo.com', 'v1/forecast', {
      'latitude': latitude.toString(),
      'longitude': longitude.toString(),
      'current': ['temperature_2m', 'weather_code'],
    });
    final http.Response response = await http.get(url);
    final Map decodedBody = jsonDecode(response.body);
    return decodedBody['current'];
  }

  static Future<String> getLocationName({required double latitude, required double longitude}) async {
    final url = Uri.https('geocoding-api.open-meteo.com', 'v1/search', {
      'name': 'Limassol',
      'latitude': latitude.toString(),
      'longitude': longitude.toString(),
      'count': '1',
      'language': 'en',
      'format': 'json',
    });
    final http.Response response = await http.get(url);
    final Map decodedBody = jsonDecode(response.body);
    if (decodedBody['results'] != null && decodedBody['results'].isNotEmpty) {
      return decodedBody['results'][0]['name'];
    }
    return 'Unknown Location';
  }

  static Future<Map<String, dynamic>> getWeatherDetails({required double latitude, required double longitude,}) async {
    try {
      // Fetch hourly weather data
      final weatherUrl = Uri.https('api.open-meteo.com', 'v1/forecast', {
        'latitude': latitude.toString(),
        'longitude': longitude.toString(),
        'current': [
          'temperature_2m',
          'relative_humidity_2m',
          'precipitation',
          'wind_speed_10m',
          'weather_code',
        ],
        'hourly': 'precipitation_probability',
      });

      final airQualityUrl = Uri.https('air-quality-api.open-meteo.com', 'v1/air-quality', {
        'latitude': latitude.toString(),
        'longitude': longitude.toString(),
        'current': 'european_aqi', // European Air Quality Index (instead of raw PM10)
      });

      // Execute both requests concurrently
      final responses = await Future.wait([http.get(weatherUrl), http.get(airQualityUrl)]);

      final weatherResponse = responses[0];
      final airQualityResponse = responses[1];

      if (weatherResponse.statusCode == 200 && airQualityResponse.statusCode == 200) {
        final weatherData = jsonDecode(weatherResponse.body);
        final airQualityData = jsonDecode(airQualityResponse.body);

        // Extract current weather data (not hourly)
        final currentWeather = weatherData['current'];
        final currentAirQuality = airQualityData['current'];

        return {
          'precipitation': (currentWeather['precipitation'] ?? 0.0).toDouble(),
          'humidity': (currentWeather['relative_humidity_2m'] ?? 0.0).toDouble(),
          'wind_speed_10m': (currentWeather['wind_speed_10m'] ?? 0.0).toDouble(),
          'air_quality': (currentAirQuality['european_aqi'] ?? 0.0).toDouble(),
        };
      } else {
        throw Exception(
          'Failed to load data: Weather (${weatherResponse.statusCode}), Air Quality (${airQualityResponse.statusCode})'
        );
      }
    } catch (e) {
      throw Exception('Failed to fetch weather details: $e');
    }
  }

  static Future<List<double>> getHourlyHumidity({required double latitude, required double longitude}) async {
    final url = Uri.https('api.open-meteo.com', 'v1/forecast', {
      'latitude': latitude.toString(),
      'longitude': longitude.toString(),
      'hourly': 'relative_humidity_2m',
    });

    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final Map<String, dynamic> decodedBody = jsonDecode(response.body);

        if (decodedBody['hourly'] != null &&
            decodedBody['hourly']['relative_humidity_2m'] != null) {
          final List<dynamic> humidityList = decodedBody['hourly']['relative_humidity_2m'];
          return humidityList.map<double>((e) => e?.toDouble() ?? 0.0).toList();
        }
      }
      return List.filled(24, 0.0);
    } catch (e) {
      return List.filled(24, 0.0);
    }
  }
}
