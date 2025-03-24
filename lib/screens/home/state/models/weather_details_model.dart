class WeatherDetailsModel {
  final double precipitation;
  final double humidity;
  final double windSpeed;
  final double airQuality;

  WeatherDetailsModel({
    required this.precipitation,
    required this.humidity,
    required this.windSpeed,
    required this.airQuality,
  });

  factory WeatherDetailsModel.fromJson(Map<String, dynamic> json) {
    return WeatherDetailsModel(
      precipitation: (json['precipitation'] as num).toDouble(),
      humidity: (json['humidity'] as num).toDouble(),
      windSpeed: (json['wind_speed_10m'] as num).toDouble(),
      airQuality: (json['air_quality'] as num).toDouble(),
    );
  }
}