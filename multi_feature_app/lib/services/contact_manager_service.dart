// Packages
import 'package:cloud_firestore/cloud_firestore.dart';

// Models
import '../models/contact_manager_model.dart';

class ContactManagerService {
  final CollectionReference _contacts = FirebaseFirestore.instance.collection(
    'contacts',
  );

  Future<void> addContact(Contact contact) async {
    await _contacts.doc(contact.id).set({
      'name': contact.name,
      'phone': contact.phone,
    });
  }

  Stream<List<Contact>> getContacts() {
    return _contacts.snapshots().map(
      (snapshot) => snapshot.docs
          .map(
            (doc) =>
                Contact(id: doc.id, name: doc['name'], phone: doc['phone']),
          )
          .toList(),
    );
  }
}
