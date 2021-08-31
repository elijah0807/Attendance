import 'package:attendance_system/screens/student/attendance.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AttendClass extends StatefulWidget {
  final String id;
  final String attendanceTitle;
  final String courseTitle;
  final String courseCode;
  final String attendanceCode;

  AttendClass(this.id, this.attendanceTitle, this.courseTitle, this.courseCode,
      this.attendanceCode);

  @override
  _AttendClassState createState() => _AttendClassState();
}

class _AttendClassState extends State<AttendClass> {
  bool isLoading = false;
  bool check = false;
  final _formKey = GlobalKey<FormState>();
  final user = FirebaseAuth.instance.currentUser;
  var accessCode;
  var regno;
  var lectureId;
  var count = 0;
  bool checkUserCount = false;

  _check() async {
    // Get lecturer id
    await FirebaseFirestore.instance
        .collection('Attendance')
        .doc(widget.id)
        .get()
        .then((value) {
      setState(() {
        lectureId = value['lecturerId'];
      });
      print(lectureId);
    });
    // Check if user attended
    await FirebaseFirestore.instance
        .collection('user_attendance')
        .doc(user!.uid)
        .collection('attendance')
        .doc(widget.id)
        .get()
        .then((value) {
      if (value.exists) {
        setState(() {
          check = true;
        });
      }
    });
    //  get user reg no
    await FirebaseFirestore.instance
        .collection('users')
        .doc(user!.uid)
        .get()
        .then((value) {
      setState(() {
        regno = value['regNo'];
      });
    });
// student attendance count
    await FirebaseFirestore.instance
        .collection('lecturers')
        .doc(lectureId)
        .collection('myStudents')
        .doc(user!.uid)
        .get()
        .then((value) {
      if (value.exists) {
        setState(() {
          checkUserCount = true;
          count = value['count'];
        });
      }
      print(count);
    });
  }

