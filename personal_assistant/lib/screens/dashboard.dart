import 'package:flutter/material.dart';

class Dashboard extends StatelessWidget {

    Dashboard({super.key});
  @override
  Widget build(BuildContext context) {
    double attendance = 70.0;
    bool low = attendance < 75;
    String date = DateTime.now().toString().substring(0, 10);

    return Scaffold(
      appBar: AppBar(
        title: Text('Dashboard',
         style: TextStyle(color: Colors.white),),backgroundColor: Colors.blue[900],
         actions: [
          IconButton(
            icon: Icon(Icons.settings, color: Colors.white),
            onPressed: () {
              // Settings action
            },
          ),
        ],
         ),
        body: Column(
          children: [
            Container(
              color: Colors.blue[900],
              padding: EdgeInsets.all(20),
              width: double.infinity,
              child: Text('Date:$date\nWeek 5',style: TextStyle(color: Colors.white),
              ),
              
            ),
            Padding(
              padding: EdgeInsets.all(15),
              child: Row(
                children: [Text('W5_pre_reading - 10:00AM', style: TextStyle(fontSize: 18)),
                ],
              ),
            ),
             Padding(
              padding: EdgeInsets.all(15),
              child: Row(
                children: [Text('Quiz2 - 11:00AM', style: TextStyle(fontSize: 18)),
                ],
              ),
            ),

             Padding(
              padding: EdgeInsets.all(15),
              child: Row(
                children: [Text('formative - 12:00PM', style: TextStyle(fontSize: 18)),
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.all(16),
              padding: EdgeInsets.all(15),
              decoration: BoxDecoration(
                color: low ? Colors.red[100] : Colors.green[100],
                border: Border.all(color: low ? Colors.red : Colors.green),
              ),
              child: Row (
                children: [
                  Text('Attendance: $attendance'),
                  if (low)
                    Text(' (Low)', style: TextStyle(color: Colors.red)),
          ],
          ),
          ),
          const Padding(
            padding: EdgeInsets.all(16),
            child: Text('Pending Assignments:4', style: TextStyle(fontWeight: FontWeight.bold)),
          ),
          ],
        ),
        );
        }      
  }