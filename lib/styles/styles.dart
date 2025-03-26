import 'package:flutter/material.dart';

// --- Home screen styles --- //
BoxDecoration homeBackground = BoxDecoration(
  image: DecorationImage(
    image: AssetImage('assets/images/pic.png'),
    fit: BoxFit.cover,
    colorFilter: ColorFilter.mode(
      Colors.black.withOpacity(0.4),
      BlendMode.lighten,
    ),
  ),
);

const EdgeInsets homePadding = EdgeInsets.symmetric(
  horizontal: 20,
  vertical: 10,
);

// --- Location section styles --- //
const TextStyle locationTextStyle = TextStyle(
  fontSize: 37,
  fontWeight: FontWeight.bold,
  color: Colors.black,
);

// --- Current temperature section styles --- //
const TextStyle temperatureTextStyle = TextStyle(
  fontSize: 70,
  fontWeight: FontWeight.bold,
  color: Colors.black,
);

const TextStyle degreeTextStyle = TextStyle(
  fontSize: 30,
  fontWeight: FontWeight.bold,
  color: Colors.black,
);

// --- Weather condition styles --- //
const TextStyle weatherConditionTextStyle = TextStyle(
  fontSize: 34,
  fontWeight: FontWeight.bold,
  color: Colors.black,
);

// --- Location button styles --- //
const TextStyle locationButtonTextStyle = TextStyle(
  fontSize: 16,
  color: Colors.white,
);

// --- Temperature forecast text styles --- //
const TextStyle temperatureForecastTextStyle = TextStyle(
  fontSize: 22,
  color: Colors.black,
);
