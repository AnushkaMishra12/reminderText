import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:reminder/repo/database_helper.dart';
import '../service/notification_service.dart';
import '../widget/at_least.dart';
import '../widget/category_text.dart';
import 'doughnut_graph.dart';
import '../widget/extragoals.dart';
import '../widget/time_picker.dart';


class DefineHabitPage extends StatefulWidget {
  const DefineHabitPage({super.key});

  @override
  _DefineHabitPageState createState() => _DefineHabitPageState();
}

class _DefineHabitPageState extends State<DefineHabitPage> {
  String _selectedGoal = '';
  final _formKey = GlobalKey<FormState>();
  final List<String> _selectedDays = [];
  Color _categoryColor = Colors.red;
  String _selectedTime = '';
  String _frequency = 'Every day';

  final TextEditingController _categoryController = TextEditingController();
  final TextEditingController _habitController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  @override
  void dispose() {
    _categoryController.dispose();
    _habitController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  void _testNotification() {
    NotificationService.showNotification(
      id: 1,
      name: 'Test Notification',
      description: 'This is a test notification',
    );
  }

  void _onGoalChanged(String goalType) {
    setState(() {
      _selectedGoal = goalType;
    });
  }

  void _onTimeChanged(String time) {
    setState(() {
      _selectedTime = time;
    });
  }

  void _onDaysSelected(List<String> days) {
    setState(() {
      _selectedDays.clear();
      _selectedDays.addAll(days);
    });
  }

  void _onFrequencyChanged(String newValue) {
    setState(() {
      _frequency = newValue;
    });
  }

  void _saveHabit() async {
    if (_formKey.currentState!.validate()) {
      String habitName = _habitController.text;
      String description = _descriptionController.text;
      String categoryName = _categoryController.text;
      String colorName =
          '0xFF${_categoryColor.value.toRadixString(16).padLeft(8, '0')}';
      String days;

      if (_frequency == 'Every day') {
        _selectedDays.clear();
        _selectedDays.addAll([
          'Monday',
          'Tuesday',
          'Wednesday',
          'Thursday',
          'Friday',
          'Saturday',
          'Sunday'
        ]);
        days = 'Every day';
      } else {
        days = _selectedDays.join(',');
      }

      try {
        int id = await DatabaseHelper().insertHabit(
          habitName,
          categoryName,
          colorName,
          _selectedTime,
          _selectedGoal,
          days,
          description,
        );

        if (id > 0) {
          final DateTime now = DateTime.now();

          final List<String> timeParts = _selectedTime.split(' ');
          final List<String> hourMinute = timeParts[0].split(':');
          final String period = timeParts[1];

          final int hour = (period == 'PM' && int.parse(hourMinute[0]) < 12)
              ? int.parse(hourMinute[0]) + 12
              : (period == 'AM' && int.parse(hourMinute[0]) == 12)
              ? 0
              : int.parse(hourMinute[0]);

          final DateTime scheduledDateTime = DateTime(
            now.year,
            now.month,
            now.day,
            hour,
            int.parse(hourMinute[1]),
          ).add(const Duration(milliseconds: 0));

          if (kDebugMode) {
            print('Current Time: $now');
          }
          if (kDebugMode) {
            print('Scheduled Notification Time: $scheduledDateTime');
          }
          await NotificationService.scheduleNotification(
            id: id,
            name: habitName,
            description: description,
            scheduledNotificationDateTime: scheduledDateTime,
          );

          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Habit and reminder saved successfully!'),
            ),
          );

          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => const DoughnutGraph(),
            ),
          );
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error saving habit: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE0DFDF),
      appBar: AppBar(
        title: const Text('Add New Habit',
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black)),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    TextFormField(
                      controller: _habitController,
                      decoration: const InputDecoration(
                        hintText: 'Enter your habit',
                        border: OutlineInputBorder(),
                        fillColor: Color(0xFFFFFFFF),
                        filled: true,
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a habit';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16.0),
                    AtLeast(
                      onFrequencyChanged: _onFrequencyChanged,
                      onDaysSelected: _onDaysSelected,
                    ),
                    const SizedBox(height: 16.0),
                    TimePickerField(onTimeChanged: _onTimeChanged),
                    const SizedBox(height: 16.0),
                    TextFormField(
                      controller: _descriptionController,
                      decoration: const InputDecoration(
                        hintText: 'Enter description',
                        border: OutlineInputBorder(),
                        fillColor: Color(0xFFFFFFFF),
                        filled: true,
                      ),
                    ),
                    const SizedBox(height: 16.0),
                    ExtraGoalsDropdown(
                      selectedGoal: _selectedGoal,
                      onGoalChanged: _onGoalChanged,
                    ),
                    const SizedBox(height: 16.0),
                    CategoryTextField(
                      categoryColor: _categoryColor,
                      onColorChanged: (Color color) {
                        setState(() {
                          _categoryColor = color;
                        });
                      },
                      controller: _categoryController,
                    ),
                    const SizedBox(height: 16.0),
                    ElevatedButton(
                      onPressed: _testNotification,
                      child: const Text('Test Notification'),
                    ),
                    const SizedBox(height: 32.0),
                  ],
                ),
              ),
            ),
          );
        },
      ),
      bottomNavigationBar: BottomAppBar(
        color: const Color(0xFFE0DFDF),
        shadowColor: const Color(0xFFE0DFDF),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text(
                'Back',
                style: TextStyle(
                  color: Colors.blue,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            TextButton(
              onPressed: _saveHabit,
              child: const Text(
                'Save',
                style: TextStyle(
                  color: Colors.red,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
