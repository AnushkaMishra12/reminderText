import 'package:flutter/material.dart';

class CustomColorPicker extends StatelessWidget {
  final ValueChanged<Color> onColorSelected;
  final Color selectedColor;

  const CustomColorPicker({
    super.key,
    required this.onColorSelected,
    required this.selectedColor,
  });

  @override
  Widget build(BuildContext context) {
    final List<Color> colors = [
      Colors.brown.shade900,
      Colors.greenAccent,
      Colors.pink.shade200,
      Colors.orange,
      Colors.black,
      Colors.yellow,
      Colors.purpleAccent,
      Colors.blue,
      Colors.amber,
      Colors.purple,
      Colors.lightBlueAccent,
      Colors.green,
      Colors.cyan,
      Colors.deepPurple,
      Colors.indigo,
    ];

    return SizedBox(
      width: 200,
      height: 120,
      child: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 6,
          mainAxisSpacing: 8.0,
          crossAxisSpacing: 8.0,
          childAspectRatio: 1.0,
        ),
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(), // Disable scrolling
        itemCount: colors.length,
        itemBuilder: (context, index) {
          final color = colors[index];
          return GestureDetector(
            onTap: () => onColorSelected(color),
            child: Container(
              decoration: BoxDecoration(
                color: color,
                shape: BoxShape.circle,
                border: selectedColor == color
                    ? Border.all(color: Colors.black, width: 2)
                    : null,
              ),
            ),
          );
        },
      ),
    );
  }
}
