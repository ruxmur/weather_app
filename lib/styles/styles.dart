import 'package:flutter/material.dart';

// --- Home screen styles --- //
const BoxDecoration homeBackground = BoxDecoration(
  // image: DecorationImage(
  //   image: NetworkImage('https://gifdb.com/images/thumbnail/funny-man-fighting-strong-wind-ebb1eug8g6yw4uun.gif'),
  //   fit: BoxFit.cover,
  // ),
  color: Color(0xFF8B9B9C),
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
