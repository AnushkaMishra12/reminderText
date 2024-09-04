import 'package:path/path.dart';
import 'package:reminder/reminder_model.dart';
import 'package:sqflite/sqflite.dart';

class ReminderDatabaseHelper {
  static final ReminderDatabaseHelper _instance =
      ReminderDatabaseHelper._internal();
  static Database? _database;

  ReminderDatabaseHelper._internal();

  factory ReminderDatabaseHelper() {
    return _instance;
  }

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'reminder.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE reminders(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        title TEXT,
        description TEXT,
        dateTime TEXT
      )
    ''');
  }

  Future<int> insertReminder(Reminder reminder) async {
    final db = await database;

    return await db.insert('reminders', reminder.toMap());
  }

  Future<List<Reminder>> getReminders() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('reminders');
    return List.generate(maps.length, (i) => Reminder.fromMap(maps[i]));
  }

  Future<void> deleteReminder(int id) async {
    final db = await database;
    await db.delete('reminders', where: 'id = ?', whereArgs: [id]);
  }
}
