import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class CalculatorDatabaseHelper {
  static final CalculatorDatabaseHelper _instance = CalculatorDatabaseHelper._internal();
  factory CalculatorDatabaseHelper() => _instance;
  CalculatorDatabaseHelper._internal();
  Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    return openDatabase(
      join(await getDatabasesPath(), 'calculator.db'),
      onCreate: (db, version) {
        return db.execute(
          'CREATE TABLE calculator_history(id INTEGER PRIMARY KEY AUTOINCREMENT, expression TEXT, result TEXT)',
        );
      },
      version: 2,
      onUpgrade: (db, oldVersion, newVersion){
        if (oldVersion < 2) {
          db.execute(
            'ALTER TABLE calculator_history ADD COLUMN result TEXT',
          );
        }
      },
    );
  }

  Future<void> insertCalculatorHistory(Map<String, dynamic> historyData) async {
    final db = await database;
    await db.insert(
      'calculator_history',
      historyData,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Map<String, dynamic>>> getCalculatorHistory() async {
    final db = await database;
    return await db.query('calculator_history');
  }

  Future<void> clearAllHistory() async {
    final db = await database;
    await db.delete('calculator_history');
  }
}
