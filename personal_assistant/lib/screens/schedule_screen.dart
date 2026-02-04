import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../providers/schedule_provider.dart';
import '../models/schedule.dart';
import '../utils/constants.dart';
import 'add_schedule_screen.dart';

class ScheduleScreen extends StatefulWidget {
  const ScheduleScreen({super.key});

  @override
  State<ScheduleScreen> createState() => _ScheduleScreenState();
}

class _ScheduleScreenState extends State<ScheduleScreen> {
  DateTime selectedWeek = DateTime.now();

  DateTime getStartOfWeek(DateTime date) {
    return date.subtract(Duration(days: date.weekday - 1));
  }

  void previousWeek() {
    setState(() {
      selectedWeek = selectedWeek.subtract(Duration(days: 7));
    });
  }

  void nextWeek() {
    setState(() {
      selectedWeek = selectedWeek.add(Duration(days: 7));
    });
  }

  Color getSessionColor(SessionType type) {
    switch (type) {
      case SessionType.classSession:
        return AppColors.aluBlue;
      case SessionType.masterySession:
        return AppColors.aluRed;
      case SessionType.studyGroup:
        return Colors.orange;
      case SessionType.pslMeeting:
        return Colors.green;
    }
  }

  @override
  Widget build(BuildContext context) {
    DateTime startOfWeek = getStartOfWeek(selectedWeek);

    return Scaffold(
      appBar: AppBar(title: Text('Schedule')),
      body: Column(
        children: [
          Container(
            padding: EdgeInsets.all(16),
            color: AppColors.lightGrey,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  icon: Icon(Icons.chevron_left),
                  onPressed: previousWeek,
                ),
                Text(
                  '${DateFormat('MMM d').format(startOfWeek)} - ${DateFormat('MMM d, yyyy').format(startOfWeek.add(Duration(days: 6)))}',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
                IconButton(
                  icon: Icon(Icons.chevron_right),
                  onPressed: nextWeek,
                ),
              ],
            ),
          ),
          Expanded(
            child: Consumer<ScheduleProvider>(
              builder: (context, provider, child) {
                List<Schedule> weekSchedules = provider.getSchedulesForWeek(
                  startOfWeek,
                );

                if (weekSchedules.isEmpty) {
                  return Center(
                    child: Text(
                      'No sessions scheduled this week',
                      style: TextStyle(color: AppColors.grey),
                    ),
                  );
                }

                Map<String, List<Schedule>> groupedByDate = {};
                for (var schedule in weekSchedules) {
                  String dateKey = DateFormat(
                    'yyyy-MM-dd',
                  ).format(schedule.date);
                  if (!groupedByDate.containsKey(dateKey)) {
                    groupedByDate[dateKey] = [];
                  }
                  groupedByDate[dateKey]!.add(schedule);
                }

                return ListView.builder(
                  padding: EdgeInsets.all(16),
                  itemCount: groupedByDate.length,
                  itemBuilder: (context, index) {
                    String dateKey = groupedByDate.keys.elementAt(index);
                    List<Schedule> daySchedules = groupedByDate[dateKey]!;
                    DateTime date = DateTime.parse(dateKey);

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: EdgeInsets.symmetric(vertical: 8),
                          child: Text(
                            DateFormat('EEEE, MMMM d').format(date),
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: AppColors.aluBlue,
                            ),
                          ),
                        ),
                        ...daySchedules.map(
                          (schedule) =>
                              _buildScheduleCard(context, schedule, provider),
                        ),
                        SizedBox(height: 16),
                      ],
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddScheduleScreen()),
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }

  Widget _buildScheduleCard(
    BuildContext context,
    Schedule schedule,
    ScheduleProvider provider,
  ) {
    bool isPast = schedule.date.isBefore(DateTime.now());

    return Card(
      margin: EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddScheduleScreen(schedule: schedule),
            ),
          );
        },
        child: Container(
          decoration: BoxDecoration(
            border: Border(
              left: BorderSide(
                color: getSessionColor(schedule.sessionType),
                width: 4,
              ),
            ),
          ),
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            schedule.title,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            schedule.sessionTypeName,
                            style: TextStyle(
                              color: getSessionColor(schedule.sessionType),
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                    PopupMenuButton(
                      itemBuilder: (context) => [
                        PopupMenuItem(value: 'edit', child: Text('Edit')),
                        PopupMenuItem(value: 'delete', child: Text('Delete')),
                      ],
                      onSelected: (value) {
                        if (value == 'edit') {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  AddScheduleScreen(schedule: schedule),
                            ),
                          );
                        } else if (value == 'delete') {
                          provider.deleteSchedule(schedule.id);
                        }
                      },
                    ),
                  ],
                ),
                SizedBox(height: 8),
                Row(
                  children: [
                    Icon(Icons.access_time, size: 16, color: AppColors.grey),
                    SizedBox(width: 4),
                    Text(
                      '${schedule.startTime} - ${schedule.endTime}',
                      style: TextStyle(color: AppColors.grey),
                    ),
                  ],
                ),
                if (schedule.location != null &&
                    schedule.location!.isNotEmpty) ...[
                  SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(Icons.location_on, size: 16, color: AppColors.grey),
                      SizedBox(width: 4),
                      Text(
                        schedule.location!,
                        style: TextStyle(color: AppColors.grey),
                      ),
                    ],
                  ),
                ],
                if (isPast) ...[
                  SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Present',
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 15,
                        ),
                      ),
                      Row(
                        children: [
                          Text(
                            'No',
                            style: TextStyle(
                              color: schedule.isPresent == false
                                  ? AppColors.aluRed
                                  : AppColors.grey,
                              fontWeight: schedule.isPresent == false
                                  ? FontWeight.w600
                                  : FontWeight.normal,
                            ),
                          ),
                          Switch(
                            value: schedule.isPresent ?? false,
                            onChanged: (value) {
                              provider.toggleAttendance(schedule.id, value);
                            },
                            activeColor: Colors.green,
                            inactiveThumbColor: AppColors.aluRed,
                          ),
                          Text(
                            'Yes',
                            style: TextStyle(
                              color: schedule.isPresent == true
                                  ? Colors.green
                                  : AppColors.grey,
                              fontWeight: schedule.isPresent == true
                                  ? FontWeight.w600
                                  : FontWeight.normal,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
