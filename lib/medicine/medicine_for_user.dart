import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'medicine_database.dart';

class MedicineUser extends StatelessWidget {
  const MedicineUser({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Medicines'),
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
          future: MedicineDatabase.instance.getMedicines(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              if (snapshot.hasData) {
                final medicines = snapshot.data;
                if (medicines != null && medicines.isNotEmpty) {
                  return SizedBox(
                    height: MediaQuery.of(context).size.height,
                    child: ListView.builder(
                      padding: const EdgeInsets.all(16.0),
                      itemCount: medicines.length,
                      itemBuilder: (context, index) {
                        final medicine = medicines[index];
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 16.0),
                          child: InkWell(
                            onTap: () {
                            },
                            child: MedicineCardUser(medicine: medicine),
                          ),
                        );
                      },
                    ),
                  );
                } else {
                  return const Center(
                    child: Text('No medicines found.'),
                  );
                }
              } else {
                return const Center(child: Text('No medicines found.'));
              }
            } else if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            } else {
              return const Center(child: CircularProgressIndicator());
            }
          },
        ),
      ),
    );
  }
}

class MedicineCardUser extends StatelessWidget {
  const MedicineCardUser({
    Key? key,
    required this.medicine,
  }) : super(key: key);

  final Medicine? medicine;

  @override
  Widget build(BuildContext context) {
    return Material(
      type: MaterialType.transparency,
      child: InkWell(
        borderRadius: BorderRadius.circular(20.0),
        onTap: () {
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
                medicine!.name,
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  color: Colors.blue.shade900,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12.0),
              Text(
                'Dosage: ${medicine!.dosage}',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 12.0),
              Text(
                'Alarm Time: ${DateFormat.jm().format(DateTime.fromMillisecondsSinceEpoch(medicine!.selectedTime))}',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Colors.black54,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
