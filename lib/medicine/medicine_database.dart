import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class MedicineDatabase {
  MedicineDatabase._();
  static final MedicineDatabase instance = MedicineDatabase._();

  Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await initDatabase();
    return _database!;
  }

  Future<Database> initDatabase() async {
    final String path = join(await getDatabasesPath(), 'medicine_database.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: (Database db, int version) async {
        await db.execute('''
          CREATE TABLE medicines(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            name TEXT,
            dosage TEXT,
            selectedTime INTEGER
          )
        ''');
      },
    );
  }

  Future<Medicine?> getMedicine(int id) async {
    final db = await database;
    final List<Map<String, dynamic>> maps =
    await db.query('medicines', where: 'id = ?', whereArgs: [id]);

    if (maps.isEmpty) {
      return null;
    }

    return Medicine(
      id: maps[0]['id'] as int,
      name: maps[0]['name'] as String,
      dosage: maps[0]['dosage'] as String,
      selectedTime: maps[0]['selectedTime']
      );
  }

  Future<List<Medicine>> getMedicines() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('medicines');

    return List.generate(maps.length, (index) {
      return Medicine(
        id: maps[index]['id'] as int,
        name: maps[index]['name'] as String,
        dosage: maps[index]['dosage'] as String,
        selectedTime: maps[index]['selectedTime']
      );
    });
  }

  Future<void> insertMedicine(Medicine medicine) async {
    final db = await database;
    await db.insert('medicines', medicine.toMap());
  }

  Future<void> deleteMedicine(int id) async {
    final db = await database;
    await db.delete(
      'medicines',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

}

class Medicine {
  final int id;
  final String name;
  final String dosage;
  final int selectedTime;

  Medicine({
    required this.id,
    required this.name,
    required this.dosage,
    required this.selectedTime,
  });

  Map<String, dynamic> toMap() {
    return {
      'id' : id,
      'name': name,
      'dosage': dosage,
      'selectedTime': selectedTime,
    };
  }
}

// class AddMedicinePage extends StatefulWidget {
//   const AddMedicinePage({Key? key}) : super(key: key);
//
//   @override
//   State<AddMedicinePage> createState() => _AddMedicinePageState();
// }
//
// class _AddMedicinePageState extends State<AddMedicinePage> {
//   final _medicineNameController = TextEditingController();
//   final _medicineDosageController = TextEditingController();
//   final _formKey = GlobalKey<FormState>();
//   DateTime? selectedTime;
//   int? selectedId;
//   List<Medicine> medicines = [];
//
//   @override
//   void initState() {
//     super.initState();
//     fetchMedicines();
//   }
//
//   void fetchMedicines() async {
//     final medicineList = await MedicineDatabase.instance.getMedicines();
//     setState(() {
//       medicines = medicineList;
//     });
//   }
//
//   void deleteMedicine(int id) async {
//     await MedicineDatabase.instance.deleteMedicine(id);
//
//     // Update the list of medicines in the UI after deletion
//     fetchMedicines();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Add Medicine'),
//       ),
//       body: SingleChildScrollView(
//         child: Padding(
//           padding: const EdgeInsets.all(16.0),
//           child: Column(
//             children: [
//               TextField(
//                 controller: _medicineNameController,
//                 decoration: const InputDecoration(
//                   labelText: 'Medicine Name',
//                 ),
//               ),
//               const SizedBox(height: 16.0),
//               TextField(
//                 controller: _medicineDosageController,
//                 decoration: const InputDecoration(
//                   labelText: 'Medicine Dosage',
//                 ),
//               ),
//               const SizedBox(height: 16.0),
//               ElevatedButton(
//                 onPressed: () async {
//                   if (_formKey.currentState!.validate()) {
//                     final name = _medicineNameController.text;
//                     final dosage = _medicineDosageController.text;
//                     if (selectedTime == null) {
//                       ScaffoldMessenger.of(context).showSnackBar(
//                         const SnackBar(
//                           content: Text('Please select an alarm time'),
//                           backgroundColor: Colors.red,
//                         ),
//                       );
//                       return; // Don't proceed if alarm time is not selected
//                     }
//
//                     final now = DateTime.now();
//                     final alarmTime = DateTime(
//                       now.year,
//                       now.month,
//                       selectedTime!.hour,
//                       selectedTime!.minute,
//                     );
//
//                     final id = DateTime
//                         .now()
//                         .microsecondsSinceEpoch % 1000000000;
//                     selectedId = id;
//                     final medicine = Medicine(
//                       id: id,
//                       name: name,
//                       dosage: dosage,
//                       selectedTime: alarmTime.millisecondsSinceEpoch,
//                     );
//
//                     // print(selectedId);
//                     // print(alarmTime);
//                     // print(selectedTime);
//                     await MedicineDatabase.instance.insertMedicine(medicine);
//                     // print(selectedTime);
//                     // print(alarmTime);
//                     // print('${TimeOfDay.fromDateTime(selectedTime!)}');
//                     DateTime getNextScheduledDate(DateTime currentTime, DateTime selectedTime) {
//                       final difference = selectedTime.difference(currentTime);
//                       return currentTime.add(difference);
//                     }
//                     await NotificationService.showNotification(
//                       id: id,
//                       title: name,
//                       body: dosage,
//                       summary: 'Please Take Water',
//                       scheduleDate: getNextScheduledDate(now, alarmTime),
//                     );
//
//                     _medicineNameController.clear();
//                     _medicineDosageController.clear();
//                     setState(() {
//                       selectedTime = null;
//                     });
//
//                     fetchMedicines();
//
//                     ScaffoldMessenger.of(context).showSnackBar(
//                       const SnackBar(
//                         content: Text('Medicine added successfully'),
//                         backgroundColor: Colors.green,
//                       ),
//                     );
//                   }
//
//                 },
//                 style: ButtonStyle(
//                   backgroundColor: MaterialStateProperty.all(
//                     Colors.blue,
//                   ),
//                 ),
//                 child: const Text('Add Medicine'),
//               ),
//
//               for (var medicine in medicines)
//                 MedicineCard(
//                   id: selectedId ?? -1,
//                   medicine: medicine,
//                   onDelete: () {
//                     // Delete the medicine when the delete button is pressed
//                     deleteMedicine(medicine.id);
//                   },
//                 ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }