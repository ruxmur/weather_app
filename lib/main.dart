import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'app.dart';
import 'core/domain/providers/city_time_provider.dart';

void main() {
  // WidgetsFlutterBinding.ensureInitialized() is a method that
  // ensures the Flutter framework is properly initialized before running
  // any asynchronous code or accessing platform-specific functionality.
  // It is typically used in the following scenarios:
  // - When using plugins or packages that rely on platform channels (e.g., geolocation, camera, etc.).
  // - When running asynchronous code before calling runApp (e.g., fetching data, initializing services).
  // - When using async in the main function.
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => CityTimeProvider()),
      ],
      child: const Application(),
    ),
  );
}