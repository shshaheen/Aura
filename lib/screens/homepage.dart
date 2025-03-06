import 'package:aura/screens/Tabs/helpline/helpline_details_screen.dart';
import 'package:aura/screens/Tabs/helpline/helpline_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
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
import 'package:url_launcher/url_launcher.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:twilio_flutter/twilio_flutter.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
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
  FirebaseMessaging messaging = FirebaseMessaging.instance;
  
  final TwilioFlutter twilioFlutter = TwilioFlutter(
    accountSid: dotenv.env['ACCOUNT_SID_new'] ?? '',  // Replace with Twilio Account SID
    authToken:dotenv.env['AUTH_TOKEN_new'] ?? '' ,   // Replace with Twilio Auth Token
    twilioNumber: dotenv.env['TWILIO_phone_new'] ?? '', // Replace with Twilio Number
  );

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
    _setupFirebaseMessaging();
  }

  void _setupFirebaseMessaging() async {
    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print("User granted permission for notifications.");
    }

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print("New foreground message: ${message.notification?.title}");
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print("Notification clicked: ${message.notification?.body}");
    });
  }

  // Fetch Contacts and Send Push Notification
  // Future<void> getContactsAndSendLocation() async {
  //   var snapshot = await FirebaseFirestore.instance.collection("contacts").get();
  //   List<Map<String, dynamic>> contacts = snapshot.docs.map((doc) => doc.data() as Map<String, dynamic>).toList();
  //   String locationUrl = getLocationUrl(_currentPosition);

  //   for (Map<String, dynamic> contact in contacts) {
  //     String token = contact['phone'];  // Assuming users store FCM tokens
  //     sendPushNotification(token, "Emergency Alert!", locationUrl);
  //   }
  // }
  Future<void> sendSmsToAllContacts() async {
  String msg = getLocationUrl(_currentPosition);

  if (msg.trim().isEmpty) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Please enter a message")),
    );
    return;
  }

  try {
    QuerySnapshot querySnapshot =
        await FirebaseFirestore.instance.collection('contacts').get();

    for (var doc in querySnapshot.docs) {
      String phoneNumber = doc['phone'];
      print("Sending SMS to: $phoneNumber");

      var response = await twilioFlutter.sendSMS(
        toNumber: phoneNumber,
        messageBody: msg,
      );

      print("Twilio Response: $response"); // 🔥 Print Twilio's response
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("SMS sent to all contacts!")),
    );
  } catch (e) {
    print("Error sending SMS: $e");
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Error sending SMS: $e")),
    );
  }
}

  // Send Push Notification
  Future<void> sendPushNotification(String token, String title, String body) async {
    try {
      await FirebaseFirestore.instance.collection("notifications").add({
        "token": token,
        "title": title,
        "body": body,
        "timestamp": FieldValue.serverTimestamp(),
      });
    } catch (e) {
      print("Error sending notification: $e");
    }
  }

  // Get Google Maps URL
  String getLocationUrl(LatLng? position) {
    if (position == null) {
      print("Location not available!");
      return "Location not available!";
    }
    String url = "https://www.google.com/maps?q=${position.latitude},${position.longitude}";
    return url;
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
          sendSmsToAllContacts();
          // getContacts();
          // getLocationUrl(_currentPosition);
          print("SOS Button Pressed!");
        },
        icon: Icon(Icons.sos, color: Colors.white),
      ),
    );
  }
}
