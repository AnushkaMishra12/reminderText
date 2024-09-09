import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'calender_day.dart';

class MonthCalendarWidget extends StatelessWidget {
  final DateTime selectedMonth;
  final DateTime today;
  final VoidCallback goToNextMonth;
  final VoidCallback goToPreviousMonth;

  const MonthCalendarWidget({
    super.key,
    required this.selectedMonth,
    required this.today,
    required this.goToNextMonth,
    required this.goToPreviousMonth,
  });

  @override
  Widget build(BuildContext context) {
    int daysInMonth =
        DateUtils.getDaysInMonth(selectedMonth.year, selectedMonth.month);
    int firstDayOfMonth =
        DateTime(selectedMonth.year, selectedMonth.month, 1).weekday;

    List<Widget> calendarDays = [];

    for (int i = 1; i < firstDayOfMonth; i++) {
      calendarDays.add(Container());
    }

    for (int i = 1; i <= daysInMonth; i++) {
      DateTime day = DateTime(selectedMonth.year, selectedMonth.month, i);
      bool isToday = day.day == today.day &&
          day.month == today.month &&
          day.year == today.year;
      calendarDays.add(CalendarDayWidget(
        day: i,
        isToday: isToday,
      ));
    }

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: goToPreviousMonth,
            ),
            Text(
              DateFormat('MMMM yyyy').format(selectedMonth),
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            IconButton(
              icon: const Icon(Icons.arrow_forward),
              onPressed: goToNextMonth,
            ),
          ],
        ),
        GridView.count(
          crossAxisCount: 7,
          shrinkWrap: true,
          children: calendarDays,
        ),
      ],
    );
  }
}
