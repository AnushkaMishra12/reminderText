import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../repo/db_calculator.dart';

class HistoryController extends GetxController {
  var history = <Map<String, dynamic>>[].obs;
  final CalculatorDatabaseHelper _dbHelper = CalculatorDatabaseHelper();

  @override
  void onInit() {
    super.onInit();
    _loadHistory();
  }

  Future<void> _loadHistory() async {
    history.value = await _dbHelper.getCalculatorHistory();
  }

  Future<void> clearAllData() async {
    try {
      await _dbHelper.clearAllHistory();
      history.clear();
      Get.snackbar('Success', 'All history cleared');
    } catch (e) {
      Get.snackbar('Error', 'Error clearing history: $e');
    }
  }
}

class HistoryScreen extends StatelessWidget {
  HistoryScreen({super.key});

  final HistoryController _controller = Get.put(HistoryController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('History'),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_forever),
            onPressed: () => _controller.clearAllData(),
          ),
        ],
      ),
      body: Obx(() {
        if (_controller.history.isEmpty) {
          return const Center(child: Text('No history available'));
        }

        return ListView.builder(
          itemCount: _controller.history.length,
          itemBuilder: (context, index) {
            final item = _controller.history[index];
            return ListTile(
              title: Text(item['expression']),
              subtitle: Text('Result: ${item['result']}'),
            );
          },
        );
      }),
    );
  }
}
