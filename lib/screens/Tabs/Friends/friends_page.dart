import 'package:flutter/material.dart';

class FriendsPage extends StatefulWidget {
  const FriendsPage({super.key});
  @override
  _FriendsPageState createState() => _FriendsPageState();
}

class _FriendsPageState extends State<FriendsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Trusted Contacts'),
        actions: [
          IconButton(
            onPressed: () {
              print("Add Contact");
            },
            icon: const Icon(Icons.add),
          ),
        ],
      ),
      body: Center(child: Text('No Contacts Added')),
    );
  }
}
