import 'package:flutter/material.dart';
import '../db/database_helper.dart';
import '../db/model.dart';
import '../graph_habbit/habbit_list.dart';

class AllHabitsScreen extends StatefulWidget {
  const AllHabitsScreen({super.key});

  @override
  _AllHabitsScreenState createState() => _AllHabitsScreenState();
}

class _AllHabitsScreenState extends State<AllHabitsScreen> {
  late Future<List<Habit>> _habitsFuture;

  @override
  void initState() {
    super.initState();
    _habitsFuture = _fetchHabits();
  }

  Future<List<Habit>> _fetchHabits() async {
    final dbHelper = DatabaseHelper();
    final db = await dbHelper.database;
    final List<Map<String, dynamic>> maps = await db.query('habits');
    return List.generate(maps.length, (i)
    {
      return Habit.fromMap(maps[i]);
    });
  }

  Future<void> _deleteHabit(int habitId) async {
    final dbHelper = DatabaseHelper();
    await dbHelper.deleteHabit(habitId);
    setState(() {
      _habitsFuture = _fetchHabits();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("All Habits"),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {},
          ),
        ],
      ),
      body: FutureBuilder<List<Habit>>(
        future: _habitsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No habits found.'));
          } else {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                final habit = snapshot.data![index];
                return HabitListItem(
                  habit: habit,
                  onDelete: () => _deleteHabit(habit.id),
                );
              },
            );
          }
        },
      ),
    );
  }
}
