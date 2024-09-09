import 'package:flutter/material.dart';
import 'package:reminder/remider_list%20screen.dart';
import 'package:reminder/reminder_database.dart';
import 'package:reminder/reminder_model.dart';
import 'notifi_service.dart';

class ReminderScreen extends StatefulWidget {
  const ReminderScreen({super.key});

  @override
  ReminderScreenState createState() => ReminderScreenState();
}

class ReminderScreenState extends State<ReminderScreen> {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  DateTime? selectedTime;

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
            CustomTimePicker(
              callback: (dateTime) {
                setState(() {
                  selectedTime = dateTime;
                });
              },
              selectedTime: selectedTime,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () async {
                final title = titleController.text.trim();
                final description = descriptionController.text.trim();
                if (title.isNotEmpty && description.isNotEmpty && selectedTime != null) {
                  final reminder = Reminder(
                    title: title,
                    description: description,
                    dateTime: selectedTime!,
                  );
                  final dbHelper = ReminderDatabaseHelper();
                  final reminderId = await dbHelper.insertReminder(reminder);
                  reminder.id = reminderId;

                  NotificationService.scheduleNotification(
                      id: reminder.id ?? DateTime.now().microsecond,
                      title: reminder.title,
                      body: reminder.description,
                      scheduledNotificationDateTime: reminder.dateTime);

                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const ReminderListScreen(),
                    ),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Title, description, and time cannot be empty.'),
                    ),
                  );
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

class CustomTimePicker extends StatelessWidget {
  final Function(DateTime) callback;
  final DateTime? selectedTime;
  const CustomTimePicker({super.key, required this.callback, this.selectedTime});

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () async {
        final TimeOfDay? pickedTime = await showTimePicker(
          context: context,
          initialTime: TimeOfDay.now(),
        );

        if (pickedTime != null) {
          final now = DateTime.now();
          final selectedDateTime = DateTime(
            now.year,
            now.month,
            now.day,
            pickedTime.hour,
            pickedTime.minute,
          );
          callback(selectedDateTime);
        }
      },
      child: Text(
        selectedTime != null
            ? 'Selected Time: ${selectedTime!.hour}:${selectedTime!.minute}'
            : 'Select Time',
        style: const TextStyle(color: Colors.black),
      ),
    );
  }
}
