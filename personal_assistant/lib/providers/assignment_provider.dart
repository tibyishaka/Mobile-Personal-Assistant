import 'package:flutter/material.dart';
import 'package:personal_assistant/models/assignment.dart';
import '../services/storage_service.dart';

class AssignmentProvider extends ChangeNotifier {
  List<Assignment> _assignments = [];
  final StorageService _storageService = StorageService();
  bool _isInitialized = false;
  String? _currentUserId;

  List<Assignment> get assignments =>
      _assignments.where((a) => a.userId == _currentUserId).toList();
  bool get isInitialized => _isInitialized;

  // Initialize and load assignments from storage
  Future<void> initialize({String? userId}) async {
    _currentUserId = userId;
    if (_isInitialized) {
      notifyListeners();
      return;
    }

    _assignments = await _storageService.loadAssignments();
    _assignments.sort((a, b) => a.dueDate.compareTo(b.dueDate));
    _isInitialized = true;
    notifyListeners();
  }

  // Set current user to filter data
  void setCurrentUser(String? userId) {
    _currentUserId = userId;
    notifyListeners();
  }

  // Clear current user's data
  Future<void> clearCurrentUserData() async {
    if (_currentUserId == null) return;
    _assignments.removeWhere((a) => a.userId == _currentUserId);
    await _storageService.saveAssignments(_assignments);
    notifyListeners();
  }

  Future<void> addAssignment(Assignment assignment) async {
    _assignments.add(assignment);
    _assignments.sort((a, b) => a.dueDate.compareTo(b.dueDate));
    await _storageService.saveAssignments(_assignments);
    notifyListeners();
  }

  Future<void> updateAssignment(Assignment assignment) async {
    final index = _assignments.indexWhere((a) => a.id == assignment.id);
    if (index != -1) {
      _assignments[index] = assignment;
      _assignments.sort((a, b) => a.dueDate.compareTo(b.dueDate));
      await _storageService.saveAssignments(_assignments);
      notifyListeners();
    }
  }

  Future<void> deleteAssignment(String id) async {
    _assignments.removeWhere((a) => a.id == id);
    await _storageService.saveAssignments(_assignments);
    notifyListeners();
  }

  Future<void> toggleCompletion(String id) async {
    final index = _assignments.indexWhere((a) => a.id == id);
    if (index != -1) {
      _assignments[index] = _assignments[index].copyWith(
        isCompleted: !_assignments[index].isCompleted,
      );
      await _storageService.saveAssignments(_assignments);
      notifyListeners();
    }
  }
}
