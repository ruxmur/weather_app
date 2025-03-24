class DailyDTO {
  final List<DateTime> time;
  final List<double> temperature2mMin;
  final List<double> temperature2mMax;
  final List<double>? apparentTemperature;
  final List<double> uvIndexMax;
  final List<int> weatherCode;

  DailyDTO({
    required this.time,
    required this.temperature2mMin,
    required this.temperature2mMax,
    this.apparentTemperature,
    required this.uvIndexMax,
    required this.weatherCode,
  });

  // refactored with '.map()' approach, because with 'cast<T>() + _dateTimeParser()'
  // no null check for 'apparentTemperature', and '.map()' parse 'time' directly
  factory DailyDTO.fromJson(Map<String, dynamic> json) {
    return DailyDTO(
      // json['time'].map((x) => DateTime.parse(x)) converts each item in time to a DateTime.
      time: List<DateTime>.from(json['time'].map((x) => DateTime.parse(x))),
      temperature2mMax: List<double>.from(json['temperature_2m_max'].map((x) => x.toDouble())),
      temperature2mMin: List<double>.from(json['temperature_2m_min'].map((x) => x.toDouble())),
      apparentTemperature: json['apparent_temperature_max'] != null
          ? List<double>.from(json['apparent_temperature_max'].map((x) => x.toDouble()))
          : null, // Add this
      uvIndexMax: List<double>.from(json['uv_index_max'].map((x) => x.toDouble())),
      weatherCode: List<int>.from(json['weather_code'].map((x) => x)),
    );
  }
}