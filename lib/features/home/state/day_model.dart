class DayModel {
  final DateTime date;
  final int weatherCode;
  final double minTemperature;
  final double maxTemperature;
  final double uvIndex;

  DayModel({
    required this.date,
    required this.weatherCode,
    required this.minTemperature,
    required this.maxTemperature,
    required this.uvIndex,
  });
}