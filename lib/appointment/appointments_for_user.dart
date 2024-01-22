import 'package:flutter/material.dart';
import 'appointment_database.dart';

String _formatDate(DateTime date) {
  return '${date.month}/${date.day}/${date.year}';
}

class AppointmentsUser extends StatelessWidget {
  const AppointmentsUser({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Appointments'),
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
          future: AppointmentDatabase.instance.getAppointments(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              if (snapshot.hasData) {
                final appointments = snapshot.data;
                if (appointments != null && appointments.isNotEmpty) {
                  return SizedBox(
                    height: MediaQuery.of(context).size.height,
                    child: ListView.builder(
                      padding: const EdgeInsets.all(16.0), // Add padding to the ListView
                      itemCount: appointments.length,
                      itemBuilder: (context, index) {
                        final appointment = appointments[index];
                        return Padding(
                            padding: const EdgeInsets.only(bottom: 16.0), // Add vertical spacing between cards
                            child: AppointmentCardUser(appointment: appointment));
                      },
                    ),
                  );
                } else {
                  return const Center(
                    child: Text('No appointments found.'),
                  );
                }
              } else {
                return const Text('No appointments found.');
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

class AppointmentCardUser extends StatelessWidget {
  const AppointmentCardUser({
    Key? key,
    required this.appointment,
  }) : super(key: key);

  final Appointment appointment;

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
                appointment.title,
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  color: Colors.blue.shade900,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8.0),
              Text(
                'Location: ${appointment.location}',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 8.0),
              Text(
                'Date: ${_formatDate(appointment.date)}',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 8.0),
              Text(
                'Time: ${appointment.time.format(context)}',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: Colors.black87,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}