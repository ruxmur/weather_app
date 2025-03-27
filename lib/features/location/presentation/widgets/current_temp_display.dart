import 'package:flutter/material.dart';

import '../../../../styles/styles.dart';

Widget buildCurrentTemperatureSection(double currentTemperature) {
  return SizedBox(
    width: 140,
    height: 140,
    child: Stack(
      children: [
        Align(
          alignment: Alignment.center,
          child: Text(
            currentTemperature.round().toString(),
            style: temperatureTextStyle,
          ),
        ),
        Align(
          alignment: Alignment.topRight,
          child: Text(
            'ºC',
            style: degreeTextStyle,
          ),
        ),
      ],
    ),
  );
}