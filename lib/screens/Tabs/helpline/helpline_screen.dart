import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class HelplineScreen extends StatelessWidget {
  final List<Map<String, dynamic>> helplineNumbers = [
    {"number": "112", "name": "National helpline", "icon": Icons.local_phone, "color": Colors.green[100]},
    {"number": "108", "name": "Ambulance", "icon": Icons.local_hospital, "color": Colors.blue[100]},
    {"number": "102", "name": "Pregnancy Medic", "icon": Icons.pregnant_woman, "color": Colors.pink[100]},
    {"number": "101", "name": "Fire Service", "icon": Icons.fire_truck, "color": Colors.yellow[100]},
    {"number": "100", "name": "Police", "icon": Icons.local_police, "color": Colors.lightBlue[100]},
    {"number": "1091", "name": "Women Helpline", "icon": Icons.group, "color": Colors.lime[100]},
    {"number": "1098", "name": "Child Helpline", "icon": Icons.child_care, "color": Colors.cyan[100]},
    {"number": "1073", "name": "Road Accident", "icon": Icons.car_crash, "color": Colors.orange[100]},
    {"number": "182", "name": "Railway Protection", "icon": Icons.train, "color": Colors.grey[300]},
  ];

  Future<void> _makePhoneCall(String phoneNumber) async {
    final Uri callUri = Uri.parse('tel:$phoneNumber');
    if (await canLaunchUrl(callUri)) {
      await launchUrl(callUri);
    } else {
      throw 'Could not launch $callUri';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("National Numbers"),
        automaticallyImplyLeading: false, // This removes the back button
      ),
            body: ListView.builder(
        itemCount: helplineNumbers.length,
        itemBuilder: (context, index) {
          final helpline = helplineNumbers[index];
          return GestureDetector(
            onTap: () => _makePhoneCall(helpline["number"]),
            child: Container(
              margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: helpline["color"],
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Icon(helpline["icon"], size: 30),
                      SizedBox(width: 10),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            helpline["number"], 
                            style: TextStyle(
                              fontSize: 18, 
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).colorScheme.onPrimary
                              )
                            ),
                          Text(
                            helpline["name"], 
                            style: TextStyle(
                              fontSize: 14, 
                              color: Colors.black
                              )
                            ),
                        ],
                      ),
                    ],
                  ),
                  Icon(Icons.phone, color: Colors.black),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}