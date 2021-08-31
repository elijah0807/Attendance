import 'package:attendance_system/screens/login.dart';
import 'package:attendance_system/screens/student/attend_class.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AttendanceStudent extends StatefulWidget {
  @override
  _AttendanceStudentState createState() => _AttendanceStudentState();
}

class _AttendanceStudentState extends State<AttendanceStudent> {
  final user = FirebaseAuth.instance.currentUser;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Scrollbar(
        thickness: 8,
        child: ListView(
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
                      height: 20,
                    ),
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        child: Text(
                          'Logout',
                          style: TextStyle(color: Colors.white),
                        ),
                        onPressed: () async {
                          await FirebaseAuth.instance.signOut().then((value) =>
                              Navigator.of(context)
                                  .push(MaterialPageRoute(builder: (content) {
                                return LoginScreen();
                              })));
                        },
                      ),
                    ),
                    SizedBox(
                      height: 60,
                    ),
                    Text(
                      'Available Class'.toUpperCase(),
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
                        .where('status', isEqualTo: 'open')
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
                      return ListView.separated(
                        separatorBuilder: (context, int i) => Divider(),
                        itemCount: data.length,
                        itemBuilder: (context, int index) {
                          return InkWell(
                            onTap: () {
                              Navigator.of(context)
                                  .push(MaterialPageRoute(builder: (context) {
                                return AttendClass(
                                  data[index]['id'],
                                  data[index]['attendanceTitle'],
                                  data[index]['courseTitle'],
                                  data[index]['courseCode'],
                                  data[index]['attendanceCode'],
                                );
                              }));
                            },
                            child: Card(
                              child: Container(
                                padding: EdgeInsets.all(10),
                                child: ListTile(
                                  leading: Container(
                                    padding: EdgeInsets.all(15),
                                    decoration: BoxDecoration(
                                        border: Border.all(
                                      color: Theme.of(context).primaryColor,
                                    )),
                                    child: Text(
                                      data[index]['courseCode']
                                          .toString()
                                          .toUpperCase(),
                                      style: TextStyle(
                                        // letterSpacing: 2,
                                        fontSize: 10,
                                      ),
                                    ),
                                  ),
                                  title: Text(data[index]['attendanceTitle']),
                                  subtitle: Text(data[index]['courseTitle'] +
                                      ' by: ' +
                                      data[index]['lecturerName']),
                                ),
                              ),
                            ),
                          );
                        },
                      );
                    }),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
