import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:weather_application/screens/home/state/models/city_model.dart';
import 'package:weather_application/screens/home/state/models/day_model.dart';

import '../../core/models/daily_dto.dart';
import '../../core/repo/repository_weather.dart';

class Home2 extends StatefulWidget {
  const Home2({super.key});

  @override
  State<Home2> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<Home2> {
  final List<CityModel> cities = [
    CityModel(
      latitude: 47.010452,
      longitude: 28.863810,
      name: 'Chisinau',
    ),
    CityModel(
      latitude: 48.035709,
      longitude: 27.806660,
      name: 'Drochia',
    ),
    CityModel(
      latitude: 34.680551,
      longitude: 33.048537,
      name: 'Limassol',
    ),
    CityModel(
      latitude: 52.520008,
      longitude: 13.404954,
      name: 'Berlin',
    ),
    CityModel(
      latitude: 37.532600,
      longitude: 127.024612,
      name: 'Seoul',
    ),
  ];

  CityModel currentCity = CityModel(
    latitude: 34.680551,
    longitude: 33.048537,
    name: 'Limassol',
  );
  List<DayModel> currentCityWeather = [];

  // add a controller for the search field
  // _ Underscore for class name - makes it private to the library
  final TextEditingController _searchController = TextEditingController();

  // add a global key for the form
  final _formKey = GlobalKey<FormState>();

  // dispose() is called when the widget is removed
  // from the widget tree.
  // It cleans up resources, such as disposing of the
  // TextEditingController to avoid memory leaks.
  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: RepositoryWeather.getWeather(
        latitude: currentCity.latitude,
        longitude: currentCity.longitude,
      ),
      builder: (context, snapshot) {
        if (snapshot.data != null) {
          _dailyDTOParcer(snapshot.data!);
        }

        return Scaffold(
          body: Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/sky.jpg'),
                fit: BoxFit.cover,
              ),
            ),
            child: SafeArea(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [

                    Icon(
                      Icons.location_on,
                      color: Colors.amber,
                      size: 35.0,
                    ),
                    Text(
                      currentCity.name,
                      style: TextStyle(
                        fontSize: 37.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(
                      width: 200,
                      height: 176,
                      child: Stack(
                        children: [
                          if (currentCityWeather.isNotEmpty)
                            Text(
                              currentCityWeather.first.maxTemperature
                                  .round()
                                  .toString(),
                              style: TextStyle(
                                fontSize: 161.0,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          Align(
                            alignment: Alignment.topRight,
                            child: Text(
                              'ºC',
                              style: TextStyle(
                                fontSize: 40.0,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 44),
                    if (currentCityWeather.isNotEmpty)
                      Text(
                        weatherCode(currentCityWeather.first.weatherCode),
                        style: TextStyle(
                          fontSize: 34.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),

                    if (currentCityWeather.isNotEmpty)
                      ...currentCityWeather.map((day) => dayWeather(
                          weather: weatherCode(day.weatherCode),
                          dayOfWeek: DateFormat('d MMM').format(day.date),
                          maxTemp: day.maxTemperature.toInt(),
                          minTemp: day.minTemperature.toInt(),
                          iconData: iconWeatherCode(day.weatherCode))),

                    Form(
                      key: _formKey,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: TextFormField(
                          controller: _searchController,
                          decoration: InputDecoration(
                            labelText: 'Search City',
                            hintText: 'Enter city name',
                            suffixIcon: IconButton(
                              onPressed: () {
                                _searchController.clear();
                              },
                              icon: Icon(Icons.close),
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter a city name';
                            }
                            return null;
                          },
                        ),
                      ),
                    ),
                    const SizedBox(height: 20,),

                    //When the user presses the "Search"
                    // button, the app checks if the entered
                    // city name matches any city in the cities list.
                    // If the city is found, the app updates the
                    // currentCity and fetches its weather data.
                    // If the city is not found, a SnackBar displays
                    // an error message.
                    ElevatedButton(
                      onPressed: () {
                        if(_formKey.currentState!.validate()) {
                          //if the form is valid, search for the city
                          final cityName = _searchController.text;
                          final city = cities.firstWhere(
                                (city) => city.name.toLowerCase() == cityName.toLowerCase(),
                            orElse: () => CityModel(
                              latitude: 0,
                              longitude: 0,
                              name: 'Unknown',
                            ),
                          );

                          if (city.name != 'Unknown') {
                            setState(() {
                              currentCity = city;
                            });
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('City not found')),
                            );
                          }
                        }
                      },
                      child: Text('Search'),
                    ),

                    const SizedBox(height: 24),
                    Container(
                      // width: 170,
                      decoration: BoxDecoration(
                        color: Colors.blueAccent[100], // Background color of the dropdown button
                        borderRadius: BorderRadius.circular(8),
                      ),
                      padding: EdgeInsets.symmetric(horizontal: 12),
                      child: DropdownButton<CityModel>(
                        dropdownColor: Colors.blueAccent[100], // Background color of the dropdown menu
                        icon: Icon(Icons.arrow_drop_down, color: Colors.white), // Dropdown icon color
                        style: TextStyle(
                          color: Colors.white, // Text color of the selected item
                          fontSize: 20,
                        ),
                        underline: SizedBox(), // Remove the default underline
                        items: cities.map((location) => DropdownMenuItem(
                          value: location,
                          child: Text(
                            location.name,
                            style: TextStyle(color: Colors.black), // Text color of dropdown items
                          ),
                        )).toList(),
                        onChanged: (city) {
                          if (city != null) {
                            setState(() {
                              currentCity = city;
                            });
                            Navigator.pushNamed(context, '/second', arguments: city);
                          }
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  void _dailyDTOParcer(DailyDTO dailyModel) {
    List<DayModel> days = [];
    for (var i = 0; i < dailyModel.time.length; i++) {
      days.add(DayModel(
        date: dailyModel.time[i],
        minTemperature: dailyModel.temperature2mMin[i],
        maxTemperature: dailyModel.temperature2mMax[i],
        uvIndex: dailyModel.uvIndexMax[i],
        weatherCode: dailyModel.weatherCode[i],
      ));
    }
    currentCityWeather = days;
  }

  String weatherCode(int code) {
    switch (code) {
      case 3:
        return 'Clear';
      case 80:
        return 'Cloudy';
      default:
        return 'Sunny';
    }
  }

  IconData iconWeatherCode(int code) {
    switch (code) {
      case 3:
        return Icons.sunny;
      case 80:
        return Icons.cloud;
      default:
        return Icons.cloud_queue_sharp;
    }
  }

  Widget dayWeather({
    required String weather,
    required String dayOfWeek,
    required int maxTemp,
    required int minTemp,
    required IconData iconData,
  }) {
    return Padding(
      padding: const EdgeInsets.only(
        left: 20,
        right: 20,
        bottom: 20,
      ),
    );
  }
}