import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:weather_application/core/domain/location/city.dart';
import 'package:weather_application/features/home/state/day_model.dart';
import 'package:weather_application/features/location/presentation/widgets/location_section.dart';
import '../../core/domain/weather/daily_dto.dart';
import '../../core/api/weather_repository.dart';
import '../../styles/styles.dart';
import '../location/presentation/widgets/current_temp_display.dart';
import '../../core/domain/providers/weather_provider.dart';
import 'presentation/widgets/city_search_field.dart';
import 'presentation/widgets/weather_condition.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final List<CityModel> cities = [
    CityModel(latitude: 47.010452, longitude: 28.863810, name: 'Chisinau'),
    CityModel(latitude: 55.953251, longitude: -3.188267, name: 'Edinburgh'),
    CityModel(latitude: 34.680551, longitude: 33.048537, name: 'Limassol'),
    CityModel(latitude: 52.520008, longitude: 13.404954, name: 'Berlin'),
    CityModel(latitude: 37.532600, longitude: 127.024612, name: 'Seoul'),
    CityModel(latitude: 50.000000, longitude: -85.000000, name: 'Ontario'),
  ];

  CityModel currentCity = CityModel(latitude: 34.680551, longitude: 33.048537, name: 'Limassol',);
  List<DayModel> currentCityWeather = [];

  // Key for the FutureBuilder (you can use directly 'UniqueKey()' in setState)
  UniqueKey _futureBuilderKey = UniqueKey();

  void _onCitySelected(CityModel city) {
    setState(() {
      currentCity = city;
      currentCityWeather = [];
      _futureBuilderKey = UniqueKey();
    });
    Navigator.pushNamed(context, '/second', arguments: city);
  }

  @override
  Widget build(BuildContext context) {
    final state = Provider.of<WeatherProvider>(context);

    return FutureBuilder(
      future: WeatherRepository.getBasicWeather(
        latitude: currentCity.latitude,
        longitude: currentCity.longitude,
      ),
      builder: (context, snapshot) {
        if (snapshot.data != null) {
          _dailyDTOParcer(snapshot.data!);
        }

        return Scaffold(
          body: Container(
            decoration: homeBackground,
            child: SafeArea(
              child: Padding(
                padding: homePadding,
                child: Column(
                  children: [
                    // Location Icon and City Name
                    buildLocationSection(currentCity.name),
                    // Current Temperature
                    buildCurrentTemperatureSection(state.currentTemperature),
                    const SizedBox(height: 44),
                    // Weather condition
                    getWeatherCondition(currentCityWeather),
                    // Search city field
                    CityField(
                      cities: cities,
                      onCitySelected: _onCitySelected,
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

  // convert a DailyDTO object into a list of DayModel
  // objects and store it in currentCityWeather
  // How it works:
  // Creates an empty list (days). ->
  // Iterates through dailyModel.time using a for loop. ->
  // Uses i as the index to access the values from dailyModel. ->
  // Adds each DayModel object to the days list. ->
  // Finally, assigns days to currentCityWeather.
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
}
