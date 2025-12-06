import 'package:flutter/material.dart';
import 'package:healthmate_personal_health_tracker/models/health_record.dart';
import 'package:intl/intl.dart';

class RecordCard extends StatelessWidget {
  final HealthRecord record;
  final VoidCallback onDelete;
  final VoidCallback onEdit;

  const RecordCard({
    super.key,
    required this.record,
    required this.onDelete,
    required this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    final date = _formatDate(record.date);

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(color: Colors.black12, blurRadius: 6, offset: Offset(0, 3)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ---- TITLE ROW ----
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                date,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.edit, color: Colors.grey),
                    onPressed: onEdit,
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: onDelete,
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 5),

          const Text(
            "Health Entry",
            style: TextStyle(fontSize: 14, color: Colors.grey),
          ),

          const SizedBox(height: 16),

          // ---- VALUES ROW ----
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _metricCard(
                value: record.steps.toString(),
                label: "steps",
                icon: Icons.directions_walk,
                color: Colors.indigo.withOpacity(0.1),
                textColor: Colors.indigo,
              ),
              _metricCard(
                value: record.calories.toString(),
                label: "kcal",
                icon: Icons.local_fire_department,
                color: Colors.red.withOpacity(0.1),
                textColor: Colors.red,
              ),
              _metricCard(
                value: record.water.toString(),
                label: "ml",
                icon: Icons.water_drop,
                color: Colors.blue.withOpacity(0.1),
                textColor: Colors.blue,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _metricCard({
    required String value,
    required String label,
    required IconData icon,
    required Color color,
    required Color textColor,
  }) {
    return Container(
      width: 90,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Icon(icon, color: textColor, size: 26),
          const SizedBox(height: 5),
          Text(
            value,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: textColor,
            ),
          ),
          Text(label, style: TextStyle(fontSize: 12, color: textColor)),
        ],
      ),
    );
  }

  String _formatDate(String raw) {
    // Records are stored as dd/MM/yyyy; gracefully fall back if parsing fails.
    try {
      final parsed = DateFormat('dd/MM/yyyy').parseStrict(raw);
      return DateFormat.yMMMEd().format(parsed);
    } on FormatException {
      // Try ISO parsing as a secondary attempt.
      final parsed = DateTime.tryParse(raw);
      if (parsed != null) {
        return DateFormat.yMMMEd().format(parsed);
      }
      return raw;
    }
  }
}
