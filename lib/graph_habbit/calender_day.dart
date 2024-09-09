import 'package:flutter/material.dart';

class CalendarDayWidget extends StatelessWidget {
  final int day;
  final bool isToday;

  const CalendarDayWidget({
    super.key,
    required this.day,
    required this.isToday,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      padding: const EdgeInsets.all(8),
      decoration: isToday
          ? const BoxDecoration(
              color: Colors.teal,
              shape: BoxShape.circle,
            )
          : null,
      child: Text(
        '$day',
        style: TextStyle(color: isToday ? Colors.white : Colors.black),
      ),
    );
  }
}
