import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:elder_link/home_page.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sms/flutter_sms.dart';
import '../emergency_contact/emergency_contact_database.dart';
import '../main.dart';

class MedicineDetailsPage extends StatelessWidget {
  final String medicineName;
  final String dosage;

  const MedicineDetailsPage({
    Key? key,
    required this.medicineName,
    required this.dosage,
  }) : super(key: key);

  Future<List<String>> fetchContactNumbers() async {
    final contacts = await EmergencyContactDatabase.instance.getEmergencyContacts();
    return contacts.map((contact) => contact.number).toList();
  }

  void _sendSMS(String message, List<String> recipients) async {
    String result = await sendSMS(message: message, recipients: recipients, sendDirect: true)
        .catchError((onError) {
      if (kDebugMode) {
        print(onError);
      }
    });
    if (kDebugMode) {
      print(result);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Medical Record'),
        automaticallyImplyLeading: false,
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
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Text('Medicine: $medicineName', style: const TextStyle(fontSize: 36,)),
            Text('Dosage: $dosage', style: const TextStyle(fontSize: 36,)),
            const SizedBox(height: 100,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () {
                    AwesomeNotifications().dismiss(1);
                    MyApp.navigatorKey.currentState?.push(
                      MaterialPageRoute(
                        builder: (_) => const HomePage()
                      ),
                    );
                  },
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(Colors.green),
                    shape: MaterialStateProperty.all<OutlinedBorder>(
                      const CircleBorder(),
                    ),
                    minimumSize: MaterialStateProperty.all<Size>(
                      const Size(80, 80),
                    ),
                  ),
                  child: const Text(
                    '✓',
                    style: TextStyle(fontSize: 24, color: Colors.white),
                  ),
                ),
                ElevatedButton(
                  onPressed: () async {
                    List<String> recipients = await fetchContactNumbers();
                    if (recipients.isNotEmpty) {
                      String message = "$medicineName with dosage $dosage was not taken!";
                      _sendSMS(message, recipients);
                    }

                    AwesomeNotifications().dismiss(1);
                    MyApp.navigatorKey.currentState?.push(
                      MaterialPageRoute(
                        builder: (_) => const HomePage(),
                      ),
                    );
                  },

                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(Colors.red),
                    shape: MaterialStateProperty.all<OutlinedBorder>(
                      const CircleBorder(),
                    ),
                    minimumSize: MaterialStateProperty.all<Size>(
                      const Size(80, 80),
                    ),
                  ),
                  child: const Text(
                    '✗',
                    style: TextStyle(fontSize: 24, color: Colors.white),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
