import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class WeekDaysWidget extends StatelessWidget {
  final DateTime today;
  final VoidCallback toggleCalendar;

  const WeekDaysWidget({
    super.key,
    required this.today,
    required this.toggleCalendar,
  });

  @override
  Widget build(BuildContext context) {
    DateTime now = DateTime.now();
    List<Widget> days = [];
    for (int i = 0; i < 7; i++) {
      DateTime day = now.subtract(Duration(days: now.weekday - i - 1));
      bool isToday = day.day == today.day &&
          day.month == today.month &&
          day.year == today.year;
      days.add(
        GestureDetector(
          onTap: toggleCalendar,
          child: Column(
            children: [
              Text(
                DateFormat('EEE').format(day),
                style: const TextStyle(color: Colors.white),
              ),
              const SizedBox(height: 4),
              Container(
                decoration: isToday
                    ? const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      )
                    : null,
                padding: const EdgeInsets.all(8),
                child: Text(
                  DateFormat('dd').format(day),
                  style: TextStyle(color: isToday ? Colors.teal : Colors.white),
                ),
              ),
            ],
          ),
        ),
      );
    }

    return Container(
      color: Colors.teal,
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: days,
      ),
    );
  }
}
