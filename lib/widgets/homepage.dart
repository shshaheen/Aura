import 'package:flutter/material.dart';
// import 'package:firebase_auth/firebase_auth.dart';
import 'package:geolocator/geolocator.dart';
import 'package:aura/main.dart';
import 'package:flutter_map/flutter_map.dart';
// import 'package:geolocator/geolocator.dart';
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
  String phoneNumber = "Fetching...";
  String? locationLink;
  bool isLoading = false;
   LatLng? _currentPosition;

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  // void _getUserPhoneNumber() {
  //   User? user = FirebaseAuth.instance.currentUser;
  //   setState(() {
  //     phoneNumber = user?.phoneNumber ?? "No phone number found";
  //   });
  // }


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

  // Future<void> _getCurrentLocation() async {
  //   setState(() {
  //     isLoading = true;
  //   });

  //   bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
  //   if (!serviceEnabled) {
  //     _showSnackbar("Enable location services in settings.");
  //     setState(() {
  //       isLoading = false;
  //     });
  //     return;
  //   }

  //   LocationPermission permission = await Geolocator.checkPermission();
  //   if (permission == LocationPermission.denied) {
  //     permission = await Geolocator.requestPermission();
  //     if (permission == LocationPermission.denied) {
  //       _showSnackbar("Location permission denied.");
  //       setState(() {
  //         isLoading = false;
  //       });
  //       return;
  //     }
  //   }

  //   if (permission == LocationPermission.deniedForever) {
  //     _showSnackbar("Location permission is permanently denied. Enable it in settings.");
  //     setState(() {
  //       isLoading = false;
  //     });
  //     return;
  //   }

  //   try {
  //     // Get last known location (if available)
  //     Position? lastPosition = await Geolocator.getLastKnownPosition();
  //     if (lastPosition != null) {
  //       setState(() {
  //         locationLink = "https://www.google.com/maps?q=${lastPosition.latitude},${lastPosition.longitude}";
  //       });
  //     }

  //     // Get fresh location (more accurate)
  //     Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.best);

  //     setState(() {
  //       locationLink = "https://www.google.com/maps?q=${position.latitude},${position.longitude}";
  //       isLoading = false;
  //     });

  //     // print("Location for $phoneNumber: $locationLink");
  //   } catch (e) {
  //     _showSnackbar("Failed to get location. Please try again.");
  //     setState(() {
  //       isLoading = false;
  //     });
  //   }
  // }

  // void _showSnackbar(String message) {
  //   ScaffoldMessenger.of(context).showSnackBar(
  //     SnackBar(content: Text(message), duration: const Duration(seconds: 2)),
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'AURA',
          style: GoogleFonts.lato(fontWeight: FontWeight.bold),
          ),
        actions: [
          InkWell(
            onTap: () {
              // print("Niya image clicked");
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
      drawer: MainDrawer(),
      body: Column(
        children: [
          const SizedBox(height: 40),
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
          // Text(
          //   "Share Location",
          //   style: TextStyle(
          //     fontWeight: FontWeight.bold,
          //     color: Colors.black,
          //   ),
          // ),
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
          
          Container(
            padding: const EdgeInsets.all(7),
            decoration: BoxDecoration(
              color:  Theme.of(context).colorScheme.secondaryContainer,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(onPressed: () {}, icon: Icon(Icons.location_on)),
                    Text("Track Me"),
                  ],
                ),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(onPressed: () {}, icon: Icon(LucideIcons.users)),
                    Text("Friends"),
                  ],
                ),
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
                    onPressed: () {},
                    icon: Icon(Icons.sos, color: Colors.white),
                  ),
                ),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(onPressed: () {}, icon: Icon(Icons.phone_callback)),
                    Text("Fake Call"),
                  ],
                ),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(onPressed: () {}, icon: Icon(LucideIcons.contact)),
                    Text("Helpline"),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
