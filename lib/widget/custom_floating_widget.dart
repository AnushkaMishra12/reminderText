import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';

class CustomSpeedDial extends StatelessWidget {
  final Function(int) onSelected;
  const CustomSpeedDial({super.key, required this.onSelected});

  @override
  Widget build(BuildContext context) {
    return SpeedDial(
      icon: Icons.add,
      activeIcon: Icons.close,
      backgroundColor: Colors.black,
      foregroundColor: Colors.white,
      activeBackgroundColor: Colors.purple,
      activeForegroundColor: Colors.white,
      buttonSize: const Size(60.0, 60.0),
      visible: true,
      closeManually: false,
      curve: Curves.bounceIn,
      overlayColor: Colors.black,
      overlayOpacity: 0.5,
      elevation: 8.0,
      shape: const CircleBorder(),
      children: [
        SpeedDialChild(
          child: const Icon(Icons.newspaper_rounded),
          backgroundColor: Colors.green,
          foregroundColor: Colors.white,
          // shape: const Border.symmetric(),
          label: 'Notes',
          labelStyle: const TextStyle(fontSize: 18.0),
          onTap: () => onSelected(1),
        ),
        SpeedDialChild(
          child: const Icon(Icons.alarm),
          backgroundColor: Colors.blue,
          foregroundColor: Colors.white,
          label: 'Reminder',
          labelStyle: const TextStyle(fontSize: 18.0),
          onTap: () => onSelected(2),
        ),
        SpeedDialChild(
          child: const Icon(Icons.add_card),
          backgroundColor: Colors.red,
          foregroundColor: Colors.white,
          label: 'Task',
          labelStyle: const TextStyle(fontSize: 18.0),
          onTap: () => onSelected(3),
        ),
      ],
    );
  }
}
