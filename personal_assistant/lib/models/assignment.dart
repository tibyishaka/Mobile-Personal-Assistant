import 'package:flutter/foundation.dart';
import 'dart:convert';

@immutable
class Assignment {
  final String id;
  final String title;
  final DateTime dueDate;
  final String courseName;
  final String priority;
  final bool isCompleted;

  Assignment({
    required this.id,
    required this.title,
    required this.dueDate,
    required this.courseName,
    this.priority = 'Medium',
    this.isCompleted = false,
  });

  Assignment copyWith({
    String? id,
    String? title,
    DateTime? dueDate,
    String? courseName,
    String? priority,
    bool? isCompleted,
  }) {
    return Assignment(
      id: id ?? this.id,
      title: title ?? this.title,
      dueDate: dueDate ?? this.dueDate,
      courseName: courseName ?? this.courseName,
      priority: priority ?? this.priority,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }

  // Convert to JSON map
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'dueDate': dueDate.toIso8601String(),
      'courseName': courseName,
      'priority': priority,
      'isCompleted': isCompleted,
    };
  }

  // Convert to JSON string (for SharedPreferences)
  String toJsonString() {
    return jsonEncode(toJson());
  }

  // Create from JSON map
  factory Assignment.fromJson(Map<String, dynamic> json) {
    return Assignment(
      id: json['id'] as String,
      title: json['title'] as String,
      dueDate: DateTime.parse(json['dueDate'] as String),
      courseName: json['courseName'] as String,
      priority: json['priority'] as String,
      isCompleted: json['isCompleted'] as bool,
    );
  }

  // Create from JSON string
  factory Assignment.fromJsonString(String jsonString) {
    final json = jsonDecode(jsonString) as Map<String, dynamic>;
    return Assignment.fromJson(json);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Assignment && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() {
    return 'Assignment(id: $id, title: $title, dueDate: $dueDate, courseName: $courseName, priority: $priority, isCompleted: $isCompleted)';
  }
}