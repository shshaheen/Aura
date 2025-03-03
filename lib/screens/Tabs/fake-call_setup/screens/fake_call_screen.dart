import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:async';
import '../providers/fake_call_provider.dart';
import 'fake_call_input_screen.dart';
import 'incoming_call_screen.dart';

class FakeCallScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final fakeCallProvider = Provider.of<FakeCallProvider>(context);

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Fake Call",
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 16),
          Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Theme.of(context).secondaryHeaderColor,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [BoxShadow(color: Colors.grey.shade300, blurRadius: 4)],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(Icons.person, size: 40, color: Colors.teal),
                    SizedBox(width: 10),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          fakeCallProvider.callerName == "Set caller details"
                              ? "Caller Details"
                              : fakeCallProvider.callerName,
                          style: TextStyle(
                            fontSize: 18, 
                            fontWeight: FontWeight.bold, 
                            // color: Theme.of(context).colorScheme.onSecondaryContainer
                            ),
                        ),
                        if (fakeCallProvider.phoneNumber.isNotEmpty)
                          Text(fakeCallProvider.phoneNumber),
                      ],
                    ),
                  ],
                ),
                IconButton(
                  icon: Icon(Icons.edit),
                  onPressed: () async {
                    final result = await Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => FakeCallInputScreen()),
                    );

                    if (result != null) {
                      fakeCallProvider.updateCallerDetails(
                        result['name'],
                        result['phone'],
                        result['duration'],
                      );
                    }
                  },
                ),
              ],
            ),
          ),
          SizedBox(height: 20),
          Center(
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.teal,
                padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              ),
              onPressed: fakeCallProvider.isCallerSet
                  ? () {
                      Timer(Duration(seconds: fakeCallProvider.duration), () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => IncomingCallScreen()),
                        );
                      });
                    }
                  : null,
              child: Text("Schedule Call", style: TextStyle(fontSize: 16)),
            ),
          ),
        ],
      ),
    );
  }
}