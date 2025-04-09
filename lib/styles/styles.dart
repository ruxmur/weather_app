import 'package:carousel_slider/carousel_options.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

// *** HOME SCREEN STYLES *** //
// --- Home background styles --- //
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

// --- City search field styles --- //
BoxDecoration containerDecoration = BoxDecoration(
  color: Colors.white.withOpacity(0.5),
  borderRadius: BorderRadius.circular(10),
);

// --- City search field decoration styles --- //
InputDecoration searchFieldDecoration = InputDecoration(
  labelText: 'Search city',
  hintText: 'Enter city name',
  filled: true,
  fillColor: Colors.white.withOpacity(0.5),
  border: OutlineInputBorder(
    borderRadius: BorderRadius.circular(10),
  ),
);

// *** SELECTED CITY SCREEN STYLES *** //
// --- Location button styles --- //
final ColorFilter colorFilterStyle = ColorFilter.mode(
  Colors.black.withOpacity(0.8),
  BlendMode.dstATop,
);

// --- Location button styles --- //
final ButtonStyle locationButtonStyle = ElevatedButton.styleFrom(
  backgroundColor: Colors.transparent,
  foregroundColor: Colors.white,
);

// --- Location button text styles --- //
const TextStyle locationButtonTextStyle = TextStyle(
  fontSize: 16,
  color: Colors.white,
);

// --- Temperature forecast text styles --- //
const TextStyle temperatureForecastTextStyle = TextStyle(
  fontSize: 22,
  color: Colors.black,
);

// --- Temperature forecast padding styles --- //
const EdgeInsets temperatureForecastPaddingStyle = EdgeInsets.symmetric(
  horizontal: 15,
  vertical: 1,
);

// *** WEATHER SCREEN STYLES *** //
// --- Current weather container decoration styles --- //
BoxDecoration weatherContainerDecoration = BoxDecoration(
    gradient: LinearGradient(
  colors: [Colors.white, Colors.black54],
  begin: Alignment.bottomLeft,
  end: Alignment.topLeft,
));

// --- Weather text styles --- //
const TextStyle weatherTextStyle = TextStyle(
  fontSize: 25,
  fontWeight: FontWeight.bold,
  color: Colors.white,
);

// --- 'Now' text styles --- //
const TextStyle nowTextStyle = TextStyle(
  fontSize: 20,
  fontWeight: FontWeight.bold,
  color: Colors.white,
);

// --- Current weather text styles --- //
const TextStyle currentWeatherTextStyle = TextStyle(
  fontSize: 45,
  fontWeight: FontWeight.bold,
  color: Colors.white,
);

// --- Climate text styles --- //
const TextStyle climateTextStyle = TextStyle(
  fontSize: 20,
  color: Colors.white,
);

// --- Formatted weather text styles --- //
const TextStyle formattedWeatherTextStyle = TextStyle(
  fontSize: 24,
  fontWeight: FontWeight.bold,
  color: Colors.white,
);

// --- Forecast carousel container decoration styles --- //
BoxDecoration carouselContainerDecoration = BoxDecoration(
  color: Colors.black.withOpacity(0.2),
  borderRadius: BorderRadius.circular(12),
);

// --- Forecast text styles --- //
const TextStyle forecastTextStyle = TextStyle(
  fontSize: 16,
  fontWeight: FontWeight.bold,
  color: Colors.white,
);

// --- Carousel options styles --- //
CarouselOptions carouselOptions = CarouselOptions(
  height: 140, // Fixed height for the carousel
  enlargeCenterPage: false, // Make the center item slightly larger if it's true
  aspectRatio: 16 / 9, // Aspect ratio of each item
  autoPlayCurve: Curves.fastOutSlowIn, // Smooth scrolling animation
  enableInfiniteScroll: false, // Disable infinite scrolling
  autoPlayAnimationDuration: Duration(milliseconds: 800), // Animation duration
  viewportFraction: 0.2, // Fraction of the viewport each item occupies
  padEnds: false, // Remove padding at the ends
);

// --- Weather forecast item container styles --- //
BoxDecoration weatherForecastItemContainerStyle = BoxDecoration(
  borderRadius: BorderRadius.circular(12),
  gradient: LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Colors.white.withOpacity(0.15),
      Colors.white.withOpacity(0.05),
      Colors.white.withOpacity(0.0),
      Colors.black.withOpacity(0.1),
    ],
    stops: [0.3, 0.4, 0.9, 1.0],
  ),
  border: Border.all(
    width: 1.5,
    color: Colors.white.withOpacity(0.6),
  ),
  boxShadow: [
    BoxShadow(
      color: Colors.black.withOpacity(0.3),
      blurRadius: 2,
      spreadRadius: 0.5,
    ),
  ],
);

// --- Max and min temperature text styles --- //
const TextStyle maxMinTempTextStyle = TextStyle(
  fontSize: 14,
  color: Colors.white,
);

// --- Max and min temperature text styles --- //
BarAreaData barAreaDataStyle = BarAreaData(
  show: true,
  gradient: LinearGradient(
    colors: [
      Colors.white.withOpacity(0.2),
      Colors.blueAccent.withOpacity(0.4)
    ],
    begin: Alignment.bottomLeft,
    end: Alignment.topLeft,
  ),
);

// --- Hourly forecast text styles --- //
const TextStyle hourlyForecastTextStyle = TextStyle(
  fontSize: 12,
  color: Colors.white
);

// --- Humidity chart styles --- //
LineChartData lineChartDataStyle = LineChartData(
  // Controls touch interactions with the chart.
  lineTouchData: const LineTouchData(enabled: false),
  // background grid
  gridData: const FlGridData(show: false),
  titlesData: const FlTitlesData(show: false),
  // Configures the chart's border.
  borderData: FlBorderData(show: false),
  // 0 to 23: Maps to 24 hours (0 = midnight, 23 = 11 PM).
  // (Matches hourly data points.)
  minX: 0,
  maxX: 23,
  // 0 to 100: Humidity is displayed as a percentage (0%–100%).
  // (Ensures the chart scales predictably for all values.)
  minY: 0,
  maxY: 100,
);

// --- Glass container text styles --- //
const TextStyle glassContainerTextStyle = TextStyle(
  color: Colors.white,
);

// --- Drop image styles --- //
Image dropImageStyle = Image.asset(
  'assets/icons/drop.png',
  width: 40,
  height: 40,
  color: Colors.white
);

// --- Weather header text styles --- //
const TextStyle weatherHeaderTextStyle = TextStyle(
  fontSize: 20,
  color: Colors.black,
);

// --- Selected label text styles --- //
const TextStyle selectedLabelStyle = TextStyle(
  fontSize: 14,
  fontWeight: FontWeight.bold,
);

// --- Unselected label text styles --- //
const TextStyle unselectedLabelStyle = TextStyle(
  fontSize: 14,
  fontWeight: FontWeight.normal,
);