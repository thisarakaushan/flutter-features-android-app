// Packages
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

// Models
import '../models/contact_manager_model.dart';

// Services
import '../services/contact_manager_service.dart';

// Widgets
import '../widgets/contact_card.dart';
import '../widgets/custom_button.dart';
import '../widgets/custom_input_field.dart';

class ContactsManagerScreen extends StatefulWidget {
  const ContactsManagerScreen({super.key});

  @override
  State<ContactsManagerScreen> createState() => _ContactsManagerScreenState();
}

class _ContactsManagerScreenState extends State<ContactsManagerScreen> {
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final ContactManagerService _contactService = ContactManagerService();
  final _formKey = GlobalKey<FormState>();

  void _addContact() async {
    if (_formKey.currentState!.validate()) {
      final contact = Contact(
        id: const Uuid().v4(),
        name: _nameController.text,
        phone: _phoneController.text,
      );
      await _contactService.addContact(contact);
      _nameController.clear();
      _phoneController.clear();

      if (!mounted) return;

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Contact Added!')));
    }
  }

  String? _validateInput(String? value) {
    if (value == null || value.isEmpty) {
      return 'This field is required';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Contacts Manager')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  CustomInputField(
                    controller: _nameController,
                    label: 'Name',
                    validator: _validateInput,
                  ),
                  CustomInputField(
                    controller: _phoneController,
                    label: 'Phone',
                    keyboardType: TextInputType.phone,
                    validator: _validateInput,
                  ),
                  const SizedBox(height: 20),
                  CustomButton(text: 'Add Contact', onPressed: _addContact),
                ],
              ),
            ),
          ),
          Expanded(
            child: StreamBuilder<List<Contact>>(
              stream: _contactService.getContacts(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }
                final contacts = snapshot.data!;
                return ListView.builder(
                  itemCount: contacts.length,
                  itemBuilder: (context, index) {
                    final contact = contacts[index];
                    return ContactCard(contact: contact);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    super.dispose();
  }
}