  _submit() async {
    // final id = DateTime.now().millisecondsSinceEpoch.toString();
    try {
      final isValid = _formKey.currentState!.validate();
      FocusScope.of(context).unfocus();
      if (isValid) {
        setState(() {
          isLoading = true;
        });
        await FirebaseFirestore.instance
            .collection('user_attendance')
            .doc(user!.uid)
            .collection('attendance')
            .doc(widget.id)
            .set({
          'studentId': user!.uid,
          'studentName': user!.displayName,
          // 'id': id,
          'date': Timestamp.now(),
          'regNo': regno,
        });

        await FirebaseFirestore.instance
            .collection('Attendance')
            .doc(widget.id)
            .collection('attendance')
            .doc(user!.uid)
            .set({
          'studentId': user!.uid,
          'studentName': user!.displayName,
          'regNo': regno,
          // 'id': id,
          'date': Timestamp.now(),
        });

        if (checkUserCount) {
          await FirebaseFirestore.instance
              .collection('lecturers')
              .doc(lectureId)
              .collection('myStudents')
              .doc(user!.uid)
              .update({
            'count': count + 1,
          });
        }
        if (!checkUserCount) {
          await FirebaseFirestore.instance
              .collection('lecturers')
              .doc(lectureId)
              .collection('myStudents')
              .doc(user!.uid)
              .set({
            'studentId': user!.uid,
            'studentName': user!.displayName,
            'regNo': regno,
            'count': 1,
          });
        }
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) {
              return AttendanceStudent();
            },
          ),
        );
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    _check();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : SingleChildScrollView(
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
                          SizedBox(
                            height: 100,
                          ),
                          Text(
                            'Attend ${widget.courseCode} Now'.toUpperCase(),
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
                      padding: const EdgeInsets.all(15.0),
                      child: Column(
                        children: [
                          Card(
                            elevation: 10,
                            child: Container(
                              padding: const EdgeInsets.all(15.0),
                              child: Column(
                                children: [
                                  Row(
                                    // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                    children: [
                                      Container(
                                        width: 150,
                                        child: Text(
                                          'Title: ',
                                          style: TextStyle(
                                            color: Colors.grey,
                                            fontSize: 24,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        width: 40,
                                      ),
                                      Container(
                                        // width: 100,
                                        child: Text(
                                          widget.attendanceTitle,
                                          style: TextStyle(
                                            color: Colors.grey,
                                            fontSize: 24,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                    children: [
                                      Container(
                                        width: 150,
                                        child: Text(
                                          'Course Title: ',
                                          style: TextStyle(
                                            color: Colors.grey,
                                            fontSize: 24,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        width: 40,
                                      ),
                                      Container(
                                        // width: 100,
                                        child: Text(
                                          widget.courseTitle,
                                          style: TextStyle(
                                            color: Colors.grey,
                                            fontSize: 24,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                    children: [
                                      Container(
                                        width: 150,
                                        child: Text(
                                          'Course Code: ',
                                          style: TextStyle(
                                            color: Colors.grey,
                                            fontSize: 24,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        width: 40,
                                      ),
                                      Container(
                                        // width: 100,
                                        child: Text(
                                          widget.courseCode,
                                          style: TextStyle(
                                            color: Colors.grey,
                                            fontSize: 24,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 70,
                          ),
                          if (check)
                            Center(
                              child: Container(
                                child: Column(
                                  children: [
                                    Icon(
                                      Icons.check_circle_outline,
                                      size: 100,
                                      color: Colors.green,
                                    ),
                                    SizedBox(
                                      height: 20,
                                    ),
                                    Text(
                                      'YOUR ATTENDANCE WAS MARKED',
                                      style: TextStyle(
                                        color: Colors.grey,
                                        fontSize: 24,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          if (!check)
                            Card(
                              elevation: 5,
                              child: Container(
                                margin: EdgeInsets.only(right: 10, left: 10),
                                padding: EdgeInsets.all(10),
                                // decoration: BoxDecoration(
                                //   color: Colors.deepPurple,
                                //   borderRadius: BorderRadius.circular(5),
                                // ),
                                child: Form(
                                  key: _formKey,
                                  child: TextFormField(
                                    // controller: _emailController,
                                    onChanged: (value) {
                                      accessCode = value;
                                    },
                                    validator: (value) {
                                      if (value!.isEmpty) {
                                        return 'Field required';
                                      }
                                      return null;
                                    },
                                    textAlign: TextAlign.center,
                                    decoration: InputDecoration(
                                      hintText: 'Attendance Password',
                                      hintStyle: TextStyle(
                                        fontSize: 14,
                                        color:
                                            Color(0xff2C3D57).withOpacity(0.46),
                                      ),
                                      // border: InputBorder.none,
                                      // focusedBorder: InputBorder.none,
                                      // enabledBorder: InputBorder.none,
                                      // errorBorder: InputBorder.none,
                                      // disabledBorder: InputBorder.none,
                                      contentPadding: EdgeInsets.all(10),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          SizedBox(height: 40),
                          if (!check)
                            Container(
                              padding: EdgeInsets.all(5),
                              margin: EdgeInsets.only(right: 10, left: 10),
                              width: MediaQuery.of(context).size.width,
                              child: TextButton(
                                onPressed: () {
                                  if (widget.attendanceCode == accessCode) {
                                    _submit();
                                  } else {
                                    showDialog(
                                      context: context,
                                      builder: (context) => AlertDialog(
                                        title: Text('Incorrect Password!!!'),
                                        content: Text(
                                            'Attendance Password is not correct'),
                                        actions: [
                                          TextButton(
                                              child: Text('Close'),
                                              onPressed: () {
                                                Navigator.of(context).pop();
                                              }),
                                        ],
                                      ),
                                    );
                                  }
                                },
                                child: Text(
                                  'Attend Now'.toUpperCase(),
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              decoration: BoxDecoration(
                                  color: Theme.of(context).primaryColor,
                                  borderRadius: BorderRadius.circular(10)),
                            ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
