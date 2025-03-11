import 'package:aura/authentication/otp_screen.dart';

import '../phone_screen.dart';
import 'package:flutter/material.dart';
import 'package:aura/main.dart'; // Import to access kLightColorScheme and kDarkColorScheme

class AboutsScreen3 extends StatelessWidget {
  const AboutsScreen3({super.key});

  @override
  Widget build(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    final isDarkMode = brightness == Brightness.dark;

    final colorScheme = isDarkMode ? kDarkColorScheme : kLightColorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              colorScheme.primaryContainer.withOpacity(0.3),
              colorScheme.primaryContainer.withOpacity(0.6),
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Column(
          children: [
            const SizedBox(height: 80),

            // Title
            Text(
              "Emergency Alert",
              style: textTheme.headlineLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: colorScheme.primary,
              ),
            ),

            // const SizedBox(height: 20),

            // Image
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Image.asset(
                  'assets/images/about3.png',
                  fit: BoxFit.contain,
                ),
              ),
            ),

            // Bottom Container
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: colorScheme.secondaryContainer,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(40),
                  topRight: Radius.circular(40),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 10,
                    spreadRadius: 2,
                  ),
                ],
              ),
              child: Column(
                children: [
                  // Description
                  Text(
                    "Emergency alert functionality can call and send SMS on saved contacts , if stuck in a panic situation",
                    textAlign: TextAlign.center,
                    style: textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.w500,
                      color: colorScheme.onSecondaryContainer,
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Indicator Dots
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(3, (index) {
                      return Container(
                        margin: const EdgeInsets.symmetric(horizontal: 5),
                        width: index == 2 ? 14 : 10,
                        height: index == 2 ? 14 : 10,
                        decoration: BoxDecoration(
                          color: index == 2
                              ? colorScheme.primary
                              : colorScheme.onSecondaryContainer
                                  .withOpacity(0.5),
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.2),
                              blurRadius: 4,
                              spreadRadius: 1,
                            ),
                          ],
                        ),
                      );
                    }),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => PhoneScreen()),
                        );
                      },
                      child: Text('Next')),

                  // const SizedBox(height: 20),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
