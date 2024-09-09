import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import '../view/model.dart';

class HabitListItem extends StatelessWidget {
  final Habit habit;
  final VoidCallback onDelete;
  const HabitListItem({super.key, required this.habit, required this.onDelete});

  @override
  Widget build(BuildContext context) {
    String colorString = habit.color;
    Color color;
    try {
      color = Color(int.parse(colorString));
    } catch (e) {
      color = Colors.grey;
    }

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: color.withOpacity(0.8),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Row(
        children: [
          SizedBox(
            width: 50,
            height: 50,
            child: Lottie.asset(
              'assets/anim/walk.json',
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  habit.name,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  habit.time,
                  // textDirection: TextDirection.rtl,
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.delete),
            color: Colors.white,
            onPressed: onDelete,
          ),
        ],
      ),
    );
  }
}
