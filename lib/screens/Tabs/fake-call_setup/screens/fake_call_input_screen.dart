import 'package:flutter/material.dart';

class FakeCallInputScreen extends StatefulWidget {
  @override
  _FakeCallInputScreenState createState() => _FakeCallInputScreenState();
}

class _FakeCallInputScreenState extends State<FakeCallInputScreen> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController durationController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("New Fake Call")),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: nameController,
              decoration: InputDecoration(
                labelText: "Name",
                prefixIcon: Icon(Icons.person),
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 12),
            TextField(
              controller: phoneController,
              decoration: InputDecoration(
                labelText: "Phone Number",
                prefixIcon: Icon(Icons.phone),
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.phone,
            ),
            SizedBox(height: 12),
            TextField(
              controller: durationController,
              decoration: InputDecoration(
                labelText: "Duration (seconds)",
                prefixIcon: Icon(Icons.timer),
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 12),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.teal),
              onPressed: () {
                Navigator.pop(context, {
                  'name': nameController.text,
                  'phone': phoneController.text,
                  'duration': int.tryParse(durationController.text) ?? 5,
                });
              },
              child: Text("Save"),
            ),
          ],
        ),
      ),
    );
  }
}