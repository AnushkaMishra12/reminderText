import 'package:flutter/material.dart';
import 'custom_color_picker.dart';

class CategoryTextField extends StatelessWidget {
  final Color categoryColor;
  final ValueChanged<Color> onColorChanged;
  final TextEditingController controller;

  const CategoryTextField({
    super.key,
    required this.categoryColor,
    required this.onColorChanged,
    required this.controller,


  });

  void _openColorPicker(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Pick a color'),
          content: CustomColorPicker(
            selectedColor: categoryColor,
            onColorSelected: (Color color) {
              onColorChanged(color);
              Navigator.of(context).pop();
            },
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        hintText: 'Category',
        border: const OutlineInputBorder(),
        fillColor: const Color(0xFFFFFFFF),
        filled: true,
        suffixIcon: GestureDetector(
          onTap: () => _openColorPicker(context),
          child: Container(
            width: 20.0,
            height: 20.0,
            margin: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: categoryColor,
            ),
          ),
        ),
      ),
    );
  }
}
