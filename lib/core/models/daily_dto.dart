class DailyDTO {
  final List<DateTime> time;
  final List<int> weatherCode;
  final List<double> temperature2mMax;
  final List<double> temperature2mMin;
  final List<double> uvIndexMax;

  DailyDTO({
    required this.time,
    required this.weatherCode,
    required this.temperature2mMax,
    required this.temperature2mMin,
    required this.uvIndexMax,
  });

  factory DailyDTO.fromJson(Map<String, dynamic> json) {
    return DailyDTO(
      time: _dateTimeParser((json['time'] as List).cast<String>()),
      weatherCode: (json['weather_code'] as List).cast<int>(),
      temperature2mMax: (json['temperature_2m_max'] as List).cast<double>(),
      temperature2mMin: (json['temperature_2m_min'] as List).cast<double>(),
      uvIndexMax: (json['uv_index_max'] as List).cast<double>(),
    );
  }

  static List<DateTime> _dateTimeParser(List<String> input) =>
      input.map((date) => DateTime.parse(date)).toList();
}