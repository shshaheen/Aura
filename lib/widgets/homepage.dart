import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:geolocator/geolocator.dart';
import 'package:aura/main.dart';
import 'package:aura/widgets/main_drawer.dart';
class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  _HomepageState createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  String phoneNumber = "Fetching...";
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
    });
  }

  Future<void> _getCurrentLocation() async {
    setState(() {
      isLoading = true;
    });

    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      _showSnackbar("Enable location services in settings.");
      setState(() {
        isLoading = false;
      });
      return;
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        _showSnackbar("Location permission denied.");
        setState(() {
          isLoading = false;
        });
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      _showSnackbar("Location permission is permanently denied. Enable it in settings.");
      setState(() {
        isLoading = false;
      });
      return;
    }

    try {
      // Get last known location (if available)
      Position? lastPosition = await Geolocator.getLastKnownPosition();
      if (lastPosition != null) {
        setState(() {
          locationLink = "https://www.google.com/maps?q=${lastPosition.latitude},${lastPosition.longitude}";
        });
      }

      // Get fresh location (more accurate)
      Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.best);

      setState(() {
        locationLink = "https://www.google.com/maps?q=${position.latitude},${position.longitude}";
        isLoading = false;
      });

      print("Location for $phoneNumber: $locationLink");
    } catch (e) {
      _showSnackbar("Failed to get location. Please try again.");
      setState(() {
        isLoading = false;
      });
    }
  }

  void _showSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), duration: const Duration(seconds: 2)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Homepage')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Welcome!',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              Text(
                'Logged-in Phone: $phoneNumber',
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              ElevatedButton.icon(
                onPressed: _getCurrentLocation,
                icon: const Icon(Icons.location_on, color: Colors.white,),
                label: const Text("Get Location"),
              ),
              ElevatedButton.icon(
                onPressed: (){},
                icon: const Icon(Icons.location_on, color: Colors.white,),
                label: const Text("Fake Call"),
              ),
              const SizedBox(height: 10),
              if (isLoading) const CircularProgressIndicator(),
              if (locationLink != null)
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: SelectableText(
                    "Location: $locationLink",
                    style: const TextStyle(fontSize: 16, color: Colors.blue),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
