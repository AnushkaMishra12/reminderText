import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../widget/category_bottom_sheet.dart';
import 'add_habbit.dart';
import '../repo/database_helper.dart';
import '../view/model.dart';
import 'all_habits.dart';
import '../widget/custom_doughnut_indicator.dart';
import '../widget/habbit_list.dart';
import '../widget/month_calender.dart';
import '../widget/week_days.dart';
import 'dashboard/doghnutComntroller.dart';

class DoughnutGraph extends StatefulWidget {
  const DoughnutGraph({super.key});

  @override
  _DoughnutGraphState createState() => _DoughnutGraphState();
}

class _DoughnutGraphState extends State<DoughnutGraph> {
  final ValueNotifier<bool> _isExpanded = ValueNotifier(false);
  final DateTime _today = DateTime.now();
  final ValueNotifier<DateTime> _selectedMonth = ValueNotifier(DateTime.now());
  late Future<List<Habit>> _habitsFuture;
  final DoughnutGraphController controller = Get.put(DoughnutGraphController());

  @override
  void initState() {
    super.initState();
    _habitsFuture = _fetchHabits();
  }

  Future<List<Habit>> _fetchHabits() async {
    final dbHelper = DatabaseHelper();
    final db = await dbHelper.database;
    final List<Map<String, dynamic>> maps = await db.query('habits');
    return List.generate(maps.length, (i) {
    return Habit.fromMap(maps[i]);
    });
  }

  Future<void> _deleteHabit(int habitId) async {
    final dbHelper = DatabaseHelper();
    await dbHelper.deleteHabit(habitId);
    setState(() {
      _habitsFuture = _fetchHabits();
    });
  }

  void _toggleCalendar() {
    _isExpanded.value = !_isExpanded.value;
  }

  void _goToNextMonth() {
    _selectedMonth.value = DateTime(
      _selectedMonth.value.year,
      _selectedMonth.value.month + 1,
    );
  }

  void _goToPreviousMonth() {
    _selectedMonth.value = DateTime(
      _selectedMonth.value.year,
      _selectedMonth.value.month - 1,
    );
  }

  void _navigateToNewScreen(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const DefineHabitPage()),
    );
  }

  void _openBottomSheetForAll(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return CategoryBottomSheet(
          categoryData: controller.categoryData.value,
          onSave: (updatedData) {
            controller.updateAllCategories(updatedData);
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Habit Tracker",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => _navigateToNewScreen(context),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            WeekDaysWidget(
              today: _today,
              toggleCalendar: _toggleCalendar,
            ),
            ValueListenableBuilder<bool>(
              valueListenable: _isExpanded,
              builder: (context, isExpanded, child) {
                return isExpanded
                    ? ValueListenableBuilder<DateTime>(
                  valueListenable: _selectedMonth,
                  builder: (context, selectedMonth, child) {
                    return SizeTransition(
                      sizeFactor: AlwaysStoppedAnimation<double>(
                          isExpanded ? 1.0 : 0.0),
                      child: MonthCalendarWidget(
                        selectedMonth: selectedMonth,
                        today: _today,
                        goToNextMonth: _goToNextMonth,
                        goToPreviousMonth: _goToPreviousMonth,
                      ),
                    );
                  },
                )
                    : Column(
                  children: [
                    Container(
                      margin: const EdgeInsets.all(10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('Day Highlight',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                  fontSize: 18)),
                          GestureDetector(
                            onTap: () => _openBottomSheetForAll(context),
                            child: const Text('Give all >',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                    fontSize: 18)),
                          ),
                        ],
                      ),
                    ),
                    Center(
                      child: Container(
                        margin: const EdgeInsets.all(10),
                        decoration: const BoxDecoration(
                          borderRadius:
                          BorderRadius.all(Radius.circular(20)),
                        ),
                      ),
                    ),
                    Center(
                        child: Obx(() {
                          return Wrap(
                            spacing: -15,
                            runSpacing: -25,
                            alignment: WrapAlignment.center,
                            children: controller.categoryData.value.keys.map((category) {
                              final data = controller.categoryData.value[category]!;
                              return GestureDetector(
                                onTap: () {},
                                child: CustomDoughnutIndicator(
                                  label: category,
                                  badPercentage: data["Bad"]!,
                                  goodPercentage: data["Good"]!,
                                  excellentPercentage: data["Excellent"]!,
                                  averagePercentage: data["Average"]!,
                                ),
                              );
                            }).toList(),
                          );
                        })),
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('See all >',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                  fontSize: 18)),
                          TextButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                  const AllHabitsScreen(),
                                ),
                              );
                            },
                            child: const Text('See all >',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                    fontSize: 18)),
                          ),
                        ],
                      ),
                    ),
                    FutureBuilder<List<Habit>>(
                      future: _habitsFuture,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                              child: CircularProgressIndicator());
                        } else if (snapshot.hasError) {
                          return Center(
                              child: Text('Error: ${snapshot.error}'));
                        } else if (!snapshot.hasData ||
                            snapshot.data!.isEmpty) {
                          return const Center(
                              child: Text('No habits found.'));
                        } else {
                          final limitedHabits = snapshot.data!.take(3).toList();
                          return ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: limitedHabits.length,
                            itemBuilder: (context, index) {
                              final habit = limitedHabits[index];
                              return HabitListItem(
                                habit: habit,
                                onDelete: () => _deleteHabit(habit.id),
                              );
                            },
                          );
                        }
                      },
                    ),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
