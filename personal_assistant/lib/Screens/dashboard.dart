import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:personal_assistant/Screens/Settings.dart';
import 'package:personal_assistant/providers/schedule_provider.dart';
import 'package:personal_assistant/providers/assignment_provider.dart';

class Dashboard extends StatelessWidget {
  const Dashboard({super.key});

  // Helper function to get academic week (assuming 16-week semester starting from Feb 1)
  int getAcademicWeek() {
    final now = DateTime.now();
    final semesterStart = DateTime(2026, 2, 1); // Fixed date format
    final difference = now.difference(semesterStart).inDays;
    return (difference ~/ 7) + 1;
  }

  // Helper function to format date
  String formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  @override
  Widget build(BuildContext context) {
    final today = DateTime.now();
    final academicWeek = getAcademicWeek();

    // Get data from providers
    final scheduleProvider = context.watch<ScheduleProvider>();
    final assignmentProvider = context.watch<AssignmentProvider>();

    final todaySchedules = scheduleProvider.getSchedulesForDate(today);

    // Check if there's any attendance data
    final pastSchedules = scheduleProvider.schedules.where((s) {
      return s.date.isBefore(today) && s.isPresent != null;
    }).toList();
    final hasAttendanceData = pastSchedules.isNotEmpty;

    final attendance = scheduleProvider.getAttendancePercentage();
    final lowAttendance = attendance < 75;

    // Get pending assignments (incomplete)
    final pendingAssignments = assignmentProvider.assignments
        .where((a) => !a.isCompleted)
        .length;

    // Get upcoming assignments (due within 7 days and not completed)
    final upcomingAssignments = assignmentProvider.assignments.where((a) {
      final daysUntilDue = a.dueDate.difference(today).inDays;
      return !a.isCompleted && daysUntilDue >= 0 && daysUntilDue <= 7;
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Text('Dashboard', style: TextStyle(color: Colors.white)),
        ),
        backgroundColor: Colors.blue[900],
        actions: [
          IconButton(
            icon: Icon(Icons.settings, color: Colors.white),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const Settings()),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Date and Academic Week Section
            Container(
              color: Colors.blue[900],
              padding: EdgeInsets.all(20),
              width: double.infinity,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    formatDate(today),
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(width: 25, height: 10),
                  Text(
                    'Academic Week $academicWeek',
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.9),
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),

            // Today's Sessions Section
            Padding(
              padding: EdgeInsets.fromLTRB(16, 20, 16, 8),
              child: Text(
                "Today's Schedule",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue[900],
                ),
              ),
            ),
            if (todaySchedules.isEmpty)
              Container(
                margin: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                padding: EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.grey[50],
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.grey.shade300),
                ),
                child: Center(
                  child: Text(
                    'No sessions scheduled for today',
                    style: TextStyle(color: Colors.grey[600]),
                  ),
                ),
              ),
            ...todaySchedules.map((schedule) {
              return Container(
                margin: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.grey[50],
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.grey),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.blue[50],
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        schedule.startTime,
                        style: TextStyle(
                          color: Colors.blue[900],
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            schedule.title,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          Text(
                            schedule.sessionTypeName,
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            }),

            // Attendance Section with Warning
            Container(
              margin: EdgeInsets.all(16),
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: hasAttendanceData
                    ? (lowAttendance ? Colors.red[50] : Colors.green[50])
                    : Colors.grey[50],
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: hasAttendanceData
                      ? (lowAttendance ? Colors.red[300]! : Colors.green[300]!)
                      : Colors.grey[300]!,
                  width: 1,
                ),
              ),
              child: hasAttendanceData
                  ? Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Attendance',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                color: Colors.grey[700],
                              ),
                            ),
                            SizedBox(height: 4),
                            Text(
                              '${attendance.toStringAsFixed(1)}%',
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: lowAttendance
                                    ? Colors.red[800]
                                    : Colors.green[800],
                              ),
                            ),
                          ],
                        ),
                        if (lowAttendance)
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.red[100],
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.warning,
                                  color: Colors.red[800],
                                  size: 16,
                                ),
                                SizedBox(width: 4),
                                Text(
                                  'Below 75%',
                                  style: TextStyle(
                                    color: Colors.red[800],
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ),
                      ],
                    )
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.info_outline,
                          color: Colors.grey[500],
                          size: 20,
                        ),
                        SizedBox(width: 8),
                        Text(
                          'No attendance data yet',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
            ),

            // Pending Assignments Summary
            Padding(
              padding: EdgeInsets.fromLTRB(16, 8, 16, 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Pending Assignments',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue[900],
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.orange[50],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      '$pendingAssignments',
                      style: TextStyle(
                        color: Colors.orange[800],
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Upcoming Assignments (Next 7 Days)
            Padding(
              padding: EdgeInsets.fromLTRB(16, 8, 16, 8),
              child: Text(
                'Due in Next 7 Days',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey[700],
                ),
              ),
            ),
            if (upcomingAssignments.isEmpty)
              Container(
                margin: EdgeInsets.symmetric(horizontal: 16),
                padding: EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.grey[50],
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.grey.shade300),
                ),
                child: Center(
                  child: Text(
                    'No assignments due in the next 7 days',
                    style: TextStyle(color: Colors.grey[600]),
                  ),
                ),
              ),
            ...upcomingAssignments.map((assignment) {
              final daysUntilDue = assignment.dueDate.difference(today).inDays;
              final dueDateFormatted = formatDate(assignment.dueDate);

              return Container(
                margin: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.grey),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.1),
                      blurRadius: 2,
                      offset: Offset(0, 1),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Container(
                      width: 4,
                      height: 40,
                      decoration: BoxDecoration(
                        color: daysUntilDue <= 2
                            ? Colors.red[400]
                            : Colors.orange[400],
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                    SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            assignment.title,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          SizedBox(height: 4),
                          Row(
                            children: [
                              Icon(
                                Icons.subject,
                                size: 14,
                                color: Colors.grey[600],
                              ),
                              SizedBox(width: 4),
                              Text(
                                assignment.courseName,
                                style: TextStyle(
                                  color: Colors.grey[600],
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          dueDateFormatted,
                          style: TextStyle(
                            color: Colors.grey[700],
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        SizedBox(height: 4),
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: daysUntilDue <= 2
                                ? Colors.red[100]
                                : daysUntilDue <= 4
                                ? Colors.orange[100]
                                : Colors.green[100],
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(
                            daysUntilDue == 0
                                ? 'Due Today'
                                : daysUntilDue == 1
                                ? 'Tomorrow'
                                : '$daysUntilDue days',
                            style: TextStyle(
                              color: daysUntilDue <= 2
                                  ? Colors.red[800]
                                  : daysUntilDue <= 4
                                  ? Colors.orange[800]
                                  : Colors.green[800],
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            }),

            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
