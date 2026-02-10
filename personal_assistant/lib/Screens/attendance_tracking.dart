import 'package:flutter/material.dart';

class AttendanceTracking extends StatefulWidget {
  const AttendanceTracking({super.key});

  @override
  State<AttendanceTracking> createState() => _AttendanceTrackingState();
}

class _AttendanceTrackingState extends State<AttendanceTracking> {
  // Color scheme
  final Color deepRed = const Color(0xFF8B0000);
  final Color darkBlue = const Color(0xFF003366);
  final Color white = Colors.white;

  // Sample data for demonstration
  final int totalSessions = 24;
  final int attendedSessions = 18;

  // Course data: [courseName, attended, total]
  final List<Map<String, dynamic>> courses = [
    {'name': 'Data Structures', 'attended': 6, 'total': 8},
    {'name': 'Web Development', 'attended': 5, 'total': 6},
    {'name': 'Database Systems', 'attended': 4, 'total': 6},
    {'name': 'Mobile Development', 'attended': 3, 'total': 4},
  ];

  // Attendance history: [date, title, course, isPresent]
  final List<Map<String, dynamic>> history = [
    {
      'date': 'Feb 3, 2026',
      'title': 'Lecture 8',
      'course': 'Data Structures',
      'present': true,
    },
    {
      'date': 'Feb 2, 2026',
      'title': 'Lab 3',
      'course': 'Web Development',
      'present': true,
    },
    {
      'date': 'Feb 1, 2026',
      'title': 'Lecture 6',
      'course': 'Database Systems',
      'present': false,
    },
    {
      'date': 'Jan 31, 2026',
      'title': 'Lecture 4',
      'course': 'Mobile Development',
      'present': true,
    },
    {
      'date': 'Jan 30, 2026',
      'title': 'Lecture 7',
      'course': 'Data Structures',
      'present': false,
    },
    {
      'date': 'Jan 29, 2026',
      'title': 'Lab 2',
      'course': 'Web Development',
      'present': true,
    },
  ];

  String selectedFilter = 'All Sessions';
  String selectedCourse = 'All Courses';

