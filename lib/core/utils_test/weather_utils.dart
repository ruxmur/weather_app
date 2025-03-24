enum WeatherType { sunnyRainy, clear, cloudy, rainy, stormy, sunny,}

class WeatherUtils {
  // Convert string to WeatherType
  static WeatherType getWeatherTypeFromString(String weather) {
    switch (weather.toLowerCase()) {
      case 'sunny-rainy':
        return WeatherType.sunnyRainy;
      case 'clear':
        return WeatherType.clear;
      case 'cloudy':
        return WeatherType.cloudy;
      case 'rainy':
        return WeatherType.rainy;
      case 'stormy':
        return WeatherType.stormy;
      default:
        return WeatherType.sunny;
    }
  }

  // Get weather icon path based on WeatherType
  static String getWeatherIcon(WeatherType weather) {
    switch (weather) {
      case WeatherType.sunnyRainy:
        return 'assets/icons/sunny_rainy.png';
      case WeatherType.cloudy:
        return 'assets/icons/cloudy.png';
      case WeatherType.rainy:
        return 'assets/icons/rainy.png';
      case WeatherType.stormy:
        return 'assets/icons/storm.png';
      default:
        return 'assets/icons/sunny.png';
    }
  }

  // Convert int to WeatherType
  static WeatherType getWeatherTypeFromCode(int weatherCode) {
    // Map weather codes to WeatherType
    if (weatherCode == 0) {
      return WeatherType.clear;
    } else if (weatherCode == 1) {
      return WeatherType.sunny;
    } else if (weatherCode >= 2 && weatherCode <= 48) {
      return WeatherType.cloudy;
    } else if (weatherCode >= 51 && weatherCode <= 67) {
      return WeatherType.rainy;
    } else if (weatherCode >= 95 && weatherCode <= 99) {
      return WeatherType.stormy;
    } else {
      return WeatherType.sunnyRainy;
    }
  }

  // This method takes an int (weather code) as input, and converts
  // the weather code into a WeatherType using getWeatherTypeFromCode,
  // then it fetches the corresponding icon path using getWeatherIcon.
  static String getWeatherIconFromCode(int weatherCode) {
    final weatherType = getWeatherTypeFromCode(weatherCode);
    return getWeatherIcon(weatherType);
  }

  // Combined method to get icon directly from string (kept for backward compatibility)
  // This method takes a String (weather description) as input,
  // and converts the weather description into a WeatherType using
  // getWeatherTypeFromString, then, it fetches the corresponding
  // icon path using getWeatherIcon.
  static String getWeatherIconFromString(String weather) {
    final weatherType = getWeatherTypeFromString(weather);
    return getWeatherIcon(weatherType);
  }
  // why don’t just combine these methods into one:
  // The reason is separation of concerns and flexibility:
  // - Separation of Concerns:
  // The getWeatherIconFromCode method is specifically designed
  // to handle weather codes (e.g., 0 for sunny, 1 for cloudy, etc.),
  // which are typically returned by weather APIs.
  // The getWeatherIconFromString method is designed to handle
  // human-readable weather descriptions (e.g., "sunny", "cloudy", etc.),
  // which might come from user input or other sources.
  // - Flexibility:
  // By keeping these methods separate, you can handle both types of
  // inputs without needing to convert one into the other. For example:
  // If you receive a weather code from an API, you can directly use getWeatherIconFromCode.
  // If you have a weather description from a user or a hardcoded value,
  // you can use getWeatherIconFromString.
}

