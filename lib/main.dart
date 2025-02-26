import 'package:aura/widgets/homepage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:aura/screens/welcome_screen.dart';
import 'package:aura/screens/profile_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

var kLightColorScheme = ColorScheme.fromSeed(
  seedColor: const Color.fromARGB(255, 0, 194, 203),
);

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
      title: "Aura OTP Authentication",
      themeMode: ThemeMode.system,
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
      home: AuthWrapper(), // Decides if the user goes to Home or Welcome Screen
    );
  }
}

class AuthWrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(body: Center(child: CircularProgressIndicator()));
        }
        if (snapshot.hasData) {
          return FutureBuilder<bool>(
            future: _isProfileComplete(snapshot.data!.uid), // Check profile completion
            builder: (context, profileSnapshot) {
              if (profileSnapshot.connectionState == ConnectionState.waiting) {
                return Scaffold(body: Center(child: CircularProgressIndicator()));
              }
              if (profileSnapshot.hasData && profileSnapshot.data == false) {
                return CompleteProfileScreen(); // Redirect to complete profile
              }
              return Homepage(); // Redirect to homepage
            },
          );
        }
        return WelcomeScreen(); // User not logged in
      },
    );
  }

  Future<bool> _isProfileComplete(String userId) async {
    try {
      var doc = await FirebaseFirestore.instance.collection('users').doc(userId).get();
      if (doc.exists) {
        var data = doc.data();
        return data != null && data['profileCompleted'] == true;
      }
      return false;
    } catch (e) {
      print("Error checking profile completion: $e");
      return false;
    }
  }
}
