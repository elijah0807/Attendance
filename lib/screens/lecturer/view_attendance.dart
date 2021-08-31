import 'package:attendance_system/screens/lecturer/view_student_record.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ViewAttendance extends StatefulWidget {
  final String id;
  final String courseTitle;

  ViewAttendance(this.id, this.courseTitle);

  @override
  _ViewAttendanceState createState() => _ViewAttendanceState();
}

class _ViewAttendanceState extends State<ViewAttendance> {
  final user = FirebaseAuth.instance.currentUser;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          Container(
            // alignment: Alignment.center,
            height: MediaQuery.of(context).size.height * 0.2,
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
                    '${widget.courseTitle} Attendance'.toUpperCase(),
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
          Container(
            height: MediaQuery.of(context).size.height * 0.8,
            width: MediaQuery.of(context).size.width,
            child: Padding(
              padding: EdgeInsets.all(10),
              child: StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('Attendance')
                      .doc(widget.id)
                      .collection('attendance')
                      .snapshots(),
                  builder: (context, snapshot) {
                    final data = snapshot.data!.docs;
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
                    return Card(
                      child: ListView.separated(
                        separatorBuilder: (context, int i) => Divider(),
                        itemCount: data.length,
                        itemBuilder: (context, int index) {
                          return Container(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  width: 150,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        data[index]['studentName'],
                                      ),
                                      Text(
                                        data[index]['regNo'],
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  width: 50,
                                  child: Icon(
                                    Icons.check,
                                    color: Colors.red,
                                  ),
                                )
                              ],
                            ),
                          );
                        },
                      ),
                    );
                  }),
            ),
          ),
        ],
      ),
    );
  }
}
