import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz_data;

class TimezoneUtils {
  static Future<void> initialize() async {
    tz_data.initializeTimeZones();
  }

  static Future<tz.Location> getLocationForCity(
      double latitude,
      double longitude, {
        String? cityName,
      }) async {
    // City-specific mappings
    if (cityName != null) {
      switch (cityName) {
        case 'Limassol': return tz.getLocation('Asia/Nicosia');
        case 'Berlin': return tz.getLocation('Europe/Berlin');
        case 'Seoul': return tz.getLocation('Asia/Seoul');
        case 'Chisinau': return tz.getLocation('Europe/Chisinau');
        case 'Edinburgh': return tz.getLocation('Europe/London');
        case 'Ontario': return tz.getLocation('America/Toronto');
      }
    }

    // Geographic fallbacks
    if (latitude >= 34.5 && latitude <= 35.5 && longitude >= 32 && longitude <= 34) {
      return tz.getLocation('Asia/Nicosia');
    }
    if (latitude >= 35 && longitude >= -10 && longitude <= 40) {
      return tz.getLocation('Europe/Paris');
    }
    if (latitude >= 40 && longitude >= -125 && longitude <= -65) {
      return tz.getLocation('America/New_York');
    }
    if (latitude >= 35 && longitude >= 100 && longitude <= 140) {
      return tz.getLocation('Asia/Tokyo');
    }
    if (latitude >= -35 && longitude >= 110 && longitude <= 155) {
      return tz.getLocation('Australia/Sydney');
    }

    return tz.getLocation('UTC');
  }

  static String formatTime(DateTime time) {
    return '${time.hour}:${time.minute.toString().padLeft(2, '0')}';
  }
}