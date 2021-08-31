import 'package:attendance_system/screens/lecturer/create_attendance.dart';
import 'package:attendance_system/screens/lecturer/students.dart';
import 'package:attendance_system/screens/lecturer/view_attendance.dart';
import 'package:attendance_system/screens/login.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Attendance extends StatefulWidget {
  @override
  _AttendanceState createState() => _AttendanceState();
}

class _AttendanceState extends State<Attendance> {
  final user = FirebaseAuth.instance.currentUser;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
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
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton.icon(
                          onPressed: () {
                            Navigator.of(context)
                                .push(MaterialPageRoute(builder: (context) {
                              return CreateAttendance();
                            }));
                          },
                          icon: Icon(
                            Icons.add_box_rounded,
                            color: Colors.white,
                          ),
                          label: Text(
                            'Add New',
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        TextButton.icon(
                          onPressed: () {
                            Navigator.of(context)
                                .push(MaterialPageRoute(builder: (context) {
                              return Students();
                            }));
                          },
                          icon: Icon(
                            Icons.remove_red_eye,
                            color: Colors.white,
                          ),
                          label: Text(
                            'View Record',
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
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
                      'My Attendance',
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
                        .where('lecturerId', isEqualTo: user!.uid)
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
                                return ViewAttendance(data[index]['id'],
                                    data[index]['courseTitle']);
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
                                  subtitle: Text(data[index]['courseTitle']),
                                  trailing: Container(
                                    width: 100,
                                    child: Row(
                                      children: [
                                        if (data[index]['status'] == 'open')
                                          IconButton(
                                            onPressed: () {
                                              showDialog(
                                                context: context,
                                                builder: (context) =>
                                                    AlertDialog(
                                                  title: Text('Attention!!!'),
                                                  content: Text(
                                                      'Close this Attendance'),
                                                  actions: [
                                                    TextButton(
                                                        child: Text('No'),
                                                        onPressed: () {
                                                          Navigator.of(context)
                                                              .pop();
                                                        }),
                                                    TextButton(
                                                        child: Text('Yes'),
                                                        onPressed: () async {
                                                          // await FirebaseAuth.instance.currentUser.
                                                          await FirebaseFirestore
                                                              .instance
                                                              .collection(
                                                                  'Attendance')
                                                              .doc(data[index]
                                                                  ['id'])
                                                              .update({
                                                            'status': 'closed',
                                                          }).then(
                                                            (value) =>
                                                                Navigator.of(
                                                                        context)
                                                                    .pop(),
                                                          );
                                                        })
                                                  ],
                                                ),
                                              );
                                            },
                                            icon: Icon(
                                              Icons.close,
                                              color: Colors.deepPurple,
                                            ),
                                          ),
                                        IconButton(
                                          onPressed: () {
                                            showDialog(
                                              context: context,
                                              builder: (context) => AlertDialog(
                                                title: Text('Warning'),
                                                content:
                                                    Text('Delete Attendance'),
                                                actions: [
                                                  TextButton(
                                                      child: Text('No'),
                                                      onPressed: () async {
                                                        Navigator.of(context)
                                                            .pop();
                                                      }),
                                                  TextButton(
                                                      child: Text('Yes'),
                                                      onPressed: () async {
                                                        // await FirebaseAuth.instance.currentUser.
                                                        await FirebaseFirestore
                                                            .instance
                                                            .collection(
                                                                'Attendance')
                                                            .doc(data[index]
                                                                ['id'])
                                                            .delete()
                                                            .then((value) =>
                                                                Navigator.of(
                                                                        context)
                                                                    .pop());
                                                      })
                                                ],
                                              ),
                                            );
                                          },
                                          icon: Icon(
                                            Icons.delete,
                                            color: Colors.red,
                                          ),
                                        ),
                                        if (data[index]['status'] == 'closed')
                                          Text(
                                            'Closed',
                                            style: TextStyle(
                                              color: Colors.red,
                                            ),
                                          )
                                      ],
                                    ),
                                  ),
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
