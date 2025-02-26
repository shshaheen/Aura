import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:geolocator/geolocator.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  _HomepageState createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  String? phoneNumber;
  String? locationLink;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    _getUserPhoneNumber();
  }

  void _getUserPhoneNumber() {
    User? user = FirebaseAuth.instance.currentUser;
    setState(() {
      phoneNumber = user?.phoneNumber ?? "No phone number found";
      // phoneNumber = '+918179291362';
    });
  }

  Future<void> _getCurrentLocation() async {
    setState(() {
      isLoading = true;
    });

    bool serviceEnabled;
    LocationPermission permission;

    // Check if location services are enabled
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      setState(() {
        locationLink = "Location services are disabled.";
        isLoading = false;
      });
      return;
    }

    // Check permission status
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        setState(() {
          locationLink = "Location permission denied.";
          isLoading = false;
        });
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      setState(() {
        locationLink = "Location permissions are permanently denied.";
        isLoading = false;
      });
      return;
    }

    // Get current location
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);

    setState(() {
      locationLink =
          "https://www.google.com/maps?q=${position.latitude},${position.longitude}";
      isLoading = false;
    });
    print("Location for $phoneNumber: $locationLink");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Homepage'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Welcome to the Homepage!',
              style: TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 20),
            Text(
              'Logged-in Phone Number: $phoneNumber',
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _getCurrentLocation,
              child: const Text("Generate Location Link"),
            ),
            const SizedBox(height: 10),
            if (isLoading) const CircularProgressIndicator(),
            if (locationLink != null)
              SelectableText(
                "Location Link: $locationLink",
                style: const TextStyle(fontSize: 16, color: Colors.blue),
              ),
          ],
        ),
      ),
    );
  }
}
