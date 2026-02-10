import 'package:flutter/material.dart';
import 'package:personal_assistant/models/assignment.dart';

class AssignmentProvider extends ChangeNotifier {
  final List<Assignment> _assignments = [];

  List<Assignment> get assignments => List.unmodifiable(_assignments);

  void addAssignment(Assignment assignment) {
    _assignments.add(assignment);
    _assignments.sort((a, b) => a.dueDate.compareTo(b.dueDate));
    notifyListeners();
  }

  void updateAssignment(Assignment assignment) {
    final index = _assignments.indexWhere((a) => a.id == assignment.id);
    if (index != -1) {
      _assignments[index] = assignment;
      _assignments.sort((a, b) => a.dueDate.compareTo(b.dueDate));
      notifyListeners();
    }
  }

  void deleteAssignment(String id) {
    _assignments.removeWhere((a) => a.id == id);
    notifyListeners();
  }

  void toggleCompletion(String id) {
    final index = _assignments.indexWhere((a) => a.id == id);
    if (index != -1) {
      _assignments[index] = _assignments[index].copyWith(
        isCompleted: !_assignments[index].isCompleted,
      );
      notifyListeners();
    }
  }
}