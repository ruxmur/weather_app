import '../../../features/home/state/day_model.dart';

class WeatherDayModel extends DayModel {
  final double feelsLike;

  WeatherDayModel({
    required super.date,
    required super.minTemperature,
    required super.maxTemperature,
    required super.uvIndex,
    required super.weatherCode,
    required this.feelsLike,
  });
}