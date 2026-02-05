import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/schedule_provider.dart';
import 'Screens/schedule_screen.dart';
import 'utils/constants.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [ChangeNotifierProvider(create: (_) => ScheduleProvider())],
      child: MaterialApp(
        title: 'ALU Student Assistant',
        theme: AppTheme.theme,
        debugShowCheckedModeBanner: false,
        home: const MainScreen(),
      ),
    );
  }
}

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('ALU Student Assistant')),
      body: ScheduleScreen(),
    );
  }
}
