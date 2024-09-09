import 'package:flutter/foundation.dart';
import 'package:path/path.dart';
import 'dart:io';
import 'package:sqflite/sqflite.dart';
import '../view/model.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;
  static Database? _database;
  DatabaseHelper._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<void> deleteDatabase() async {
    final databasePath = join(await getDatabasesPath(), 'new_habits.db');
    try {
      final file = File(databasePath);
      if (await file.exists()) {
        await file.delete();
        if (kDebugMode) {
          print('Database deleted successfully.');
        }
      } else {
        if (kDebugMode) {
          print('Database does not exist.');
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error deleting database: $e');
      }
    }
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'new_habits.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
      onDowngrade: onDatabaseDowngradeDelete,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute(
      'CREATE TABLE habits(id INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT, category TEXT, '
      'color TEXT, time TEXT, extra_goals TEXT, frequency TEXT, description TEXT)',
    );
  }

  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 7) {
      await db.execute(
        'ALTER TABLE habits ADD COLUMN description TEXT',
      );
    }
  }

  Future<int> insertHabit(
    String name,
    String category,
    String color,
    String time,
    String extraGoals,
    String frequency,
    String description,
  ) async {
    try {
      final db = await database;
      return await db.insert(
        'habits',
        {
          'name': name,
          'category': category,
          'color': color,
          'time': time,
          'extra_goals': extraGoals,
          'frequency': frequency,
          'description': description,
        },
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    } catch (e) {
      if (kDebugMode) {
        print('Error inserting habit: $e');
      }
      return -1;
    }
  }

  Future<int> updateHabit(
    int id,
    String name,
    String category,
    String color,
    String time,
    String extraGoals,
    String frequency,
    String description,
  ) async {
    try {
      final db = await database;
      return await db.update(
        'habits',
        {
          'name': name,
          'category': category,
          'color': color,
          'time': time,
          'extra_goals': extraGoals,
          'frequency': frequency,
          'description': description,
        },
        where: 'id = ?',
        whereArgs: [id],
      );
    } catch (e) {
      if (kDebugMode) {
        print('Error updating habit: $e');
      }
      return -1;
    }
  }

  Future<List<Habit>> fetchAllHabits() async {
    try {
      final db = await database;
      final List<Map<String, dynamic>> maps = await db.query('habits');
      return List.generate(maps.length, (i) {
        return Habit.fromMap(maps[i]);
      });
    } catch (e) {
      if (kDebugMode) {
        print('Error fetching all habits: $e');
      }
      return [];
    }
  }

  Future<int> deleteHabit(int id) async {
    try {
      final db = await database;
      return await db.delete(
        'habits',
        where: 'id = ?',
        whereArgs: [id],
      );
    } catch (e) {
      if (kDebugMode) {
        print('Error deleting habit: $e');
      }
      return -1;
    }
  }

  Future<void> printTableStructure(String tableName) async {
    try {
      final db = await database;
      final result = await db.rawQuery('PRAGMA table_info($tableName)');
      if (kDebugMode) {
        print('Table Structure for $tableName:');
      }
      for (var row in result) {
        if (kDebugMode) {
          print(row);
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error fetching table structure: $e');
      }
    }
  }
}
