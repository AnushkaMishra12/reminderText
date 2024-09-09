import 'package:flutter/material.dart';

class CustomBottomNavigationBar extends StatelessWidget {
  final ValueChanged<int> onItemTapped;

  const CustomBottomNavigationBar({super.key, required this.onItemTapped});

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      shape: const CircularNotchedRectangle(),
      notchMargin: 6.0,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          IconButton(
            icon: const Icon(Icons.home),
            onPressed: () => onItemTapped(0),
          ),
          IconButton(
            icon: const Icon(Icons.sports_gymnastics),
            onPressed: () => onItemTapped(1),
          ),
          const SizedBox(width: 40),
          IconButton(
            icon: const Icon(Icons.local_grocery_store_sharp),
            onPressed: () => onItemTapped(2),
          ),
          IconButton(
            icon: const Icon(Icons.cases_sharp),
            onPressed: () => onItemTapped(3),
          ),
        ],
      ),
    );
  }
}
