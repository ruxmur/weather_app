import 'package:flutter/material.dart';

import '../../../../styles/styles.dart';

Widget buildCurrentTemperatureSection(double currentTemperature) {
  return SizedBox(
    width: 140,
    height: 176,
    child: Stack(
      children: [
        // if (state.days.isNotEmpty)
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