import 'package:flutter/material.dart';
import '../models/schedule.dart';

class ScheduleProvider extends ChangeNotifier {
  final List<Schedule> _schedules = [];

  List<Schedule> get schedules => [..._schedules];

  List<Schedule> getSchedulesForDate(DateTime date) {
    return _schedules.where((schedule) {
      return schedule.date.year == date.year &&
          schedule.date.month == date.month &&
          schedule.date.day == date.day;
    }).toList()..sort((a, b) => a.startTime.compareTo(b.startTime));
  }

  List<Schedule> getSchedulesForWeek(DateTime startOfWeek) {
    DateTime endOfWeek = startOfWeek.add(Duration(days: 7));
    return _schedules.where((schedule) {
      return schedule.date.isAfter(startOfWeek.subtract(Duration(days: 1))) &&
          schedule.date.isBefore(endOfWeek);
    }).toList()..sort((a, b) {
      int dateCompare = a.date.compareTo(b.date);
      if (dateCompare != 0) return dateCompare;
      return a.startTime.compareTo(b.startTime);
    });
  }

  void addSchedule(Schedule schedule) {
    _schedules.add(schedule);
    notifyListeners();
  }

  void updateSchedule(String id, Schedule updatedSchedule) {
    int index = _schedules.indexWhere((s) => s.id == id);
    if (index != -1) {
      _schedules[index] = updatedSchedule;
      notifyListeners();
    }
  }

  void deleteSchedule(String id) {
    _schedules.removeWhere((s) => s.id == id);
    notifyListeners();
  }

  void toggleAttendance(String id, bool isPresent) {
    int index = _schedules.indexWhere((s) => s.id == id);
    if (index != -1) {
      _schedules[index].isPresent = isPresent;
      notifyListeners();
    }
  }

  double getAttendancePercentage() {
    if (_schedules.isEmpty) return 0.0;

    List<Schedule> pastSchedules = _schedules.where((s) {
      return s.date.isBefore(DateTime.now()) && s.isPresent != null;
    }).toList();

    if (pastSchedules.isEmpty) return 0.0;

    int presentCount = pastSchedules.where((s) => s.isPresent == true).length;
    return (presentCount / pastSchedules.length) * 100;
  }
}
