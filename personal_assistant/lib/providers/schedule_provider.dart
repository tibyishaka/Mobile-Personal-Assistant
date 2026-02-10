import 'package:flutter/material.dart';
import '../models/schedule.dart';
import '../services/storage_service.dart';

class ScheduleProvider extends ChangeNotifier {
  List<Schedule> _schedules = [];
  final StorageService _storageService = StorageService();
  bool _isInitialized = false;
  String? _currentUserId;

  List<Schedule> get schedules =>
      _schedules.where((s) => s.userId == _currentUserId).toList();
  bool get isInitialized => _isInitialized;

  // Initialize and load schedules from storage
  Future<void> initialize({String? userId}) async {
    _currentUserId = userId;
    if (_isInitialized) {
      notifyListeners();
      return;
    }

    _schedules = await _storageService.loadSchedules();
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
    _schedules.removeWhere((s) => s.userId == _currentUserId);
    await _storageService.saveSchedules(_schedules);
    notifyListeners();
  }

  // Get all unique class names (for assignment dropdown)
  List<String> getClassNames() {
    return _schedules
        .where(
          (schedule) =>
              schedule.sessionType == SessionType.classSession &&
              schedule.userId == _currentUserId,
        )
        .map((schedule) => schedule.title)
        .toSet() // Remove duplicates
        .toList()
      ..sort(); // Sort alphabetically
  }

  List<Schedule> getSchedulesForDate(DateTime date) {
    return _schedules.where((schedule) {
      return schedule.userId == _currentUserId &&
          schedule.date.year == date.year &&
          schedule.date.month == date.month &&
          schedule.date.day == date.day;
    }).toList()..sort((a, b) => a.startTime.compareTo(b.startTime));
  }

  List<Schedule> getSchedulesForWeek(DateTime startOfWeek) {
    DateTime endOfWeek = startOfWeek.add(Duration(days: 7));
    return _schedules.where((schedule) {
      return schedule.userId == _currentUserId &&
          schedule.date.isAfter(startOfWeek.subtract(Duration(days: 1))) &&
          schedule.date.isBefore(endOfWeek);
    }).toList()..sort((a, b) {
      int dateCompare = a.date.compareTo(b.date);
      if (dateCompare != 0) return dateCompare;
      return a.startTime.compareTo(b.startTime);
    });
  }

  Future<void> addSchedule(Schedule schedule) async {
    _schedules.add(schedule);
    await _storageService.saveSchedules(_schedules);
    notifyListeners();
  }

  Future<void> updateSchedule(String id, Schedule updatedSchedule) async {
    int index = _schedules.indexWhere((s) => s.id == id);
    if (index != -1) {
      _schedules[index] = updatedSchedule;
      await _storageService.saveSchedules(_schedules);
      notifyListeners();
    }
  }

  Future<void> deleteSchedule(String id) async {
    _schedules.removeWhere((s) => s.id == id);
    await _storageService.saveSchedules(_schedules);
    notifyListeners();
  }

  Future<void> toggleAttendance(String id, bool isPresent) async {
    int index = _schedules.indexWhere((s) => s.id == id);
    if (index != -1) {
      _schedules[index].isPresent = isPresent;
      await _storageService.saveSchedules(_schedules);
      notifyListeners();
    }
  }

  double getAttendancePercentage() {
    final userSchedules = _schedules
        .where((s) => s.userId == _currentUserId)
        .toList();
    if (userSchedules.isEmpty) return 0.0;

    List<Schedule> pastSchedules = userSchedules.where((s) {
      return s.date.isBefore(DateTime.now()) && s.isPresent != null;
    }).toList();

    if (pastSchedules.isEmpty) return 0.0;

    int presentCount = pastSchedules.where((s) => s.isPresent == true).length;
    return (presentCount / pastSchedules.length) * 100;
  }
}
