import 'package:flutter/material.dart';
import '../repo/db_calculator.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  _HistoryScreenState createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  late Future<List<Map<String, dynamic>>> _historyFuture;
  final CalculatorDatabaseHelper _dbHelper = CalculatorDatabaseHelper();

  @override
  void initState() {
    super.initState();
    _historyFuture = _dbHelper.getCalculatorHistory();
  }

  Future<void> _clearAllData() async {
    try {
      await _dbHelper.clearAllHistory();
      setState(() {
        _historyFuture = _dbHelper.getCalculatorHistory();
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('All history cleared')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error clearing history: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('History'),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_forever),
            onPressed: _clearAllData,
          ),
        ],
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _historyFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No history available'));
          }

          final history = snapshot.data!;
          return ListView.builder(
            itemCount: history.length,
            itemBuilder: (context, index) {
              final item = history[index];
              return ListTile(
                title: Text(item['expression']),
                subtitle: Text('Result: ${item['result']}'),
              );
            },
          );
        },
      ),
    );
  }
}
