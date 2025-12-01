class HealthRecord {
  const HealthRecord({
    required this.id,
    required this.date,
    required this.steps,
    required this.calories,
    required this.water,
    this.userId,
  });

  final String id;
  final String date;
  final String steps;
  final String calories;
  final String water;
  final String? userId;
}
