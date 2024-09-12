import 'package:flutter/material.dart';
import '../../../widget/bottom_navigation.dart';
import '../../../widget/custom_floating_widget.dart';
import '../../../widget/drawer_widget.dart';
import '../../doughnut_graph.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _selectedIndex = 0;

  static final List<Widget> _widgetOptions = <Widget>[
    DoughnutGraph(),
    // Add other screens if needed
    // HomeScreen(),
    // GroceryScreen(),
    // ExpensesScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void _navigateToScreen(BuildContext context, int index) {
    switch (index) {
      case 1:
      // Navigator.push(
      //   context,
      //   MaterialPageRoute(builder: (context) => const NotesScreen()),
      // );
        break;
      case 2:
      // Navigator.push(
      //   context,
      //   MaterialPageRoute(builder: (context) => const ReminderScreen()),
      // );
        break;
      case 3:
      // Navigator.push(
      //   context,
      //   MaterialPageRoute(builder: (context) => const TaskScreen()),
      // );
        break;
      default:
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _selectedIndex == 0
          ? null
          : AppBar(
        title: const Text(
          'Track Your Daily Life',
          style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20,
              color: Colors.black),
        ),
        leading: IconButton(
          icon: const Icon(
            Icons.menu,
            color: Colors.black,
          ),
          onPressed: () {
            Scaffold.of(context).openDrawer();
          },
        ),
      ),
      drawer: const CustomDrawer(),
      body: _widgetOptions[_selectedIndex],
      bottomNavigationBar: CustomBottomNavigationBar(
        onItemTapped: _onItemTapped,
      ),
      floatingActionButton: CustomSpeedDial(
        onSelected: (index) => _navigateToScreen(context, index),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}
