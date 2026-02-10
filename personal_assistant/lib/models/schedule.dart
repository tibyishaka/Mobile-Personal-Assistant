enum SessionType { classSession, masterySession, studyGroup, pslMeeting }

class Schedule {
  final String id;
  final String userId;
  final String title;
  final DateTime date;
  final String startTime;
  final String endTime;
  final String? location;
  final SessionType sessionType;
  bool? isPresent;

  Schedule({
    required this.id,
    required this.userId,
    required this.title,
    required this.date,
    required this.startTime,
    required this.endTime,
    this.location,
    required this.sessionType,
    this.isPresent,
  });

  String get sessionTypeName {
    switch (sessionType) {
      case SessionType.classSession:
        return 'Class';
      case SessionType.masterySession:
        return 'Mastery Session';
      case SessionType.studyGroup:
        return 'Study Group';
      case SessionType.pslMeeting:
        return 'PSL Meeting';
    }
  }

  Schedule copyWith({
    String? id,
    String? userId,
    String? title,
    DateTime? date,
    String? startTime,
    String? endTime,
    String? location,
    SessionType? sessionType,
    bool? isPresent,
  }) {
    return Schedule(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      title: title ?? this.title,
      date: date ?? this.date,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      location: location ?? this.location,
      sessionType: sessionType ?? this.sessionType,
      isPresent: isPresent ?? this.isPresent,
    );
  }

  // Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'title': title,
      'date': date.toIso8601String(),
      'startTime': startTime,
      'endTime': endTime,
      'location': location,
      'sessionType': sessionType.index,
      'isPresent': isPresent,
    };
  }

  // Create from JSON
  factory Schedule.fromJson(Map<String, dynamic> json) {
    return Schedule(
      id: json['id'] as String,
      userId: json['userId'] as String? ?? '',
      title: json['title'] as String,
      date: DateTime.parse(json['date'] as String),
      startTime: json['startTime'] as String,
      endTime: json['endTime'] as String,
      location: json['location'] as String?,
      sessionType: SessionType.values[json['sessionType'] as int],
      isPresent: json['isPresent'] as bool?,
    );
  }
}
