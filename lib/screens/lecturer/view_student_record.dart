import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/percent_indicator.dart';

class ViewStudentRecord extends StatefulWidget {
  final String studentId;

  ViewStudentRecord(this.studentId);
  @override
  _ViewStudentRecordState createState() => _ViewStudentRecordState();
}

class _ViewStudentRecordState extends State<ViewStudentRecord> {
  final user = FirebaseAuth.instance.currentUser;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: ListView(
        children: [
          Container(
            // alignment: Alignment.center,
            height: MediaQuery.of(context).size.height * 0.3,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(100),
                bottomRight: Radius.circular(100),
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  SizedBox(
                    height: 60,
                  ),
                  Text(
                    'Student Attendance Record',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(
            height: 60,
          ),
          Container(
            height: MediaQuery.of(context).size.height * 0.8,
            width: MediaQuery.of(context).size.width,
            child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('Attendance')
                    .where('lecturerId', isEqualTo: user!.uid)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  }
                  if (!snapshot.hasData) {
                    return Center(
                      child: Text('No Record'),
                    );
                  }
                  if (snapshot.data!.docs.isEmpty) {
                    return Center(
                      child: Text('No Record'),
                    );
                  }
                  final fullAttend = snapshot.data!.docs;
                  return StreamBuilder<QuerySnapshot>(
                      stream: FirebaseFirestore.instance
                          .collection('user_attendance')
                          .doc(widget.studentId)
                          .collection('attendance')
                          .snapshots(),
                      builder: (context, snapshot) {
                        final userAttend = snapshot.data!.docs;

                        var percentage =
                            (userAttend.length / fullAttend.length);
                        int perc = (percentage * 100).ceil();
                        print(perc);
                        print(percentage * 100);
                        return Column(
                          children: [
                            Center(
                              child: CircularPercentIndicator(
                                radius: 120.0,
                                lineWidth: 13.0,
                                animation: true,
                                percent: percentage,
                                center: new Text(
                                  "${perc.toString()}%",
                                  style: new TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20.0),
                                ),
                                footer: Padding(
                                  padding: const EdgeInsets.all(60.0),
                                  child: new Text(
                                    "Student Attendacnce %",
                                    style: new TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 17.0),
                                  ),
                                ),
                                circularStrokeCap: CircularStrokeCap.round,
                                progressColor: Theme.of(context).primaryColor,
                              ),
                            ),
                          ],
                        );
                      });
                }),
          ),
        ],
      ),
    );
  }
}
