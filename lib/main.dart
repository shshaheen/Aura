import 'package:aura/screens/welcome_screen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

// Light Mode Color Scheme
var kLightColorScheme = ColorScheme.fromSeed(
  seedColor: const Color.fromARGB(255, 0, 194, 203),
);

// Dark Mode Color Scheme
var kDarkColorScheme = ColorScheme.fromSeed(
  brightness: Brightness.dark,
  seedColor: const Color.fromARGB(255, 0, 130, 140),
);

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: "assets/.env");
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Twilio OTP Authentication",
      themeMode: ThemeMode.system, // Automatically switches between light and dark mode

      // Light Theme
      theme: ThemeData(
        colorScheme: kLightColorScheme,
        appBarTheme: AppBarTheme(
          backgroundColor: kLightColorScheme.primaryContainer,
          foregroundColor: kLightColorScheme.onPrimary,
        ),
        cardTheme: CardTheme(
          color: kLightColorScheme.secondaryContainer,
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: kLightColorScheme.primary,
            foregroundColor: kLightColorScheme.onPrimary,
          ),
        ),
      ),

      // Dark Theme
      darkTheme: ThemeData.dark().copyWith(
        colorScheme: kDarkColorScheme,
        appBarTheme: AppBarTheme(
          backgroundColor: kDarkColorScheme.primaryContainer,
          foregroundColor: kDarkColorScheme.onPrimary,
        ),
        cardTheme: CardTheme(
          color: kDarkColorScheme.secondaryContainer,
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        ),
        
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: kDarkColorScheme.primary,
            foregroundColor: kDarkColorScheme.onPrimary,
          ),
        ),
      ),

      home: const WelcomeScreen(),
    );
  }
}
