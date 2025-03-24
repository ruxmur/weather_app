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

      print('Weather Details: $weatherDetails'); // Log the API response

      setState(() {
        _weatherDetailsModel = WeatherDetailsModel(
          precipitation: (weatherDetails['precipitation'] as num).toDouble(),
          humidity: (weatherDetails['humidity'] as num).toDouble(),
          windSpeed: (weatherDetails['wind_speed_10m'] as num).toDouble(),
          airQuality: (weatherDetails['air_quality'] as num).toDouble(),
        );
        _isLoading = false; // Set loading to false
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Failed to load weather details: $e';
        _isLoading = false; // Set loading to false
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final weatherProvider = Provider.of<WeatherProvider>(context);
    final currentWeather = weatherProvider.currentTemperature;
    final currentWeatherCode = weatherProvider.currentWeatherCode;
    final days = weatherProvider.days;
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
                            'Feels like ${currentWeather.round().toString()}º',
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
                height: 130,
                // Fixed height for the carousel
                enlargeCenterPage: false,
                // Make the center item slightly larger if it's true
                aspectRatio: 16 / 9,
                // Aspect ratio of each item
                autoPlayCurve: Curves.fastOutSlowIn,
                // Smooth scrolling animation
                enableInfiniteScroll: false,
                // Disable infinite scrolling
                autoPlayAnimationDuration: Duration(milliseconds: 800),
                // Animation duration
                viewportFraction: 0.2,
                // Fraction of the viewport each item occupies
                padEnds: false,
                // Remove padding at the ends
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
                  // Image.asset(
                  //   WeatherUtils.getWeatherIconFromCode(weatherCode),
                  //   width: 40,
                  //   height: 40,
                  // ),
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

  // Horizontal Carousel
  //  final List<String> images = [
  // 'https://math-media.byjusfutureschool.com/bfs-math/2022/07/04185630/Asset-2-6-300x300.png',
  // 'https://math-media.byjusfutureschool.com/bfs-math/2022/07/04185630/Asset-2-6-300x300.png',
  // 'https://math-media.byjusfutureschool.com/bfs-math/2022/07/04185630/Asset-2-6-300x300.png',
  // 'https://math-media.byjusfutureschool.com/bfs-math/2022/07/04185630/Asset-2-6-300x300.png',
  //   ];
  // CarouselSlider(
  //   //images.map((image) { ... }): <- images is a list of
  //   // image URLs (or local asset paths).
  //   // The map function iterates over each item in the
  //   // images list and applies a transformation to it.
  //   // For each image in the list, it returns a Container widget.
  //   // toList():
  //   // Converts the result of map (an iterable) into a
  //   // List<Widget>, which is required by the items property.
  //   // items: <- A list of widgets to display in the carousel.
  //   items: images.map((image) {
  //     //For each image in the images list, a Container widget is returned.
  //     // This Container represents a single item in the carousel.
  //     return Container(
  //       margin: EdgeInsets.all(5),
  //       //create spacing between carousel items
  //       decoration: BoxDecoration(
  //         //Defines the visual appearance of the Container
  //         borderRadius: BorderRadius.circular(10),
  //         image: DecorationImage(
  //           image: NetworkImage(image),
  //           fit: BoxFit.cover,
  //         ),
  //       ),
  //     );
  //   }).toList(),
  //   options: CarouselOptions(
  //     height: 100,
  //     // autoPlay: true,
  //     // Makes the center item slightly larger than the
  //     // others, creating a "focus" effect.
  //     enlargeCenterPage: true,
  //     // Sets the aspect ratio of each carousel
  //     // item (width to height ratio).
  //     aspectRatio: 16 / 9,
  //     // Defines the animation curve for auto-scrolling.
  //     // Curves.fastOutSlowIn creates a smooth
  //     // acceleration and deceleration effect.
  //     autoPlayCurve: Curves.fastOutSlowIn,
  //     // Allows the carousel to loop back to the first
  //     // item after reaching the last item.
  //     enableInfiniteScroll: true,
  //     autoPlayAnimationDuration: Duration(milliseconds: 800),
  //     // Defines the fraction of the viewport that each
  //     // item occupies. A value of 0.8 means each item
  //     // takes up 80% of the carousel's width.
  //     viewportFraction: 0.8,
  //     // A callback function that is triggered when the
  //     // user swipes to a new item or the carousel auto-scrolls.
  //     onPageChanged: (index, reason) {
  //       setState(() {
  //         // Updates the _currentIndex variable to reflect
  //         // the currently visible item in the carousel.
  //         // This is useful for displaying indicators
  //         // (e.g., dots) that show the current position.
  //         _currentIndex = index;
  //       });
  //     },
  //   ),
  // ),

  // Indicators for the Carousel (....)
  // Row(
  //   mainAxisAlignment: MainAxisAlignment.center,
  //   children: images.map((image) {
  //     int index = images.indexOf(image);
  //     return Container(
  //       width: 8,
  //       height: 8,
  //       margin: EdgeInsets.symmetric(vertical: 10, horizontal: 4),
  //       decoration: BoxDecoration(
  //         shape: BoxShape.circle,
  //         color: _currentIndex == index ? Colors.black : Colors.grey,
  //       ),
  //     );
  //   }).toList(),
  // ),
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
      color: Colors.blueAccent.withOpacity(0.3), // Transparent container
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
        Image.asset(
          WeatherUtils.getWeatherIconFromCode(day.weatherCode),
          width: 40,
          height: 40,
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

  // Determine icon
  IconData icon;
  switch (weatherCode) {
    case 3: // Clear sky
      icon = isDayTime ? Icons.wb_sunny : Icons.nightlight_round;
      break;
    case 80: // Cloudy
      icon = isDayTime ? Icons.cloud : Icons.cloud_outlined;
      break;
    default:
      icon = isDayTime ? Icons.cloud_queue : Icons.nights_stay;
  }

  // Determine color
  Color color;
  if (isNight) {
    color = const Color.fromARGB(237, 7, 37, 104); // Nighttime color
  } else {
    switch (weatherCode) {
      case 800: // Clear sky
        color = Colors.yellow;
        break;
      case 801: // Few clouds
        color = Colors.orange;
        break;
      case 802: // Scattered clouds
        color = Colors.grey;
        break;
      case 803:
      case 804: // Overcast clouds
        color = Colors.blueGrey;
        break;
      case 500: // Light rain
      case 501: // Moderate rain
        color = Colors.lightBlue;
        break;
      case 502: // Heavy rain
      case 503:
      case 504:
        color = Colors.blue;
        break;
      case 600: // Light snow
      case 601: // Snow
        color = Colors.white;
        break;
      default:
        color = Colors.blueGrey; // Default color
    }
  }

  return WeatherIconData(icon, color);
}