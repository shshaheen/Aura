import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:aura/widgets/main_drawer.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons/lucide_icons.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  _HomepageState createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  LatLng? _currentPosition;
  int selectedIndex = -1; // Track the selected icon index

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  Future<void> _getCurrentLocation() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) return;

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.deniedForever) return;
    }

    try {
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.best,
      );
      setState(() {
        _currentPosition = LatLng(position.latitude, position.longitude);
      });
    } catch (e) {
      print("Error fetching location: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
      preferredSize: const Size.fromHeight(kToolbarHeight),
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Theme.of(context).colorScheme.onPrimary.withOpacity(0.3),
              Theme.of(context).colorScheme.onPrimary.withOpacity(0.6),
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: AppBar(
          title: Text(
            'AURA',
            style: GoogleFonts.lato(
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.secondary,
            ),
          ),
          backgroundColor: Colors.transparent, // Keep gradient visible
          elevation: 0, // Removes shadow
          iconTheme: IconThemeData( // Change menu icon color
            color: Theme.of(context).colorScheme.secondary, 
          ),
          actions: [
            InkWell(
              onTap: () {
                // Handle profile tap
              },
              child: Padding(
                padding: EdgeInsets.all(8.0),
                child: ClipOval(
                  child: Image.asset(
                    'assets/images/niya.jpg',
                    width: 40,
                    height: 40,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    ),

      drawer: MainDrawer(),
      body: Column(
        children: [
          const SizedBox(height: 3),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Container(
              height: 70,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14),
                boxShadow: [
                  BoxShadow(
                    color: const Color.fromARGB(255, 127, 13, 13).withOpacity(0.2),
                    blurRadius: 10,
                    spreadRadius: 2,
                  ),
                ],
              ),
              child: ListTile(
                title: Text("Add Friends"),
                subtitle: Text("Add a friend to use SOS and Track Me"),
                trailing: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 184, 226, 254),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  onPressed: () {},
                  child: Text("Add"),
                ),
              ),
            ),
          ),
          Expanded(
            child: _currentPosition == null
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

          // Bottom Navigation Bar
          Container(
            padding: const EdgeInsets.all(7),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.onPrimary,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                buildNavItem(0, Icons.location_on, "Track Me"),
                buildNavItem(1, LucideIcons.users, "Friends"),
                Container(
                  width: 75,
                  height: 75,
                  decoration: BoxDecoration(
                    color: Colors.red,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: const Color.fromARGB(255, 127, 13, 13).withOpacity(0.5),
                        blurRadius: 10,
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                  child: IconButton(
                    onPressed: () {
                      // Handle SOS button click
                    },
                    icon: Icon(Icons.sos, color: Colors.white),
                  ),
                ),
                buildNavItem(2, Icons.phone_callback, "Fake Call"),
                buildNavItem(3, LucideIcons.contact, "Helpline"),
              ],
            ),
          ),
        ],
    ),
    );
  }

  /// Builds a navigation icon item with highlight effect
  Widget buildNavItem(int index, IconData icon, String label) {
    bool isSelected = selectedIndex == index;

    return GestureDetector(
      onTap: () {
        setState(() {
          selectedIndex = index;
        });

        // Implement navigation functionality here
        switch (index) {
          case 0:
            print("Navigate to Track Me");
            break;
          case 1:
            print("Navigate to Friends");
            break;
          case 2:
            print("Navigate to Fake Call");
            break;
          case 3:
            print("Navigate to Helpline");
            break;
        }
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: isSelected ? Theme.of(context).colorScheme.primary : Colors.transparent,
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon, 
              color: isSelected ? 
              Theme.of(context).colorScheme.onPrimary : 
              Theme.of(context).colorScheme.secondary
            ),
          ),
          Text(
            label,
            style: TextStyle(
              color: isSelected ? 
              Theme.of(context).colorScheme.tertiary : 
              Theme.of(context).colorScheme.secondary
            ),
          ),
        ],
      ),
    );
  }
}
