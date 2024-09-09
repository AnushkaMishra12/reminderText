import 'package:flutter/material.dart';
import 'package:reminder/widget/week_days.dart';
import 'month_calender.dart';

class CalendarScreen extends StatelessWidget {
  CalendarScreen({super.key});

  final bool _isExpanded = false;
  final DateTime _today = DateTime.now();
  final DateTime _selectedMonth = DateTime.now();

  void _toggleCalendar(BuildContext context) {}
  void _goToNextMonth(BuildContext context) {}
  void _goToPreviousMonth(BuildContext context) {}
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        title: const Text('Calendar'),
      ),
      body: Column(
        children: [
          WeekDaysWidget(
              today: _today, toggleCalendar: () => _toggleCalendar(context)),
          SizeTransition(
            sizeFactor: AlwaysStoppedAnimation<double>(_isExpanded ? 1.0 : 0.0),
            child: MonthCalendarWidget(
              selectedMonth: _selectedMonth,
              today: _today,
              goToNextMonth: () => _goToNextMonth(context),
              goToPreviousMonth: () => _goToPreviousMonth(context),
            ),
          ),
        ],
      ),
    );
  }
}
