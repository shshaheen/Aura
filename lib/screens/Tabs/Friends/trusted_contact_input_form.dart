import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:aura/screens/Tabs/Friends/contact_service.dart';
import 'package:flutter_contacts/flutter_contacts.dart';


class TrustedContactInputForm extends StatefulWidget {
  const TrustedContactInputForm({super.key});

  @override
  State<TrustedContactInputForm> createState() => _State();
}

class _State extends State<TrustedContactInputForm> {
  @override
   final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final CollectionReference contactsCollection =
      FirebaseFirestore.instance.collection('contacts');
  bool _isLoading = false;
Future<void> pickContact() async {
  Contact? contact = await ContactService.pickContact();
  if (contact != null && contact.phones.isNotEmpty) {
    setState(() {
      _nameController.text = contact.displayName;
      _phoneController.text = contact.phones.first.number;
    });
  } else {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('No valid phone number found'), backgroundColor: Colors.red),
    );
  }
}

  Future<void> addContact() async {
    if (_nameController.text.isEmpty || _phoneController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please enter both name and phone number'), backgroundColor: Colors.red),
      );
      return;
    }
    setState(() => _isLoading = true);

    try {
      await contactsCollection.add({
        "name": _nameController.text.trim(),
        "phone": _phoneController.text.trim(),
        "addedAt": FieldValue.serverTimestamp(),
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Contact added successfully!'), backgroundColor: Colors.green),
      );
      // Navigator.push(context, MaterialPageRoute(builder: (context)=>))
      _nameController.clear();
      _phoneController.clear();
      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to add contact'), backgroundColor: Colors.red),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Add Friends')),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _nameController,
              decoration: InputDecoration(labelText: 'Name'),
            ),
            TextField(
              controller: _phoneController,
              decoration: InputDecoration(labelText: 'Phone Number'),
              keyboardType: TextInputType.phone,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: pickContact,
              child: Text('Select from Contacts'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _isLoading ? null : addContact,
              child: _isLoading
                  ? CircularProgressIndicator(color: Colors.white)
                  : Text('Submit'),
            ),
          ],
        ),
      ),
    );
  }
}