import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import '../models/user.dart';
import '../models/schedule.dart';
import '../models/assignment.dart';

class StorageService {
  static const String _usersFile = 'users.json';
  static const String _schedulesFile = 'schedules.json';
  static const String _assignmentsFile = 'assignments.json';

  // Get the app's documents directory
  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  // ========== USER MANAGEMENT ==========

  // Load all users
  Future<List<User>> loadUsers() async {
    try {
      final path = await _localPath;
      final file = File('$path/$_usersFile');

      if (!await file.exists()) {
        return [];
      }

      final contents = await file.readAsString();
      final List<dynamic> jsonData = jsonDecode(contents);
      return jsonData.map((json) => User.fromJson(json)).toList();
    } catch (e) {
      print('Error loading users: $e');
      return [];
    }
  }

  // Save all users
  Future<void> saveUsers(List<User> users) async {
    try {
      final path = await _localPath;
      final file = File('$path/$_usersFile');
      final jsonData = users.map((user) => user.toJson()).toList();
      await file.writeAsString(jsonEncode(jsonData));
    } catch (e) {
      print('Error saving users: $e');
    }
  }

  // ========== SCHEDULE MANAGEMENT ==========

  // Load all schedules
  Future<List<Schedule>> loadSchedules() async {
    try {
      final path = await _localPath;
      final file = File('$path/$_schedulesFile');

      if (!await file.exists()) {
        return [];
      }

      final contents = await file.readAsString();
      final List<dynamic> jsonData = jsonDecode(contents);
      return jsonData.map((json) => Schedule.fromJson(json)).toList();
    } catch (e) {
      print('Error loading schedules: $e');
      return [];
    }
  }

  // Save all schedules
  Future<void> saveSchedules(List<Schedule> schedules) async {
    try {
      final path = await _localPath;
      final file = File('$path/$_schedulesFile');
      final jsonData = schedules.map((schedule) => schedule.toJson()).toList();
      await file.writeAsString(jsonEncode(jsonData));
    } catch (e) {
      print('Error saving schedules: $e');
    }
  }

  // ========== ASSIGNMENT MANAGEMENT ==========

  // Load all assignments
  Future<List<Assignment>> loadAssignments() async {
    try {
      final path = await _localPath;
      final file = File('$path/$_assignmentsFile');

      if (!await file.exists()) {
        return [];
      }

      final contents = await file.readAsString();
      final List<dynamic> jsonData = jsonDecode(contents);
      return jsonData.map((json) => Assignment.fromJson(json)).toList();
    } catch (e) {
      print('Error loading assignments: $e');
      return [];
    }
  }

  // Save all assignments
  Future<void> saveAssignments(List<Assignment> assignments) async {
    try {
      final path = await _localPath;
      final file = File('$path/$_assignmentsFile');
      final jsonData = assignments
          .map((assignment) => assignment.toJson())
          .toList();
      await file.writeAsString(jsonEncode(jsonData));
    } catch (e) {
      print('Error saving assignments: $e');
    }
  }

  // ========== UTILITY METHODS ==========

  // Clear all data (for testing or logout)
  Future<void> clearAllData() async {
    try {
      final path = await _localPath;
      final usersFile = File('$path/$_usersFile');
      final schedulesFile = File('$path/$_schedulesFile');
      final assignmentsFile = File('$path/$_assignmentsFile');

      if (await usersFile.exists()) await usersFile.delete();
      if (await schedulesFile.exists()) await schedulesFile.delete();
      if (await assignmentsFile.exists()) await assignmentsFile.delete();
    } catch (e) {
      print('Error clearing data: $e');
    }
  }

  // Clear data for specific user
  Future<void> clearUserData(String userId) async {
    try {
      // Load all schedules and assignments
      final schedules = await loadSchedules();
      final assignments = await loadAssignments();

      // Filter out the user's data
      final filteredSchedules = schedules
          .where((s) => s.userId != userId)
          .toList();
      final filteredAssignments = assignments
          .where((a) => a.userId != userId)
          .toList();

      // Save filtered data back
      await saveSchedules(filteredSchedules);
      await saveAssignments(filteredAssignments);
    } catch (e) {
      print('Error clearing user data: $e');
    }
  }
}
