import 'package:flutter/foundation.dart';
import '../models/user.dart';

class AuthProvider extends ChangeNotifier {
  User? _currentUser;
  final List<User> _registeredUsers = [];
  bool _isAuthenticated = false;

  User? get currentUser => _currentUser;
  bool get isAuthenticated => _isAuthenticated;

  // Sign up - register new user
  bool signUp(String username, String email, String password) {
    // Check if email already exists
    final emailExists = _registeredUsers.any((user) => user.email == email);

    if (emailExists) {
      return false; // Email already registered
    }

    // Create and store new user
    final newUser = User(username: username, email: email, password: password);

    _registeredUsers.add(newUser);

    // Automatically log in after signup
    _currentUser = newUser;
    _isAuthenticated = true;
    notifyListeners();

    return true;
  }

  // Login - authenticate existing user
  bool login(String email, String password) {
    try {
      final user = _registeredUsers.firstWhere(
        (user) => user.email == email && user.password == password,
      );

      _currentUser = user;
      _isAuthenticated = true;
      notifyListeners();

      return true;
    } catch (e) {
      return false; // User not found or wrong credentials
    }
  }

  // Logout - clear current user
  void logout() {
    _currentUser = null;
    _isAuthenticated = false;
    notifyListeners();
  }

  // Check if email exists (for validation)
  bool emailExists(String email) {
    return _registeredUsers.any((user) => user.email == email);
  }
}