  @override
  Widget build(BuildContext context) {
    double overallPercentage = (attendedSessions / totalSessions) * 100;
    bool isGoodAttendance = overallPercentage >= 75;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Attendance Tracking'),
        backgroundColor: darkBlue,
        foregroundColor: white,
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          _buildOverallSummary(overallPercentage, isGoodAttendance),

          const SizedBox(height: 24),

          _buildRiskAlerts(),

          const SizedBox(height: 24),

          _buildCourseSection(),

          const SizedBox(height: 24),

          _buildFilters(),

          const SizedBox(height: 16),

          _buildHistorySection(),
        ],
      ),
    );
  }

  Widget _buildOverallSummary(double percentage, bool isGood) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.85,
      child: Card(
        elevation: 4,
        color: white,
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            children: [
              Text(
                'Overall Attendance',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: darkBlue,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                '${percentage.toStringAsFixed(1)}%',
                style: TextStyle(
                  fontSize: 36,
                  fontWeight: FontWeight.bold,
                  color: isGood ? Colors.green : deepRed,
                ),
              ),

              const SizedBox(height: 6),

              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: isGood ? Colors.green : deepRed,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  isGood ? 'Good Standing' : 'At Risk',
                  style: TextStyle(
                    color: white,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
              ),

              const SizedBox(height: 8),

              Text(
                'You have attended $attendedSessions out of $totalSessions sessions',
                style: TextStyle(fontSize: 11, color: Colors.grey[700]),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRiskAlerts() {
    List<Widget> alerts = [];

    for (var course in courses) {
      double coursePercentage = (course['attended'] / course['total']) * 100;
      if (coursePercentage < 75) {
        alerts.add(
          Container(
            margin: const EdgeInsets.only(bottom: 8),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: deepRed.withOpacity(0.1),
              border: Border.all(color: deepRed, width: 2),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                Icon(Icons.warning, color: deepRed, size: 24),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'You are below 75% in ${course['name']} (${coursePercentage.toStringAsFixed(1)}%)',
                    style: TextStyle(
                      color: deepRed,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      }
    }

    if (overallPercentage < 75) {
      int sessionsNeeded = ((totalSessions * 0.75) - attendedSessions).ceil();
      if (sessionsNeeded > 0) {
        alerts.add(
          Container(
            margin: const EdgeInsets.only(bottom: 8),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: deepRed.withOpacity(0.1),
              border: Border.all(color: deepRed, width: 2),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                Icon(Icons.error, color: deepRed, size: 24),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'You need to attend at least $sessionsNeeded more session(s) to reach 75%',
                    style: TextStyle(
                      color: deepRed,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      }
    }

    if (alerts.isEmpty) {
      return Container();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Alerts & Warnings',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: darkBlue,
          ),
        ),
        const SizedBox(height: 12),
        ...alerts,
      ],
    );
  }

  Widget _buildCourseSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Attendance by Course',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: darkBlue,
          ),
        ),
        const SizedBox(height: 12),
        ...courses.map((course) => _buildCourseCard(course)),
      ],
    );
  }

  Widget _buildCourseCard(Map<String, dynamic> course) {
    double percentage = (course['attended'] / course['total']) * 100;
    bool isGood = percentage >= 75;

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    course['name'],
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: darkBlue,
                    ),
                  ),
                ),
                Text(
                  '${percentage.toStringAsFixed(1)}%',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: isGood ? Colors.green : deepRed,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),

            Text(
              '${course['attended']} / ${course['total']} sessions attended',
              style: TextStyle(fontSize: 14, color: Colors.grey[600]),
            ),

            const SizedBox(height: 12),

            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: LinearProgressIndicator(
                value: percentage / 100,
                backgroundColor: Colors.grey[300],
                valueColor: AlwaysStoppedAnimation<Color>(
                  isGood ? Colors.green : deepRed,
                ),
                minHeight: 8,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFilters() {
    return Row(
      children: [
        Expanded(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(8),
            ),
            child: DropdownButton<String>(
              value: selectedFilter,
              isExpanded: true,
              underline: Container(),
              items: ['All Sessions', 'Present Only', 'Absent Only'].map((
                String value,
              ) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: (String? newValue) {
                if (newValue != null) {
                  setState(() {
                    selectedFilter = newValue;
                  });
                }
              },
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(8),
            ),
            child: DropdownButton<String>(
              value: selectedCourse,
              isExpanded: true,
              underline: Container(),
              items: ['All Courses', ...courses.map((c) => c['name'] as String)]
                  .map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value, overflow: TextOverflow.ellipsis),
                    );
                  })
                  .toList(),
              onChanged: (String? newValue) {
                if (newValue != null) {
                  setState(() {
                    selectedCourse = newValue;
                  });
                }
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildHistorySection() {
    // Apply filters
    List<Map<String, dynamic>> filteredHistory = history.where((session) {
      // Filter by presence
      if (selectedFilter == 'Present Only' && !session['present']) return false;
      if (selectedFilter == 'Absent Only' && session['present']) return false;

      // Filter by course
      if (selectedCourse != 'All Courses' &&
          session['course'] != selectedCourse) {
        return false;
      }

      return true;
    }).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Attendance History',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: darkBlue,
          ),
        ),
        const SizedBox(height: 12),

        if (filteredHistory.isEmpty)
          Center(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Text(
                'No sessions match your filters',
                style: TextStyle(color: Colors.grey[600]),
              ),
            ),
          )
        else
          ...filteredHistory
              .map((session) => _buildHistoryItem(session))
              ,
      ],
    );
  }

  Widget _buildHistoryItem(Map<String, dynamic> session) {
    bool isPresent = session['present'];

    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      elevation: 1,
      child: ListTile(
        leading: Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: isPresent
                ? Colors.green.withOpacity(0.1)
                : deepRed.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            isPresent ? Icons.check_circle : Icons.cancel,
            color: isPresent ? Colors.green : deepRed,
            size: 28,
          ),
        ),
        title: Text(
          session['title'],
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Text(session['course']),
            Text(
              session['date'],
              style: TextStyle(fontSize: 12, color: Colors.grey[600]),
            ),
          ],
        ),
        trailing: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          decoration: BoxDecoration(
            color: isPresent ? Colors.green : deepRed,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            isPresent ? 'Present' : 'Absent',
            style: TextStyle(
              color: white,
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }

  double get overallPercentage => (attendedSessions / totalSessions) * 100;
}
