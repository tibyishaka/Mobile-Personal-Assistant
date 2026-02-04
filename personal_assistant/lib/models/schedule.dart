enum SessionType { classSession, masterySession, studyGroup, pslMeeting }

class Schedule {
  final String id;
  final String title;
  final DateTime date;
  final String startTime;
  final String endTime;
  final String? location;
  final SessionType sessionType;
  bool? isPresent;

  Schedule({
    required this.id,
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
      title: title ?? this.title,
      date: date ?? this.date,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      location: location ?? this.location,
      sessionType: sessionType ?? this.sessionType,
      isPresent: isPresent ?? this.isPresent,
    );
  }
}
