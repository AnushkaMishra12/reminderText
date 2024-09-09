import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'createController.dart';

class CreateGroceryListScreen extends StatelessWidget {
  const CreateGroceryListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final CreateGroceryController controller =
        Get.put(CreateGroceryController());
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add New Grocery'),
        actions: [
          IconButton(
            icon: const Icon(Icons.close),
            onPressed: () {
              Navigator.pop(context);
            },
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: controller.itemController,
              decoration: InputDecoration(
                labelText: 'Add Items',
                suffixIcon: IconButton(
                  icon: const Icon(Icons.add),
                  onPressed: () {
                    controller.addItem(controller.itemController.text);
                  },
                ),
              ),
              onSubmitted: (value) {
                controller.addItem(value);
              },
            ),
            const SizedBox(height: 10),
            Flexible(
              child: Obx(() {
                if (controller.items.isNotEmpty) {
                  return SingleChildScrollView(
                    child: Wrap(
                      spacing: 8.0,
                      runSpacing: 4.0,
                      children: controller.items.map((item) {
                        return Chip(
                          label: Text(item),
                          deleteIcon: const Icon(Icons.close),
                          onDeleted: () {
                            controller.removeItem(item);
                          },
                        );
                      }).toList(),
                    ),
                  );
                } else {
                  return const SizedBox.shrink();
                }
              }),
            ),
            const SizedBox(height: 20),
            const TextField(
              decoration: InputDecoration(
                labelText: 'Add Category',
                suffixIcon: Icon(Icons.circle, color: Colors.red),
              ),
            ),
            const SizedBox(height: 20),
            const TextField(
              decoration: InputDecoration(
                labelText: 'Add Reminder',
                suffixIcon: Icon(Icons.notifications),
              ),
            ),
            const Spacer(),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            ElevatedButton(
              onPressed: () {},
              child: const Text('Confirm'),
            ),
            ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.grey,
              ),
              child: const Text('Cancel'),
            ),
          ],
        ),
      ),
    );
  }
}
