import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:permission_handler/permission_handler.dart';

class ContactService {
  /// Request permission to access contacts
  static Future<bool> requestContactsPermission() async {
    var status = await Permission.contacts.status;
    if (!status.isGranted) {
      status = await Permission.contacts.request();
    }
    return status.isGranted;
  }

  /// Fetch all contacts with phone numbers
  static Future<List<Contact>> getContacts() async {
    if (await requestContactsPermission()) {
      List<Contact> contacts = await FlutterContacts.getContacts(withProperties: true);
      return contacts.where((contact) => contact.phones.isNotEmpty).toList();
    }
    return [];
  }

  /// Pick a contact and ensure it has a phone number
  static Future<Contact?> pickContact() async {
    if (await requestContactsPermission()) {
      Contact? contact = await FlutterContacts.openExternalPick();
      if (contact != null) {
        // Fetch full contact details to ensure phone numbers are included
        Contact? fullContact = await FlutterContacts.getContact(contact.id, withProperties: true);
        if (fullContact != null && fullContact.phones.isNotEmpty) {
          return fullContact;
        }
      }
    }
    return null;
  }
}
