import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker_plus/flutter_datetime_picker_plus.dart';
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
            Text("Schedule Time: ${selectedDateTime.toString()}"),
            const SizedBox(height: 16),
            DatePickerTxt(
              callback: (dateTime) {
                setState(() {
                  selectedDateTime = dateTime;
                });
              },
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () async {
                final title = titleController.text.trim();
                final description = descriptionController.text.trim();

                if (title.isNotEmpty && description.isNotEmpty) {
                  final reminder = Reminder(
                    title: title,
                    description: description,
                    dateTime: selectedDateTime,
                  );

                  final dbHelper = ReminderDatabaseHelper();
                  final reminderId = await dbHelper.insertReminder(reminder);
                  reminder.id = reminderId;

                  NotificationService.scheduleNotification(
                      id: reminder.id ?? DateTime.now().microsecond,
                      title: reminder.title,
                      body: reminder.description,
                      scheduledNotificationDateTime: reminder.dateTime);
                } else {
                  if (kDebugMode) {
                    print('Reminder title or description is empty.');
                  }
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Title and description cannot be empty.'),
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

class DatePickerTxt extends StatefulWidget {
  const DatePickerTxt({
    super.key,
    required this.callback,
  });

  final Function(DateTime) callback;

  @override
  State<DatePickerTxt> createState() => _DatePickerTxtState();
}

class _DatePickerTxtState extends State<DatePickerTxt> {
  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () {
        DatePicker.showDateTimePicker(
          context,
          minTime: DateTime.now().add(const Duration(minutes: 1)),
          showTitleActions: true,
          onChanged: (date) => widget.callback(date),
          onConfirm: (date) {},
        );
      },
      child: const Text(
        'Select Date Time',
        style: TextStyle(color: Colors.blue),
      ),
    );
  }
}
