import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

import 'emergency_contact.dart';

class EmergencyContactDatabase {
  EmergencyContactDatabase._();
  static final EmergencyContactDatabase instance = EmergencyContactDatabase._();

  Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await initDatabase();
    return _database!;
  }

  Future<Database> initDatabase() async {
    final String path = join(await getDatabasesPath(), 'emergency_contact_database.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: (Database db, int version) async {
        await db.execute('''
          CREATE TABLE emergency_contacts(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            name TEXT,
            number TEXT
          )
        ''');
      },
    );
  }

  Future<List<EmergencyContact>> getEmergencyContacts() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('emergency_contacts');

    return List.generate(maps.length, (index) {
      return EmergencyContact(
        id: maps[index]['id'] as int,
        name: maps[index]['name'] as String,
        number: maps[index]['number'] as String,
      );
    });
  }

  Future<void> insertEmergencyContact(EmergencyContact emergencyContact) async {
    final db = await database;
    await db.insert('emergency_contacts', emergencyContact.toMap());
  }

  Future<void> deleteEmergencyContact(int id) async {
    final db = await database;
    await db.delete(
      'emergency_contacts',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

}
