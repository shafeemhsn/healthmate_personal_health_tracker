import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:healthmate_personal_health_tracker/pages/home_page.dart';
import 'package:healthmate_personal_health_tracker/screen/tabs_screen.dart';

const Color seedColor = Color(0xFF10B981);

final theme = ThemeData(
  useMaterial3: true,
  colorScheme: ColorScheme.fromSeed(
    seedColor: seedColor,
    brightness: Brightness.light,
  ),
  textTheme: GoogleFonts.latoTextTheme(),
);

final darkTheme = ThemeData(
  useMaterial3: true,
  colorScheme: ColorScheme.fromSeed(
    seedColor: seedColor,
    brightness: Brightness.dark,
  ),
  textTheme: GoogleFonts.latoTextTheme(),
);

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: theme,
      darkTheme: darkTheme,
      // home: const HomePage(),
      home: TabsScreen(),
    );
  }
}
