class Habit {
  final int id;
  final String name;
  final String category;
  final String color;
  final String time;
  final String extraGoals;
  final String frequency;
  final String description;

  Habit({
    required this.id,
    required this.name,
    required this.category,
    required this.color,
    required this.time,
    required this.extraGoals,
    required this.frequency,
    required this.description,
  });

  factory Habit.fromMap(Map<String, dynamic> map) {
    return Habit(
      id: map['id'],
      name: map['name'],
      category: map['category'],
      color: map['color'],
      time: map['time'],
      extraGoals: map['extra_goals'],
      frequency: map['frequency'],
      description: map['description'],
    );
  }
}
