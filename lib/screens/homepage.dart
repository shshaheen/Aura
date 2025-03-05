import 'package:aura/screens/Tabs/helpline/helpline_details_screen.dart';
import 'package:aura/screens/Tabs/helpline/helpline_screen.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'package:aura/widgets/main_drawer.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:aura/screens/Tabs/track_me.dart';
import 'package:aura/screens/Tabs/fake-call_setup/screens/fake_call_screen.dart';
import 'chat_screen.dart';
import 'Tabs/Friends/friends_page.dart';
// import 'package:provider/provider.dart';
// import 'Tabs/fake-call_setup/providers/fake_call_provider.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  _HomepageState createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  Widget currentWidget = TrackMe();
  int selectedIndex = 0; // Default screen index: TrackMe
  LatLng? _currentPosition;

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

  void _onNavItemSelected(int index) {
    if (selectedIndex == index) return; // Prevent unnecessary rebuilds

    setState(() {
      selectedIndex = index;
      switch (index) {
        case 0:
          currentWidget = TrackMe();
          break;
        case 1:
          currentWidget = FriendsPage();
          print("Navigate to Friends"); // Replace with actual screen
          break;
        case 2:
          currentWidget = FakeCallScreen(); // Load FakeCallScreen as a widget
          break;
        case 3:
          currentWidget = HelplineScreen();
          print("Navigate to Helpline"); // Replace with actual screen
          break;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    bool isKeyboardOpen = MediaQuery.of(context).viewInsets.bottom > 0;

    return Scaffold(
      resizeToAvoidBottomInset: true,
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
            backgroundColor: Colors.transparent,
            elevation: 0,
            iconTheme: IconThemeData(
              color: Theme.of(context).colorScheme.secondary,
            ),
            actions: [
              InkWell(
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => ChatScreen()));
                  ChatScreen();
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
          Expanded(
              child:
                  currentWidget), // Update dynamically based on selected index

          if (!isKeyboardOpen)
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
                  buildSOSButton(),
                  buildNavItem(2, Icons.phone_callback, "Fake Call"),
                  buildNavItem(3, LucideIcons.contact, "Helpline"),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Widget buildNavItem(int index, IconData icon, String label) {
    bool isSelected = selectedIndex == index;

    return GestureDetector(
      onTap: () => _onNavItemSelected(index),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: isSelected
                  ? Theme.of(context).colorScheme.primary
                  : Colors.transparent,
              shape: BoxShape.circle,
            ),
            child: Icon(icon,
                color: isSelected
                    ? Theme.of(context).colorScheme.onPrimary
                    : Theme.of(context).colorScheme.secondary),
          ),
          Text(
            label,
            style: TextStyle(
                color: isSelected
                    ? Theme.of(context).colorScheme.tertiary
                    : Theme.of(context).colorScheme.secondary),
          ),
        ],
      ),
    );
  }

  Widget buildSOSButton() {
    return Container(
      width: 75,
      height: 75,
      decoration: BoxDecoration(
        color: Colors.red,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: Colors.red.withOpacity(0.5),
            blurRadius: 10,
            spreadRadius: 2,
          ),
        ],
      ),
      child: IconButton(
        onPressed: () {
          print("SOS Button Pressed!");
        },
        icon: Icon(Icons.sos, color: Colors.white),
      ),
    );
  }
}
