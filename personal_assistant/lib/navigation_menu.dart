import "package:flutter/material.dart";
import "package:personal_assistant/Screens/asssignmentScreen.dart";
import "Screens/attendance_tracking.dart";
import "Screens/dashboard.dart";

class NavigationMenu extends StatefulWidget {
  const NavigationMenu({super.key});

  @override
  State<NavigationMenu> createState() => _NavigationMenuState();
}

class _NavigationMenuState extends State<NavigationMenu> {
  int _selectedIndex = 0;

  final List<Widget> _screens = [
    const Dashboard(),
    const Center(child: Text('Calendar Screen')),
    const AssignmentManagementScreen(),
    const Center(child: Text('Schedule Screen')),
    const AttendanceTracking(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_selectedIndex],
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        height: 60,
        onDestinationSelected: (int index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home, size: 22),
            label: 'Dashboard',
          ),
          NavigationDestination(
            icon: Icon(Icons.calendar_today, size: 22),
            label: 'Calendar',
          ),
          NavigationDestination(
            icon: Icon(Icons.assignment, size: 22),
            label: 'Assignment',
          ),
          NavigationDestination(
            icon: Icon(Icons.schedule, size: 22),
            label: 'Schedule',
          ),
          NavigationDestination(
            icon: Icon(Icons.fact_check, size: 22),
            label: 'Attendance',
          ),
        ],
      ),
    );
  }
}
