import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:intl/intl.dart';
import 'package:weather_application/screens/weather/weather_screen_components/weather_condition.dart';
import '../../core/repo/repository_weather.dart';
import '../../core/utils_test/weather_utils.dart';
import '../../styles/styles.dart';
import '../home/state/models/city_model.dart';
import '../home/state/models/day_model.dart';
import '../home/state/models/weather_details_model.dart';
import '../home/state/weather_provider.dart';
import 'package:provider/provider.dart';

class Weather extends StatefulWidget {
  final CityModel city;

  const Weather({super.key, required this.city});

  @override
  State<Weather> createState() => _WeatherState();
}

class _WeatherState extends State<Weather> with SingleTickerProviderStateMixin {
  final DateTime currentTime = DateTime.now();
  int _currentIndex = 0;
  WeatherDetailsModel? _weatherDetailsModel;
  bool _isLoading = true; // Add a loading state
  String _errorMessage = '';

  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _fetchWeatherDetails();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _fetchWeatherDetails() async {
    try {
      final weatherDetails = await RepositoryWeather.getWeatherDetails(
        latitude: widget.city.latitude,
        longitude: widget.city.longitude,
      );
      setState(() {
        _weatherDetailsModel = WeatherDetailsModel.fromJson(weatherDetails);
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Failed to load weather details: ${e.toString()}';
        _isLoading = false;

        // Set default values to prevent null errors
        _weatherDetailsModel = WeatherDetailsModel(
          precipitation: 0,
          humidity: 0,
          windSpeed: 0,
          airQuality: 0,
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final weatherProvider = Provider.of<WeatherProvider>(context);
    final currentWeather = weatherProvider.currentTemperature;
    final feelsLike = weatherProvider.feelsLikeTemperature;
    final currentWeatherCode = weatherProvider.currentWeatherCode;
    final days = weatherProvider.days; // This will be List<WeatherDayModel>
    final weatherIconData = getWeatherIconData(currentTime, currentWeatherCode);

    if (_isLoading) {
      return Scaffold(
        body: Center(
          child: CircularProgressIndicator(), // Show loading indicator
        ),
      );
    }

    return Scaffold(
      backgroundColor: Colors.grey[300],
      body: SingleChildScrollView(
        child: Column(
          children: [
            Text(
              // todo adjust the time according to the city time
              '${widget.city.name}   ${currentTime.hour}:${currentTime.minute
                  .toString().padLeft(2, '0')}',
              style: TextStyle(
                fontSize: 23,
                color: Colors.black,
              ),
            ),
            Container(
              height: 300,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.white,
                    Colors.black54,
                  ],
                  begin: Alignment.bottomLeft,
                  end: Alignment.topLeft,
                ),
              ),
              child: SafeArea(
                child: Padding(
                  padding: homePadding,
                  child: Row(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Weather',
                            style: TextStyle(
                              fontSize: 25,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          Text(
                            'Now',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          Row(
                            children: [
                              // Real weather for the selected city
                              Text(
                                '${currentWeather.toStringAsFixed(1)}º',
                                style: TextStyle(
                                  fontSize: 45,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              Icon(
                                weatherIconData.icon,
                                color: weatherIconData.color,
                                size: 45,
                              ),
                            ],
                          ),
                          // Feeling weather
                          Text(
                            'Feels like ${feelsLike.round().toString()}º',
                            style: TextStyle(
                              fontSize: 20,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),

                      // Spacer to push the next column to the right
                      Spacer(),

                      // Right Column
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        mainAxisAlignment: MainAxisAlignment.center,
                        // Align vertically
                        children: [
                          buildWeatherCondition(WeatherUtils.getWeatherTypeFromCode(currentWeatherCode)),
                          Text(
                            'Precipitation: ${_weatherDetailsModel?.precipitation.toStringAsFixed(1)}%',
                            style: TextStyle(
                              fontSize: 20,
                              color: Colors.white,
                            ),
                          ),
                          Text(
                            'Humidity: ${_weatherDetailsModel?.humidity.toStringAsFixed(1)}%',
                            style: TextStyle(
                              fontSize: 20,
                              color: Colors.white,
                            ),
                          ),
                          Text(
                            'Wind: ${_weatherDetailsModel?.windSpeed.toStringAsFixed(1)} km/h',
                            style: TextStyle(
                              fontSize: 20,
                              color: Colors.white,
                            ),
                          ),
                          Text(
                            'Air quality: ${_getAirQualityDescription(_weatherDetailsModel?.airQuality ?? 0)}',
                            style: TextStyle(
                              fontSize: 20,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),

            SizedBox(height: 20),
            // TabBar placed here
            Column(
              children: [
                TabBar(
                  controller: _tabController,
                  tabs: const [
                    Tab(text: 'Review'),
                    Tab(text: 'Precipitations'),
                    Tab(text: 'Wind'),
                    Tab(text: 'Humidity'),
                  ],
                  // indicator: BoxDecoration(
                  //   borderRadius: BorderRadius.circular(5), // Add borderRadius here
                  //   color: Colors.blueAccent.withOpacity(0.3), // Background color of the selected tab
                  // ),
                  labelColor: Colors.black, // Text color of the selected tab
                  unselectedLabelColor: Colors.black, // Text color of the unselected tabs
                  labelStyle: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                  unselectedLabelStyle: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.normal,
                  ),
                ),
                SizedBox(
                  height: 170, // Fixed height for the TabBarView
                  child: TabBarView(
                    controller: _tabController,
                    children: [
                      // Tab 1: Review
                      _buildHourlyForecast(currentWeatherCode, currentWeather),
                      // Tab 2: Precipitations
                      _buildPrecipitationForecast(),
                      // Tab 3: Wind
                      _buildWindForecast(),
                      // Tab 4: Humidity
                      _buildHumidityChart(),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),
            CarouselSlider(
              items: weatherProvider.days.take(10).map((day) {
                return Builder(
                  builder: (BuildContext context) {
                    return buildWeatherForecastItem(day);
                  },
                );
              }).toList(),
              options: CarouselOptions(
                height: 130, // Fixed height for the carousel
                enlargeCenterPage: false, // Make the center item slightly larger if it's true
                aspectRatio: 16 / 9, // Aspect ratio of each item
                autoPlayCurve: Curves.fastOutSlowIn, // Smooth scrolling animation
                enableInfiniteScroll: false, // Disable infinite scrolling
                autoPlayAnimationDuration: Duration(milliseconds: 800), // Animation duration
                viewportFraction: 0.2, // Fraction of the viewport each item occupies
                padEnds: false, // Remove padding at the ends
                onPageChanged: (index, reason) {
                  setState(() {
                    _currentIndex = index; // Update the current index
                  });
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Tab 1: Review
  Widget _buildHourlyForecast(int weatherCode, double temperature) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          for (var i = 0; i < 24; i++)
            Padding(
              padding: EdgeInsets.fromLTRB(5, 40, 15, 15),
              child: Column(
                children: [
                  Text('${(currentTime.hour + i) % 24}:00'),
                  SizedBox(height: 10),
                  // 24-hour forecast
                  Builder(
                    builder: (context) {
                      final hourTime = currentTime.add(Duration(hours: i));
                      final hourlyWeatherIconData = getWeatherIconData(hourTime, weatherCode);
                      return Icon(
                        hourlyWeatherIconData.icon,
                        color: hourlyWeatherIconData.color,
                        size: 40,
                      );
                    },
                  ),
                  SizedBox(height: 10),
                  Text('${temperature.toStringAsFixed(1)}º'),
                  // Temperature for each hour
                ],
              ),
            ),
        ],
      ),
    );
  }

  // Tab 2: Precipitations
  Widget _buildPrecipitationForecast() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          for (var i = 0; i < 24; i++)
            Padding(
              padding: EdgeInsets.fromLTRB(5, 40, 15, 15),
              child: Column(
                children: [
                  Text('${(currentTime.hour + i) % 24}:00'),
                  SizedBox(height: 10),
                  Icon(
                    Icons.water_drop,
                    size: 40,
                    color: Colors.blueAccent.withOpacity(0.3),
                  ),
                  SizedBox(height: 10),
                  Text('${_weatherDetailsModel?.precipitation.toStringAsFixed(1)}%'),
                ],
              ),
            ),
        ],
      ),
    );
  }

// Tab 3: Wind
  Widget _buildWindForecast() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          for (var i = 0; i < 24; i++)
            Padding(
              padding: EdgeInsets.fromLTRB(5, 40, 15, 15),
              child: Column(
                children: [
                  Text('${(currentTime.hour + i) % 24}:00'),
                  SizedBox(height: 10),
                  Icon(
                    Icons.arrow_forward_rounded,
                    size: 40,
                    color: Colors.blueAccent.withOpacity(0.5),
                  ),
                  SizedBox(height: 10),
                  Text('${_weatherDetailsModel?.windSpeed.toStringAsFixed(1)} km/h'),
                ],
              ),
            ),
        ],
      ),
    );
  }

// Tab 4: Humidity (Chart)
  Widget _buildHumidityChart() {
    // Placeholder for a humidity chart
    return Center(
      child: Text(
        'Humidity Chart Placeholder',
      ),
    );
  }
}

String _getAirQualityDescription(double airQualityIndex) {
  if (airQualityIndex <= 10) return 'Good';
  if (airQualityIndex >= 10 && airQualityIndex <= 20) return 'Fair';
  if (airQualityIndex >= 20 && airQualityIndex <= 25) return 'Moderate';
  if (airQualityIndex >= 25 && airQualityIndex <= 50) return 'Poor';
  if (airQualityIndex >= 50 && airQualityIndex <= 75) return 'Very poor';
  if (airQualityIndex >= 75 && airQualityIndex <= 800) return 'Extremely poor';
  return 'Hazardous';
}

Widget buildWeatherForecastItem(DayModel day) {
  return Container(
    width: 70,
    // Fixed width
    height: 130,
    // Fixed height
    margin: EdgeInsets.all(5),
    // Add spacing between items
    decoration: BoxDecoration(
      // color: Colors.white.withOpacity(0.3), // Transparent container
      color: Colors.blueAccent.withOpacity(0.2), // Transparent container
      borderRadius: BorderRadius.circular(10), // Rounded corners
    ),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Day of the week
        Text(
          DateFormat('E').format(day.date),
          // Abbreviated day name (e.g., "Mon")
          style: TextStyle(
            fontSize: 16,
            color: Colors.black,
          ),
        ),
        SizedBox(height: 8), // Add spacing
        // Weather icon
        Builder(
          builder: (context) {
            final iconData = getWeatherIconData(day.date, day.weatherCode);
            return Icon(
              iconData.icon,
              color: iconData.color,
              size: 40,
            );
          },
        ),
        SizedBox(height: 8), // Add spacing
        // Max and min temperature
        Text(
          '${day.maxTemperature.toInt()}°/${day.minTemperature.toInt()}°',
          style: TextStyle(
            fontSize: 14,
            color: Colors.black,
          ),
        ),
      ],
    ),
  );
}

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
  IconData icon;
  switch (weatherCode) {
    case 0: // Clear sky
      // todo to use icons like this Image.asset(WeatherUtils.getWeatherIconFromCode(weatherCode))
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
    case 56: // Light freezing drizzle
    case 57: // Dense freezing drizzle
      icon = Icons.grain;
      break;
    case 61: // Slight rain
    case 63: // Moderate rain
    case 65: // Heavy rain
    case 66: // Light freezing rain
    case 67: // Heavy freezing rain
    case 80: // Slight rain showers
    case 81: // Moderate rain showers
    case 82: // Violent rain showers
      icon = Icons.beach_access;
      break;
    case 71: // Slight snow fall
    case 73: // Moderate snow fall
    case 75: // Heavy snow fall
    case 77: // Snow grains
    case 85: // Slight snow showers
    case 86: // Heavy snow showers
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
      case 0: // Clear sky
        color = Colors.yellow;
        break;
      case 1: // Mainly clear
      case 2: // Partly cloudy
        color = Colors.orange.withOpacity(0.6);
        break;
      case 3: // Overcast
        color = Colors.blueGrey;
        break;
      case 45: // Fog
      case 48: // Fog
        color = Colors.grey;
        break;
      case 51: // Drizzle
      case 53: // Drizzle
      case 55: // Drizzle
        color = Colors.lightBlue;
        break;
      case 61: // Rain
      case 63: // Rain
      case 65: // Rain
        color = Colors.blue;
        break;
      case 71: // Snow
      case 73: // Snow
      case 75: // Snow
        color = Colors.white;
        break;
      case 95: // Thunderstorm
      case 96: // Thunderstorm
      case 99: // Thunderstorm
        color = Colors.deepPurple;
        break;
      default:
        color = Colors.blueGrey;
    }
  }

  return WeatherIconData(icon, color);
}