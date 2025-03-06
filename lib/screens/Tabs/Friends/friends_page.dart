import 'package:flutter/material.dart';
import 'trusted_contact_input_form.dart';

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
              Navigator.push(
                context, 
                MaterialPageRoute(
                  builder: (context)=> TrustedContactInputForm()
                )
              );
            },
            icon: const Icon(Icons.add),
          ),
        ],
      ),
      body: Center(child: Text('No Contacts Added')),
    );
  }
}
