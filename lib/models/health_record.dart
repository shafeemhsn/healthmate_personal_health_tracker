class HealthRecord {
  const HealthRecord({
    required this.id,
    required this.date,
    required this.steps,
    required this.calories,
    required this.water,
    this.userId,
  });

  final int id;
  final String date;
  final int steps;
  final int calories;
  final int water;
  final int? userId;
}
