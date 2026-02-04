import 'package:flutter/material.dart';
import 'package:personal_assistant/Screens/asssignmentScreen.dart'; // Import your screen file

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Assignment Manager',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: AssignmentManagementScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}