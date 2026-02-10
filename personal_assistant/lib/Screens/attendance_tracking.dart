import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:personal_assistant/providers/schedule_provider.dart';
import 'package:intl/intl.dart';

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

  String selectedFilter = 'All Sessions';
  String selectedCourse = 'All Courses';

  @override
  Widget build(BuildContext context) {
    final scheduleProvider = context.watch<ScheduleProvider>();
    final schedules = scheduleProvider.schedules;

    // Calculate overall attendance
    final pastSchedules = schedules.where((s) {
      return s.date.isBefore(DateTime.now()) && s.isPresent != null;
    }).toList();

    final totalSessions = pastSchedules.length;
    final attendedSessions = pastSchedules
        .where((s) => s.isPresent == true)
        .length;
    final overallPercentage = totalSessions > 0
        ? (attendedSessions / totalSessions) * 100
        : 0.0;
    final isGoodAttendance = overallPercentage >= 75;

    // Get unique courses and their attendance
    final courseAttendance = <String, Map<String, int>>{};
    for (var schedule in pastSchedules) {
      if (!courseAttendance.containsKey(schedule.title)) {
        courseAttendance[schedule.title] = {'attended': 0, 'total': 0};
      }
      courseAttendance[schedule.title]!['total'] =
          courseAttendance[schedule.title]!['total']! + 1;
      if (schedule.isPresent == true) {
        courseAttendance[schedule.title]!['attended'] =
            courseAttendance[schedule.title]!['attended']! + 1;
      }
    }

    // Build courses list
    final courses = courseAttendance.entries
        .map(
          (entry) => {
            'name': entry.key,
            'attended': entry.value['attended']!,
            'total': entry.value['total']!,
          },
        )
        .toList();

    // Attendance history (sorted by date)
    final history =
        pastSchedules
            .map(
              (s) => {
                'date': DateFormat('MMM d, yyyy').format(s.date),
                'title': s.title,
                'course': s.sessionTypeName,
                'present': s.isPresent ?? false,
              },
            )
            .toList()
          ..sort(
            (a, b) => DateFormat('MMM d, yyyy')
                .parse(b['date'] as String)
                .compareTo(
                  DateFormat('MMM d, yyyy').parse(a['date'] as String),
                ),
          );

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
          _buildOverallSummary(
            overallPercentage,
            isGoodAttendance,
            attendedSessions,
            totalSessions,
          ),

          const SizedBox(height: 24),

          _buildRiskAlerts(
            courses,
            overallPercentage,
            attendedSessions,
            totalSessions,
          ),

          const SizedBox(height: 24),

          _buildCourseSection(courses),

          const SizedBox(height: 24),

          _buildFilters(courses),

          const SizedBox(height: 16),

          _buildHistorySection(history),
        ],
      ),
    );
  }

  Widget _buildOverallSummary(
    double percentage,
    bool isGood,
    int attended,
    int total,
  ) {
    final bool hasData = total > 0;

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
              if (hasData) ...[
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
                  'You have attended $attended out of $total sessions',
                  style: TextStyle(fontSize: 11, color: Colors.grey[700]),
                  textAlign: TextAlign.center,
                ),
              ] else ...[
                Icon(
                  Icons.calendar_today_outlined,
                  size: 48,
                  color: Colors.grey[400],
                ),
                const SizedBox(height: 10),
                Text(
                  'No attendance data yet',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                    color: Colors.grey[600],
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  'Start adding your schedule to track attendance',
                  style: TextStyle(fontSize: 12, color: Colors.grey[500]),
                  textAlign: TextAlign.center,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRiskAlerts(
    List<Map<String, dynamic>> courses,
    double overallPercentage,
    int attendedSessions,
    int totalSessions,
  ) {
    List<Widget> alerts = [];

    for (var course in courses) {
      double coursePercentage = course['total'] > 0
          ? (course['attended'] / course['total']) * 100
          : 0;
      if (coursePercentage < 75 && course['total'] > 0) {
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

    if (overallPercentage < 75 && totalSessions > 0) {
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

  Widget _buildCourseSection(List<Map<String, dynamic>> courses) {
    if (courses.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(20),
        child: Center(
          child: Text(
            'No course attendance data available yet',
            style: TextStyle(color: Colors.grey[600]),
          ),
        ),
      );
    }

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
    double percentage = course['total'] > 0
        ? (course['attended'] / course['total']) * 100
        : 0;
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

  Widget _buildFilters(List<Map<String, dynamic>> courses) {
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

  Widget _buildHistorySection(List<Map<String, dynamic>> history) {
    // Apply filters
    List<Map<String, dynamic>> filteredHistory = history.where((session) {
      // Filter by presence
      if (selectedFilter == 'Present Only' && !session['present']) return false;
      if (selectedFilter == 'Absent Only' && session['present']) return false;

      // Filter by course - match against title since we're using title as course name
      if (selectedCourse != 'All Courses' &&
          session['title'] != selectedCourse) {
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
                history.isEmpty
                    ? 'No attendance records yet'
                    : 'No sessions match your filters',
                style: TextStyle(color: Colors.grey[600]),
              ),
            ),
          )
        else
          ...filteredHistory.map((session) => _buildHistoryItem(session)),
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
}
