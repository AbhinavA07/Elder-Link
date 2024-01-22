import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';

import '../home_page.dart';
import '../main.dart';

class AppointmentDetailsPage extends StatelessWidget {
  final String appointmentName;
  final String location;
  const AppointmentDetailsPage({
    super.key,
    required this.appointmentName,
    required this.location
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Appointment Details'),
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
            Center(child: Text('Appointment Title: $appointmentName', style: const TextStyle(fontSize: 36,))),
            Center(child: Text('Location: $location', style: const TextStyle(fontSize: 36,))),
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
                ],
            ),
          ],
        ),
      ),
    );
  }
}