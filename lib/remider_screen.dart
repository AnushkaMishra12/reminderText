import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:reminder/reminder_database.dart';
import 'package:reminder/reminder_model.dart';
import 'notification_helper.dart';

class ReminderScreen extends StatefulWidget {
  const ReminderScreen({super.key});

  @override
  _ReminderScreenState createState() => _ReminderScreenState();
}

class _ReminderScreenState extends State<ReminderScreen> {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  DateTime selectedDateTime = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Reminder'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: titleController,
              decoration: const InputDecoration(labelText: 'Title'),
            ),
            TextField(
              controller: descriptionController,
              decoration: const InputDecoration(labelText: 'Description'),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () async {
                DateTime? pickedDate = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime.now(),
                  lastDate: DateTime(2100),
                );

                if (pickedDate != null) {
                  TimeOfDay? pickedTime = await showTimePicker(
                    context: context,
                    initialTime: TimeOfDay.now(),
                  );

                  if (pickedTime != null) {
                    setState(() {
                      selectedDateTime = DateTime(
                        pickedDate.year,
                        pickedDate.month,
                        pickedDate.day,
                        pickedTime.hour,
                        pickedTime.minute,
                      );
                    });

                    final title = titleController.text.trim();
                    final description = descriptionController.text.trim();

                    if (title.isNotEmpty && description.isNotEmpty) {
                      final reminder = Reminder(
                        title: title,
                        description: description,
                        dateTime: selectedDateTime,
                      );

                      final dbHelper = ReminderDatabaseHelper();
                      final reminderId =
                          await dbHelper.insertReminder(reminder);
                      reminder.id = reminderId;

                      await NotificationHelper.scheduleNotification(reminder);
                    } else {
                      if (kDebugMode) {
                        print('Reminder title or description is empty.');
                      }
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content:
                              Text('Title and description cannot be empty.'),
                        ),
                      );
                    }
                  }
                }
              },
              child: const Text('Add Reminder'),
            ),
          ],
        ),
      ),
    );
  }
}
