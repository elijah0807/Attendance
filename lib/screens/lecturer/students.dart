import 'package:attendance_system/screens/lecturer/view_student_record.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:sendgrid_mailer/sendgrid_mailer.dart' as sendgrid;
import 'package:attendance_system/utils/creditials.dart' as cr;

class Students extends StatefulWidget {
  @override
  _StudentsState createState() => _StudentsState();
}

class _StudentsState extends State<Students> {
  final user = FirebaseAuth.instance.currentUser;
  var studentList = [];
  var count;

  _getStudent() async {
    await FirebaseFirestore.instance
        .collection('Attendance')
        .where('lecturerId', isEqualTo: user!.uid)
        .get()
        .then((value) {
      setState(() {
        count = value.docs.length;
      });
    });

    await FirebaseFirestore.instance
        .collection('lecturers')
        .doc(user!.uid)
        .collection('myStudents')
        .get()
        .then((value) {
      value.docs.forEach((e) {
        studentList.add(
            '${e['studentName']} (${e['regNo']}) \t ${((e['count'] / count) * 100).ceil()}%');
      });
    });
    print(studentList);
  }

  @override
  void initState() {
    _getStudent();
    // TODO: implement initState
    super.initState();
  }

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
                    height: 20,
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () {
                        final mailer = sendgrid.Mailer(cr.sendgridapikey);
                        final toAddress = sendgrid.Address(
                          'aishalawalbala@gmail.com',
                          // 'drealelijah@gmail.com',
                        );
                        final fromAddress = sendgrid.Address(cr.sendgridEmail);
                        final content =
                            sendgrid.Content('text/plain', '$studentList');
                        final subject = 'Student Attendance';
                        final personalization =
                            sendgrid.Personalization([toAddress]);

                        final sendemail = sendgrid.Email(
                            [personalization], fromAddress, subject,
                            content: [content]);
                        mailer.send(sendemail).then((result) {
                          // ...
                          showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                    // title: Text('Attentions'),
                                    content: Text('Scores Sent'),
                                    actions: [
                                      TextButton(
                                          child: Text('Close'),
                                          onPressed: () async {
                                            Navigator.of(context).pop();
                                          }),
                                    ],
                                  ));
                          print('sent');
                        });
                      },
                      child: Text(
                        'Send To HOD'.toUpperCase(),
                        style: TextStyle(
                          color: Colors.white,
                          // fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 60,
                  ),
                  Text(
                    'My Students',
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
                      .collection('lecturers')
                      .doc(user!.uid)
                      .collection('myStudents')
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
                    // List student = data[0]['studentName'].toString();
                    // print(student);
                    return ListView.separated(
                      separatorBuilder: (context, int i) => Divider(),
                      itemCount: data.length,
                      itemBuilder: (context, int index) {
                        return InkWell(
                          onTap: () {
                            Navigator.of(context)
                                .push(MaterialPageRoute(builder: (content) {
                              return ViewStudentRecord(
                                  data[index]['studentId']);
                            }));
                          },
                          child: Card(
                            child: Container(
                              padding: EdgeInsets.all(10),
                              child: ListTile(
                                leading: CircleAvatar(
                                  child: Text(
                                    data[index]['studentName'][0]
                                        .toString()
                                        .toUpperCase(),
                                    style: TextStyle(
                                      letterSpacing: 2,
                                      fontSize: 14,
                                    ),
                                  ),
                                ),
                                title: Text(data[index]['studentName']),
                                subtitle: Text(data[index]['regNo']),
                                trailing: Container(
                                  width: 100,
                                  child: Text(data[index]['count'].toString()),
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
    );
  }
}
