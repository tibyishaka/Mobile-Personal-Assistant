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
        home: const AppInitializer(),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}

// Initialize providers before showing content
class AppInitializer extends StatefulWidget {
  const AppInitializer({super.key});

  @override
  State<AppInitializer> createState() => _AppInitializerState();
}

class _AppInitializerState extends State<AppInitializer> {
  bool _isInitializing = true;

  @override
  void initState() {
    super.initState();
    _initializeApp();
  }

  Future<void> _initializeApp() async {
    final authProvider = context.read<AuthProvider>();
    final scheduleProvider = context.read<ScheduleProvider>();
    final assignmentProvider = context.read<AssignmentProvider>();

    // Initialize all providers
    await Future.wait([
      authProvider.initialize(),
      scheduleProvider.initialize(),
      assignmentProvider.initialize(),
    ]);

    setState(() {
      _isInitializing = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_isInitializing) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return const AuthWrapper();
  }
}

// AuthWrapper to handle authentication routing
class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthProvider>();
    final scheduleProvider = context.watch<ScheduleProvider>();
    final assignmentProvider = context.watch<AssignmentProvider>();

    // Update providers with current user ID when authentication state changes
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final userId = authProvider.currentUserId;
      scheduleProvider.setCurrentUser(userId);
      assignmentProvider.setCurrentUser(userId);
    });

    // If authenticated, show NavigationMenu, otherwise show LoginScreen
    if (authProvider.isAuthenticated) {
      return const NavigationMenu();
    } else {
      return const LoginScreen();
    }
  }
}
