import 'package:flutter/material.dart';
import 'package:personal_assistant/providers/assignment_provider.dart';
import 'package:personal_assistant/providers/auth_provider.dart';
import 'package:provider/provider.dart';
import 'navigation_menu.dart';
import 'providers/schedule_provider.dart';
import 'Screens/login_screen.dart';

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
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => AssignmentProvider()),
        ChangeNotifierProvider(create: (_) => ScheduleProvider()),
      ],
      child: MaterialApp(
        title: 'Student Academic Assistant',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        home: const AuthWrapper(),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}

// AuthWrapper to handle authentication routing
class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthProvider>();

    // If authenticated, show NavigationMenu, otherwise show LoginScreen
    if (authProvider.isAuthenticated) {
      return const NavigationMenu();
    } else {
      return const LoginScreen();
    }
  }
}
