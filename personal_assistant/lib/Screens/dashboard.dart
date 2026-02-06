import 'package:flutter/material.dart';
import 'package:personal_assistant/Screens/Settings.dart';

class Dashboard extends StatelessWidget {
  const Dashboard({super.key});

  // Helper function to get academic week (assuming 16-week semester starting from Feb 1)
  int getAcademicWeek() {
    final now = DateTime.now();
    final semesterStart = DateTime(2026, 24, 2); // Adjust this as needed
    final difference = now.difference(semesterStart).inDays;
    return (difference ~/ 7) + 1;
  }

  // Helper function to format date
  String formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  @override
  Widget build(BuildContext context) {
    // Mock data - replace with your actual data source
    final today = DateTime.now();
    final academicWeek = getAcademicWeek();
    double attendance = 80.0;
    bool lowAttendance = attendance < 75;
    final pendingAssignments = 4;

    // Mock data for today's sessions
    final List<Map<String, String>> todaySessions = [
      {'name': 'W5_pre_reading', 'time': '10:00 AM', 'type': 'Lecture'},
      {'name': 'Quiz 2', 'time': '11:00 AM', 'type': 'Assessment'},
      {'name': 'Formative Assessment', 'time': '12:00 PM', 'type': 'Lab'},
      {'name': 'Advanced Programming', 'time': '2:00 PM', 'type': 'Lecture'},
    ];

    // Mock data for upcoming assignments (due within 7 days)
    final List<Map<String, dynamic>> upcomingAssignments = [
      {'name': 'Database Design Project', 'dueDate': today.add(Duration(days: 2)), 'subject': 'Database Systems'},
      {'name': 'Research Paper', 'dueDate': today.add(Duration(days: 4)), 'subject': 'Research Methods'},
      {'name': 'Mobile App Prototype', 'dueDate': today.add(Duration(days: 6)), 'subject': 'Software Engineering'},
    ];

    return Scaffold(
      appBar: AppBar(
        title: Center(
            child: Text('Dashboard', style: TextStyle(color: Colors.white))),
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
                  SizedBox(width: 25,height: 10),
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
            ...todaySessions.map((session) {
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
                        session['time']!,
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
                            session['name']!,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          Text(
                            session['type']!,
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
            }).toList(),

            // Attendance Section with Warning
            Container(
              margin: EdgeInsets.all(16),
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: lowAttendance ? Colors.red[50] : Colors.green[50],
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: lowAttendance ? Colors.red[300]! : Colors.green[300]!,
                  width: 1,
                ),
              ),
              child: Row(
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
                          color: lowAttendance ? Colors.red[800] : Colors.green[800],
                        ),
                      ),
                    ],
                  ),
                  if (lowAttendance)
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: Colors.red[100],
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.warning, color: Colors.red[800], size: 16),
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
                  border: Border.all(color: Colors.grey),
                ),
                child: Center(
                  child: Text(
                    'No assignments due in the next 7 days',
                    style: TextStyle(color: Colors.grey),
                  ),
                ),
              ),
            ...upcomingAssignments.map((assignment) {
              final daysUntilDue = assignment['dueDate'].difference(today).inDays;
              final dueDateFormatted = formatDate(assignment['dueDate']);

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
                        color: daysUntilDue <= 2 ? Colors.red[400] : Colors.orange[400],
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                    SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            assignment['name'],
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          SizedBox(height: 4),
                          Row(
                            children: [
                              Icon(Icons.subject, size: 14, color: Colors.grey[600]),
                              SizedBox(width: 4),
                              Text(
                                assignment['subject'],
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
                          padding: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
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
            }).toList(),

            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}