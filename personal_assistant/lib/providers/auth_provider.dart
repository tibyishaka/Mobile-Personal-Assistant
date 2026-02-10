import 'package:flutter/foundation.dart';
import '../models/user.dart';
import '../services/storage_service.dart';

class AuthProvider extends ChangeNotifier {
  User? _currentUser;
  List<User> _registeredUsers = [];
  bool _isAuthenticated = false;
  final StorageService _storageService = StorageService();
  bool _isInitialized = false;

  User? get currentUser => _currentUser;
  bool get isAuthenticated => _isAuthenticated;
  bool get isInitialized => _isInitialized;

  // Initialize and load users from storage
  Future<void> initialize() async {
    if (_isInitialized) return;

    _registeredUsers = await _storageService.loadUsers();
    _isInitialized = true;
    notifyListeners();
  }

  // Sign up - register new user
  Future<bool> signUp(String username, String email, String password) async {
    // Check if email already exists
    final emailExists = _registeredUsers.any((user) => user.email == email);

    if (emailExists) {
      return false; // Email already registered
    }

    // Create and store new user
    final newUser = User(username: username, email: email, password: password);

    _registeredUsers.add(newUser);
    await _storageService.saveUsers(_registeredUsers);

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

  // Get current user ID (email)
  String? get currentUserId => _currentUser?.email;

  // Check if email exists (for validation)
  bool emailExists(String email) {
    return _registeredUsers.any((user) => user.email == email);
  }
}
