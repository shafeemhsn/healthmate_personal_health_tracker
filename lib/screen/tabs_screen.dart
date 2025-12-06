import 'package:flutter/material.dart';

import 'package:healthmate_personal_health_tracker/screen/add_record_screen.dart';
import 'package:healthmate_personal_health_tracker/screen/dashboard_screen.dart';
import 'package:healthmate_personal_health_tracker/screen/health_record_screen.dart';
import 'package:healthmate_personal_health_tracker/widgets/app_title_logo.dart';

class TabsScreen extends StatefulWidget {
  const TabsScreen({super.key});

  @override
  State<StatefulWidget> createState() => _TabsScreenState();
}

class _TabsScreenState extends State<TabsScreen> {
  final List<Widget> _pages = const [DashboardScreen(), HealthRecordScreen()];
  int _selectedPageIndex = 0;
  void _selectPage(int index) {
    setState(() {
      _selectedPageIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const AppTitleLogo()),
      body: _pages[_selectedPageIndex],
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(
            context,
          ).push(MaterialPageRoute(builder: (ctx) => const AddRecordScreen()));
        },
        child: const Icon(Icons.add),
      ),

      bottomNavigationBar: BottomNavigationBar(
        onTap: _selectPage,
        currentIndex: _selectedPageIndex,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.list), label: 'Records'),
        ],
      ),
    );
  }
}
