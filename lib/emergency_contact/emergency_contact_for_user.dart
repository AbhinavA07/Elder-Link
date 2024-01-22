import 'package:flutter/material.dart';
import 'emergency_contact.dart';
import 'emergency_contact_database.dart';

class EmergencyContactUser extends StatelessWidget {
  const EmergencyContactUser({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Emergency Contacts'),
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
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xffdbecf5), Color(0xfff9ebf0)],
            stops: [0.25, 0.75],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: FutureBuilder(
          future: EmergencyContactDatabase.instance.getEmergencyContacts(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              if (snapshot.hasData) {
                final emergencyContacts = snapshot.data;
                if (emergencyContacts != null && emergencyContacts.isNotEmpty) {
                  return SizedBox(
                    height: MediaQuery.of(context).size.height,
                    child: ListView.builder(
                      padding: const EdgeInsets.all(16.0),
                      itemCount: emergencyContacts.length,
                      itemBuilder: (context, index) {
                        final emergencyContact = emergencyContacts[index];
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 16.0),
                          child: InkWell(
                            onTap: () {
                              // Handle contact card tap if needed
                            },
                            child: EmergencyContactCardUser(
                              emergencyContact: emergencyContact,
                            ),
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
              } else {
                return const Text('No emergency contacts found.');
              }
            } else if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            } else {
              return const CircularProgressIndicator();
            }
          },
        ),
      ),
    );
  }
}

class EmergencyContactCardUser extends StatelessWidget {
  const EmergencyContactCardUser({
    Key? key,
    required this.emergencyContact,
  }) : super(key: key);

  final EmergencyContact emergencyContact;

  @override
  Widget build(BuildContext context) {
    return Material(
      type: MaterialType.transparency,
      child: InkWell(
        borderRadius: BorderRadius.circular(20.0),
        onTap: () {
          // Handle tap on the card
          // You can navigate to another screen or perform other actions
        },
        child: Container(
          padding: const EdgeInsets.all(16.0),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey),
            borderRadius: BorderRadius.circular(20.0),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                emergencyContact.name,
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  color: Colors.blue.shade900,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8.0),
              Text(
                'Contact Number: ${emergencyContact.number}',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 16.0),
            ],
          ),
        ),
      ),
    );
  }
}
