import 'package:flutter/material.dart';
import 'package:aura/main.dart'; // Ensure you import kColorScheme and kDarkColorScheme
import 'abouts_screen.dart';
class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final brightness = MediaQuery.of(context).platformBrightness;
    final isDarkMode = brightness == Brightness.dark;
    
    // Assign colors dynamically based on the theme mode
    final backgroundColor = isDarkMode ? kDarkColorScheme.background : kLightColorScheme.background;
    final textColor = isDarkMode ? kDarkColorScheme.onBackground : kLightColorScheme.onBackground;
    final buttonColor = isDarkMode ? kDarkColorScheme.primary : kLightColorScheme.primary;
    final buttonTextColor = isDarkMode ? kDarkColorScheme.onPrimary : kLightColorScheme.onPrimary;
    final gradientStart = isDarkMode ? kDarkColorScheme.inversePrimary : kLightColorScheme.primaryContainer.withOpacity(0.3);
    final gradientEnd = isDarkMode ? kDarkColorScheme.onSecondary : kLightColorScheme.primaryContainer.withOpacity(0.6);

    return Scaffold(
      backgroundColor: backgroundColor, // Background color changes based on mode
      body: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [gradientStart, gradientEnd],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Logo
            Image.asset(
              'assets/images/aura_logo.png',
              height: 250,
            ),

            // App Name
            Text(
              'AURA',
              style: TextStyle(
                fontSize: 36,
                fontWeight: FontWeight.bold,
                color: textColor, // Dynamically assigned text color
              ),
            ),

            const SizedBox(height: 120),

            // Get Started Button
            ElevatedButton(
              onPressed: () {
                // Navigate to OTP Screen or Next Page
                 Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const AboutScreen()),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: buttonColor, // Button color based on theme
                foregroundColor: buttonTextColor, // Text color based on theme
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                elevation: 5,
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.arrow_right_alt, size: 30),
                  const SizedBox(width: 10),
                  Text(
                    "Let's Get Started",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: buttonTextColor, // Button text color changes dynamically
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
