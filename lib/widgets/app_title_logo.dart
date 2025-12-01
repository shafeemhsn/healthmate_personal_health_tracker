import 'package:flutter/material.dart';

class AppTitleLogo extends StatelessWidget {
  const AppTitleLogo({super.key});

  @override
  Widget build(BuildContext context) {
    return const Row(
      children: [
        Icon(Icons.monitor_heart, color: Colors.green, size: 28),
        SizedBox(width: 8),
        Text(
          "HealthMate",
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800),
        ),
      ],
    );
  }
}
