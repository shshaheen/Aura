import 'package:flutter/material.dart';
import './models/call_details.dart';

class CallingScreen extends StatefulWidget {
  final CallDetails callDetails;

  const CallingScreen({super.key, required this.callDetails});

  @override
  State<CallingScreen> createState() => _CallingScreenState();
}

class _CallingScreenState extends State<CallingScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: Text("Calling Screen")),
    );
  }
}