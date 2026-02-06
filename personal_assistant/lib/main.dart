import 'package:flutter/material.dart';
import 'package:personal_assistant/providers/assignment_provider.dart';
import 'package:provider/provider.dart';
import 'navigation_menu.dart';
import 'providers/schedule_provider.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AssignmentProvider()),
        ChangeNotifierProvider(create: (_) => ScheduleProvider()),
      ],
      child: MaterialApp(
        title: 'Personal Assistant',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        home: const NavigationMenu(),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}


