import 'package:flutter/material.dart';

import '../../../styles/styles.dart';
import '../../home/state/models/city_model.dart';

Widget buildFiveDayForecastButton(BuildContext context) {
  final city = ModalRoute.of(context)!.settings.arguments as CityModel;
  return ElevatedButton(
    onPressed: () {
      Navigator.pushNamed(context, '/weather', arguments: city);
    },
    style: ElevatedButton.styleFrom(
      backgroundColor: Colors.transparent,
      foregroundColor: Colors.white,
    ),
    child: const Text(
      'see more',
      style: locationButtonTextStyle,
    ),
  );
}