import 'package:flutter/material.dart';

class FakeCallScreen extends StatelessWidget {
  final Widget callerDetailsWidget; // Accept a widget as a parameter

  const FakeCallScreen({Key? key, required this.callerDetailsWidget})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Fake Call")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            callerDetailsWidget, // Inject the CallerDetailsCard widget
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Start Fake Call Logic Here
              },
              child: const Text("Start Fake Call"),
            ),
          ],
        ),
      ),
    );
  }
}
