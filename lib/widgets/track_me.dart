import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class TrackMe extends StatefulWidget {
  const TrackMe({super.key});

  @override
  State<TrackMe> createState() => _TrackMeState();
}

class _TrackMeState extends State<TrackMe> {
  LatLng? _currentPosition;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  Future<void> _getCurrentLocation() async {
    setState(() {
      _errorMessage = null; // Reset error message
    });

    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      setState(() {
        _errorMessage = "Location services are disabled.";
      });
      return;
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.deniedForever) {
        setState(() {
          _errorMessage = "Location permission is permanently denied.";
        });
        return;
      }
    }

    try {
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.best,
      );
      setState(() {
        _currentPosition = LatLng(position.latitude, position.longitude);
      });
    } catch (e) {
      setState(() {
        _errorMessage = "Error fetching location: $e";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          /// **Map View**
          Positioned.fill(
            child: _errorMessage != null
                ? Center(child: Text(_errorMessage!, style: TextStyle(color: Colors.red)))
                : _currentPosition == null
                    ? Center(child: CircularProgressIndicator())
                    : FlutterMap(
                        options: MapOptions(
                          initialCenter: _currentPosition!,
                          initialZoom: 15,
                        ),
                        children: [
                          TileLayer(
                            urlTemplate: "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
                            subdomains: ['a', 'b', 'c'],
                            userAgentPackageName: 'com.example.yourapp',
                          ),
                          MarkerLayer(
                            markers: [
                              Marker(
                                point: _currentPosition!,
                                width: 40,
                                height: 40,
                                child: Icon(Icons.location_pin, color: Colors.red, size: 40),
                              ),
                            ],
                          ),
                        ],
                      ),
          ),

          Positioned(
            left: 3,
            right: 3,
            child: Card(
              elevation: 4, // Adds a shadow for a floating effect
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12), // Rounded corners
              ),
              color: Theme.of(context).secondaryHeaderColor, // Background color
              child: Padding(
                padding: EdgeInsets.all(16), // Adds space inside the card
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Track me",
                      style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 4), // Space between title & subtitle
                    Text(
                      "Share live location with your friends",
                      style: TextStyle(fontSize: 14, color: Colors.grey),
                    ),
                  ],
                ),
              ),
            ),
          ),


          /// **Location Button (Top Right)**
          Positioned(
            top: 200,
            right: 16,
            child: FloatingActionButton(
              mini: true,
              backgroundColor: Colors.white,
              elevation: 4,
              onPressed: _getCurrentLocation,
              child: Icon(Icons.my_location, color: Colors.black),
            ),
          ),

          /// **Track Me Button (Bottom Center)**
          Positioned(
            bottom: 70,
            left: MediaQuery.of(context).size.width * 0.25,
            right: MediaQuery.of(context).size.width * 0.25,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.primary,
                padding: EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              onPressed: _getCurrentLocation,
              child: Text("Track Me", style: TextStyle(fontSize: 16, color: Colors.white)),
            ),
          ),
          
        ],
      ),
    );
  }
}
