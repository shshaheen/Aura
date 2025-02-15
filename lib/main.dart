import 'package:flutter/material.dart';
import 'otp_screen.dart'; // Import the OTP screen
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() {
   WidgetsFlutterBinding.ensureInitialized();
   Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Twilio OTP Authentication",
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: OTPScreen(), // Start with OTP Screen
    );
  }
}
