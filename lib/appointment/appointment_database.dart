import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import '../services/notification_api.dart';
import 'appointment.dart';

String _formatDate(DateTime date) {
  // Format the date as per your requirement
  return '${date.month}/${date.day}/${date.year}';
}

class AppointmentDatabase {
  static final AppointmentDatabase instance = AppointmentDatabase._init();

  static Database? _database;

  AppointmentDatabase._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('appointments.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final db = await openDatabase(
      filePath,
      version: 1,
      onCreate: (db, version) async {
        await db.execute(
          '''CREATE TABLE appointments(
                id INTEGER PRIMARY KEY AUTOINCREMENT,
                title TEXT,
                location TEXT,
                date TEXT,
                time TEXT
              )
              ''',
        );
      },
    );
    return db;
  }

  Future<void> insertAppointment(Appointment appointment) async {
    final db = await database;
    await db.insert(
      'appointments',
      appointment.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Appointment>> getAppointments() async {
    final db = await database;
    final maps = await db.query('appointments');
    return List.generate(maps.length, (index) {
      return Appointment(
        id: maps[index]['id'] as int,
        title: maps[index]['title'] as String,
        location: maps[index]['location'] as String,
        date: DateTime.parse(maps[index]['date'] as String),
        time: TimeOfDay(
          hour: int.parse(maps[index]['time'].toString().split(":")[0]),
          minute: int.parse(maps[index]['time'].toString().split(":")[1]),
        ),
      );
    });
  }

  Future<void> deleteAppointment(int id) async {
    final db = await database;
    await db.delete(
      'appointments',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}

class Appointment {
  final int id;
  final String title;
  final String location;
  final DateTime date;
  final TimeOfDay time;

  Appointment({
    required this.id,
    required this.title,
    required this.location,
    required this.date,
    required this.time,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'location': location,
      'date': date.toIso8601String(),
      'time': '${time.hour}:${time.minute}',
    };
  }
}

class AddAppointmentPage extends StatefulWidget {
  const AddAppointmentPage({Key? key}) : super(key: key);

  @override
  _AddAppointmentPageState createState() => _AddAppointmentPageState();
}

class _AddAppointmentPageState extends State<AddAppointmentPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController titleController = TextEditingController();
  final TextEditingController locationController = TextEditingController();
  DateTime selectedDate = DateTime.now();
  TimeOfDay selectedTime = TimeOfDay.now();
  List<Appointment> appointments = [];
  late ScaffoldMessengerState _scaffoldMessenger;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scaffoldMessenger = ScaffoldMessenger.of(context);
    });
  }

  Future<void> deleteAppointment(int id) async {
    await AppointmentDatabase.instance.deleteAppointment(id);

    // Fetch appointments again from the database after deletion
    final updatedAppointments = await AppointmentDatabase.instance.getAppointments();

    setState(() {
      // Update the appointment list displayed in the UI
      // Make sure you have a property named 'appointments' in your class
      appointments = updatedAppointments;
    });
  }

  @override
  Widget build(BuildContext context) {
    _scaffoldMessenger = ScaffoldMessenger.of(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Appointment'),
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
                    controller: titleController,
                    decoration: InputDecoration(
                      labelText: 'Title',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                      prefixIcon: const Icon(Icons.event_note),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a title';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16.0),
                  TextFormField(
                    controller: locationController,
                    decoration: InputDecoration(
                      labelText: 'Location',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                      prefixIcon: const Icon(Icons.location_on),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a location';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16.0),
                  InkWell(
                    onTap: () async {
                      final DateTime? pickedDate = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime.now(),
                        lastDate: DateTime(2101),
                      );
                      setState(() {
                        selectedDate = pickedDate!;
                      });
                    },
                    child: ListTile(
                      title: const Text('Date'),
                      subtitle: Text(
                        _formatDate(selectedDate), // Format the date
                      ),
                      leading: const Icon(Icons.calendar_today), // Add an icon
                    ),
                  ),

                  InkWell(
                    onTap: () async {
                      final TimeOfDay? pickedTime = await showTimePicker(
                        context: context,
                        initialTime: TimeOfDay.now(),
                      );
                      setState(() {
                        selectedTime = pickedTime!;
                      });
                    },
                    child: ListTile(
                      title: const Text('Time'),
                      subtitle: Text(
                        selectedTime.format(context), // Format the time
                      ),
                      leading: const Icon(Icons.access_time), // Add an icon
                    ),
                  ),

                  const SizedBox(height: 8.0),
                  Center(
                    child: ElevatedButton(
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          try {
                            final title = titleController.text;
                            final location = locationController.text;
                            final uniqueIdentifier = '$title-${selectedDate.toIso8601String()}';
                            final id = uniqueIdentifier.hashCode;
                            final appointment = Appointment(
                              id: id,
                              title: title,
                              location: location,
                              date: selectedDate,
                              time: selectedTime,
                            );
                            final correctedDate = DateTime(
                              selectedDate.year,
                              selectedDate.month,
                              selectedDate.day,
                              selectedTime.hour,
                              selectedTime.minute,
                              0
                            );
                            await AppointmentDatabase.instance.insertAppointment(appointment);
                            await NotificationService.showAppointmentNotification(
                              id: id,
                              title: title,
                              body: location,
                              scheduleDate: correctedDate,
                              scheduled: true,
                              payload: {
                                "navigate": "appointment",
                                "appointmentName": title,
                                "location":location
                              },
                            );

                            // Clear text fields and reset selectedDate, selectedTime
                            titleController.clear();
                            locationController.clear();
                            setState(() {
                              selectedDate = DateTime.now();
                              selectedTime = TimeOfDay.now();
                            });

                            _scaffoldMessenger.showSnackBar(
                              SnackBar(
                                content: const Text('Appointment added successfully'),
                                backgroundColor: Colors.green,
                                elevation: 10.0,
                                behavior: SnackBarBehavior.floating,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20.0),
                                ),
                              ),
                            );
                          } catch (e) {
                            _scaffoldMessenger.showSnackBar(
                              SnackBar(
                                content: const Text('Error adding appointment'),
                                backgroundColor: Colors.red,
                                elevation: 10.0,
                                behavior: SnackBarBehavior.floating,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20.0),
                                ),
                              ),
                            );
                          }
                        }
                      },
                      style: TextButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16.0),
                        ),
                      ),
                      child: const Text('Save Appointment'),
                    ),
                  ),
                  const SizedBox(height: 20.0),
                  FutureBuilder(
                    future: AppointmentDatabase.instance.getAppointments(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.done) {
                        final appointments = snapshot.data;
                        if(appointments != null && appointments.isNotEmpty){
                          return SizedBox(
                            height: 460,
                            child: ListView.builder(
                              itemCount: appointments.length,
                              itemBuilder: (context, index) {
                                final appointment = appointments[index];
                                return Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                                  child: AppointmentCard(
                                    appointment: appointment,
                                    onDelete: () {
                                      deleteAppointment(appointment.id);
                                    },
                                  ),
                                );
                              },
                            ),
                          );
                        } else {
                          return const Center(
                            child: Text('No appointments found.'),
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
