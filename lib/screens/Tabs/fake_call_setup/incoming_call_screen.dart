import 'package:flutter/material.dart';

class FakeCall extends StatefulWidget {
  const FakeCall({super.key});
  @override
  State<FakeCall> createState() => _FakeCallState();
}

class _FakeCallState extends State<FakeCall> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: Text("Incoming Call")),
    );
  }
}