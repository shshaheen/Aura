import 'package:flutter/material.dart';

class HelplineDetailsScreen extends StatelessWidget {
  final String number;
  final String name;
  final Color? color;

  HelplineDetailsScreen({required this.number, required this.name, this.color});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(name)),
      body: Center(
        child: Container(
          width: double.infinity,
          padding: EdgeInsets.all(20),
          color: color ?? Colors.white,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                number,
                style: TextStyle(fontSize: 36, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              Text(
                name,
                style: TextStyle(fontSize: 20),
              ),
              SizedBox(height: 20),
              ElevatedButton.icon(
                icon: Icon(Icons.call),
                label: Text("Call $number"),
                onPressed: () {
                  // Add call functionality
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
