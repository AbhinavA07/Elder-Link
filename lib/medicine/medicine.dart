import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:elder_link/services/notification_api.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'medicine_database.dart';

class MedicinePage extends StatefulWidget {
  const MedicinePage({Key? key}) : super(key: key);

  @override
  _MedicinePageState createState() => _MedicinePageState();
}

class _MedicinePageState extends State<MedicinePage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController dosageController = TextEditingController();
  //final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
  DateTime? selectedTime;
  List<Medicine> medicines = [];

  Future<void> deleteMedicine(int id) async {
    final medicineToDelete = await MedicineDatabase.instance.getMedicine(id);
    if (medicineToDelete != null) {
      await MedicineDatabase.instance.deleteMedicine(id);
      final updatedMedicines = await MedicineDatabase.instance.getMedicines();
      fetchMedicines();
      setState(() {
        medicines = updatedMedicines;
      });
    }
  }


  @override
  void initState() {
    super.initState();
    fetchMedicines();
  }
  

  void fetchMedicines() async {
    final medicineList = await MedicineDatabase.instance.getMedicines();
    setState(() {
      medicines = medicineList;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Medicine'),
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
                children: [
                  TextFormField(
                    controller: nameController,
                    decoration: InputDecoration(
                      labelText: 'Medicine Name',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                      prefixIcon: const Icon(Icons.local_hospital), // Add icon
                    ),
                    style: const TextStyle(
                      fontSize: 18.0,
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a medicine name';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16.0),
                  TextFormField(
                    controller: dosageController,
                    decoration: InputDecoration(
                      labelText: 'Dosage',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                      prefixIcon: const Icon(Icons.opacity), // Add icon
                    ),
                    style: const TextStyle(
                      fontSize: 18.0,
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a dosage';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16.0),
                  ElevatedButton(
                    onPressed: () async {
                      // Show time picker to select alarm time
                      final selected = await showTimePicker(
                        context: context,
                        initialTime: TimeOfDay.now(),
                      );

                      if (selected != null) {
                        setState(() {
                          selectedTime = DateTime(
                            DateTime.now().year,
                            DateTime.now().month,
                            DateTime.now().day,
                            selected.hour,
                            selected.minute,
                          );
                        });
                      }
                    },
                    style: TextButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16.0),
                      ),
                    ),
                    child: Text(
                      selectedTime != null
                          ? 'Alarm Time: ${DateFormat.jm().format(selectedTime!)}'
                          : 'Select Alarm Time',
                    ),
                  ),
                  const SizedBox(height: 16.0),
                  ElevatedButton(
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        final name = nameController.text;
                        final dosage = dosageController.text;
                        if (selectedTime == null) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: const Text('Please select an alarm time'),
                              backgroundColor: Colors.red,
                              elevation: 10.0,
                              behavior: SnackBarBehavior.floating,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20.0),
                              ),
                            ),
                          );
                          return; // Don't proceed if alarm time is not selected
                        }

                        final id = DateTime
                            .now()
                            .microsecondsSinceEpoch % 1000000000;
                        final medicine = Medicine(
                          id: id,
                          name: name,
                          dosage: dosage,
                          selectedTime: selectedTime!.millisecondsSinceEpoch,
                        );
                        if(selectedTime!.isBefore(DateTime.now())){
                          selectedTime?.add(const Duration(days: 1));
                        }
                        await MedicineDatabase.instance.insertMedicine(medicine);
                        await NotificationService.showMedicineNotification(
                            id: id,
                            title: name,
                            body: dosage,
                            summary: 'Please Take Water',
                            scheduled: true,
                            scheduleDate: selectedTime!,
                            payload: {
                              "navigate": "medicine",
                              'medicineName': name,
                              'dosage': dosage,
                            },
                            actionButtons: [
                              NotificationActionButton(
                                  key: 'check',
                                  label: 'Record',
                                  actionType: ActionType.Default,
                                  color: Colors.green,
                              )
                            ]
                        );

                        nameController.clear();
                        dosageController.clear();
                        setState(() {
                          selectedTime = null;
                        });

                        fetchMedicines();

                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: const Text('Medicine added successfully'),
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
                    child: const Text('Add Medicine'),
                  ),
                  const SizedBox(height: 25.0),
                  FutureBuilder(
                    future: MedicineDatabase.instance.getMedicines(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.done) {
                        if (snapshot.hasData) {
                          final medicines = snapshot.data;
                          if (medicines != null && medicines.isNotEmpty) {
                            return SizedBox(
                              height: 550,
                              child: ListView.builder(
                                itemCount: medicines.length,
                                itemBuilder: (context, index) {
                                  final medicine = medicines[index];
                                  return Padding(
                                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                                    child: MedicineCard(
                                      medicine: medicine,
                                      onDelete: () {
                                        deleteMedicine(medicine.id);
                                        setState(() {
                                          medicines.removeAt(index);
                                        });
                                      },
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
                          return const Text('No medicines found.');
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


class MedicineCard extends StatelessWidget {
  const MedicineCard({
    Key? key,
    required this.medicine,
    required this.onDelete,
  }) : super(key: key);

  final Medicine? medicine;
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
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        medicine!.name,
                        style: const TextStyle(
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16.0),
                      Text('Dosage: ${medicine!.dosage}'),
                      const SizedBox(height: 16.0),
                      Text(
                        'Alarm Time: ${DateFormat.jm().format(DateTime.fromMillisecondsSinceEpoch(medicine!.selectedTime))}',
                      ),
                    ],
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20.0),
                          ),
                          title: const Text('Delete Medicine'),
                          content: Text('Are you sure you want to delete ${medicine?.name ?? 'this medicine'}?'),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              style: TextButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16.0),
                                ),
                              ),
                              child: const Text('Cancel'),
                            ),
                            TextButton(
                              onPressed: () {
                                onDelete();
                                AwesomeNotifications().cancelSchedule(medicine!.id);
                                Navigator.pop(context);
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: const Text('Medicine deleted successfully'),
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
                    minimumSize: const Size(100.0, 36.0), backgroundColor: Colors.red, // Adjust width as needed
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.0),
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
