import 'package:flutter/material.dart';
import 'abouts_screen1.dart';
import 'abouts_screen2.dart';
import 'abouts_screen3.dart';

class AboutsMain extends StatefulWidget {
  const AboutsMain({super.key});

  @override
  _AboutsMainState createState() => _AboutsMainState();
}

class _AboutsMainState extends State<AboutsMain> {
  final PageController _pageController = PageController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: _pageController,
        children: const [
          AboutsScreen1(),
          AboutsScreen2(),
          AboutsScreen3(),
        ],
      ),
    );
  }
}
