import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'emergency_contact_database.dart';

class EmergencyContactPage extends StatefulWidget {
  const EmergencyContactPage({Key? key}) : super(key: key);

  @override
  State<EmergencyContactPage> createState() => _EmergencyContactPageState();
}

class _EmergencyContactPageState extends State<EmergencyContactPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController numberController = TextEditingController();
  List<EmergencyContact> contacts = [];

  Future<void> deleteEmergencyContact(int id) async {
    await EmergencyContactDatabase.instance.deleteEmergencyContact(id);
    final updatedEmergencyContacts =
    await EmergencyContactDatabase.instance.getEmergencyContacts();
    setState(() {
      contacts = updatedEmergencyContacts;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Emergency Contacts'),
        backgroundColor: Colors.transparent,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Colors.blue.shade500,
                Colors.blue.shade800,
              ],
            ),
          ),
        ),
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xffdbecf5), Color(0xfff9ebf0)],
            stops: [0.25, 0.75],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextFormField(
                    controller: nameController,
                    decoration: InputDecoration(
                      labelText: 'Contact Name',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                      prefixIcon: const Icon(Icons.person),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a contact name';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16.0),
                  TextFormField(
                    controller: numberController,
                    keyboardType: TextInputType.number,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    maxLength: 10,
                    decoration: InputDecoration(
                      labelText: 'Contact Number',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                      prefixIcon: const Icon(Icons.phone),
                    ),
                    validator: (value) {
                      if (value == null || value.length != 10) {
                        return 'Please enter a valid 10-digit contact number';
                      }
                      return null;
                    },
                  ),

                  const SizedBox(height: 16.0),
                  Center(
                    child: ElevatedButton(
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          final name = nameController.text;
                          final number = numberController.text;
                          final id = DateTime.now().microsecondsSinceEpoch;
                          final emergencyContact = EmergencyContact(
                            id: id,
                            name: name,
                            number: number,
                          );

                          await EmergencyContactDatabase.instance
                              .insertEmergencyContact(emergencyContact);

                          // Clear text fields
                          nameController.clear();
                          numberController.clear();
                          setState(() {
                            contacts.add(emergencyContact);
                          });
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: const Text('Contact added successfully'),
                              backgroundColor: Colors.green,
                              elevation: 10.0,
                              behavior: SnackBarBehavior.floating,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20.0),
                              ),
                            ),
                          );
                        }
                      },
                      style: TextButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16.0),
                        ),
                      ),
                      child: const Text('Add Contact'),
                    ),
                  ),
                  const SizedBox(height: 25.0),
              FutureBuilder(
                future: EmergencyContactDatabase.instance.getEmergencyContacts(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    final emergencyContacts = snapshot.data;
                    if (emergencyContacts != null && emergencyContacts.isNotEmpty) {
                      return SizedBox(
                        height: 600,
                        child: ListView.builder(
                          itemCount: emergencyContacts.length,
                          itemBuilder: (context, index) {
                            final emergencyContact = emergencyContacts[index];
                            return Padding(
                              padding: const EdgeInsets.symmetric(vertical: 8.0),
                              child: EmergencyContactCard(
                                emergencyContact: emergencyContact,
                                onDelete: () {
                                  deleteEmergencyContact(emergencyContact.id);
                                  setState(() {
                                    contacts.removeAt(index);
                                  });
                                },
                              ),
                            );
                          },
                        ),
                      );
                    } else {
                      return const Center(
                        child: Text('No emergency contacts found.'),
                      );
                    }
                  } else if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  } else {
                    return const Center(child: CircularProgressIndicator());
                  }
                },
              ),
              ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class EmergencyContactCard extends StatelessWidget {
  const EmergencyContactCard({
    Key? key,
    required this.emergencyContact,
    required this.onDelete,
  }) : super(key: key);

  final EmergencyContact emergencyContact;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Material(
        type: MaterialType.transparency,
        borderRadius: BorderRadius.circular(20.0),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          borderRadius: BorderRadius.circular(20.0),
          onTap: () {
            // Handle onTap if needed
          },
          child: Container(
            padding: const EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(20.0),
            ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Left side: Contact Name and Number
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          emergencyContact.name,
                          style: const TextStyle(
                            fontSize: 18.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8.0),
                        Text(
                          'Contact Number: ${emergencyContact.number}',
                        ),
                      ],
                    ),
                  ),
                  // Right side: Delete Button
                  ElevatedButton(
                    onPressed: () {
                      // Show a confirmation dialog before deleting
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20.0),
                            ),
                            title: const Text('Delete Emergency Contact'),
                            content: Text(
                                'Are you sure you want to delete ${emergencyContact.name}?'),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                style: TextButton.styleFrom(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20.0),
                                  ),
                                ),
                                child: const Text('Cancel'),
                              ),
                              TextButton(
                                onPressed: () {
                                  onDelete();
                                  Navigator.pop(context);
                                  // Show a SnackBar when emergency contact is deleted successfully
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: const Text('Emergency contact deleted successfully'),
                                      backgroundColor: Colors.green,
                                      elevation: 10.0,
                                      behavior: SnackBarBehavior.floating,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(20.0),
                                      ),
                                    ),
                                  );
                                },
                                style: TextButton.styleFrom(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20.0),
                                  ),
                                ),
                                child: const Text('Delete'),
                              ),
                            ],
                          );
                        },
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(100.0, 36.0),
                      backgroundColor: Colors.red, // Adjust width as needed
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16.0),
                      ),
                    ),
                    child: const Text('Delete'),
                  ),
                ],
              ),
            ),
          ),
        ),
    );
  }
}

class EmergencyContact {
  final int id;
  final String name;
  final String number;

  EmergencyContact({
    required this.id,
    required this.name,
    required this.number,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'number': number,
    };
  }
}
