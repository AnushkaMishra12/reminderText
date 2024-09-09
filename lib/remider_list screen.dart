import 'package:flutter/material.dart';
import 'package:reminder/reminder_database.dart';
import 'package:reminder/reminder_model.dart';

class ReminderListScreen extends StatefulWidget {
  const ReminderListScreen({super.key});

  @override
  _ReminderListScreenState createState() => _ReminderListScreenState();
}

class _ReminderListScreenState extends State<ReminderListScreen> {
  List<Reminder> reminders = [];
  final ReminderDatabaseHelper dbHelper = ReminderDatabaseHelper();

  @override
  void initState() {
    super.initState();
    _loadReminders();
  }

  Future<void> _loadReminders() async {
    final allReminders = await dbHelper.getReminders();
    final now = DateTime.now();

    for (var reminder in allReminders) {
      if (reminder.dateTime.isBefore(now)) {
        await dbHelper.deleteReminder(reminder.id!);
      }
    }

    final updatedReminders = await dbHelper.getReminders();
    setState(() {
      reminders = updatedReminders;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Scheduled Reminders'),
      ),
      body: reminders.isNotEmpty
          ? ListView.builder(
        itemCount: reminders.length,
        itemBuilder: (context, index) {
          final reminder = reminders[index];
          return ListTile(
            title: Text(reminder.title),
            subtitle: Text(
              'Scheduled for: ${reminder.dateTime}',
            ),
          );
        },
      )
          : const Center(
        child: Text('No reminders available.'),
      ),
    );
  }
}
