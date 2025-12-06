import 'package:flutter/material.dart';

import 'package:healthmate_personal_health_tracker/core/theme/app_theme.dart';
import 'package:healthmate_personal_health_tracker/feature/health_records/health_records.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: AppTheme.light(),
      darkTheme: AppTheme.dark(),
      home: const MainTabsScreen(),
    );
  }
}
