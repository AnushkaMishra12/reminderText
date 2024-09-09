import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TimePickerField extends StatefulWidget {
  final void Function(String) onTimeChanged;

  const TimePickerField({super.key, required this.onTimeChanged});

  @override
  _TimePickerFieldState createState() => _TimePickerFieldState();
}

class _TimePickerFieldState extends State<TimePickerField> {
  final TextEditingController _timeController = TextEditingController();

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (picked != null) {
      final String formattedTime = _formatTimeOfDay(picked);
      setState(() {
        _timeController.text = formattedTime;
      });
      widget.onTimeChanged(formattedTime);
    }
  }

  String _formatTimeOfDay(TimeOfDay timeOfDay) {
    final now = DateTime.now();
    final dateTime = DateTime(
      now.year,
      now.month,
      now.day,
      timeOfDay.hour,
      timeOfDay.minute,
    );
    final formatter = DateFormat('h:mm a');
    try {
      return formatter.format(dateTime);
    } catch (e) {
      print('Error formatting time: $e');
      return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: TextField(
            controller: _timeController,
            readOnly: true,
            onTap: () => _selectTime(context),
            decoration: const InputDecoration(
              hintText: '00:00 AM/PM',
              border: OutlineInputBorder(),
              fillColor: Color(0xFFFFFFFF),
              filled: true,
            ),
            textAlign: TextAlign.center,
          ),
        ),
        const SizedBox(width: 8.0),
        const Text('a day'),
      ],
    );
  }
}
