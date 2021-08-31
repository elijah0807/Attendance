import 'package:attendance_system/screens/lecturer/attendance.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class CreateAttendance extends StatefulWidget {
  @override
  _CreateAttendanceState createState() => _CreateAttendanceState();
}

class _CreateAttendanceState extends State<CreateAttendance> {
  bool isLoading = false;
  final _formKey = GlobalKey<FormState>();
  var courseCode;
  var courseTitle;
  var accessCode;
  var attendanceTitle;

  final user = FirebaseAuth.instance.currentUser;

  _submit() async {
    final id = DateTime.now().millisecondsSinceEpoch.toString();
    try {
      final isValid = _formKey.currentState!.validate();
      FocusScope.of(context).unfocus();
      if (isValid) {
        setState(() {
          isLoading = true;
        });

        await FirebaseFirestore.instance.collection('Attendance').doc(id).set({
          'lecturerId': user!.uid,
          'lecturerName': user!.displayName,
          'id': id,
          'date': Timestamp.now(),
          'courseTitle': courseTitle,
          'courseCode': courseCode,
          'attendanceTitle': attendanceTitle,
          'attendanceCode': accessCode,
          'status': 'open',
        }).then((value) {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (context) {
                return Attendance();
              },
            ),
          );
        });
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
    }
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
                    height: MediaQuery.of(context).size.height * 0.35,
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
                            'Create Attendance',
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
                          Form(
                            key: _formKey,
                            child: Column(
                              children: [
                                Card(
                                  elevation: 5,
                                  child: Container(
                                    margin:
                                        EdgeInsets.only(right: 10, left: 10),
                                    padding: EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: TextFormField(
                                      // controller: _emailController,
                                      onChanged: (value) {
                                        courseCode = value;
                                      },
                                      validator: (value) {
                                        if (value!.isEmpty) {
                                          return 'Field required';
                                        }
                                        return null;
                                      },
                                      keyboardType: TextInputType.text,
                                      textCapitalization:
                                          TextCapitalization.characters,
                                      decoration: InputDecoration(
                                        hintText: 'Course Code',
                                        hintStyle: TextStyle(
                                          fontSize: 14,
                                          color: Color(0xff2C3D57)
                                              .withOpacity(0.46),
                                        ),
                                        border: InputBorder.none,
                                        focusedBorder: InputBorder.none,
                                        enabledBorder: InputBorder.none,
                                        errorBorder: InputBorder.none,
                                        disabledBorder: InputBorder.none,
                                        contentPadding: EdgeInsets.all(10),
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 15,
                                ),
                                Card(
                                  elevation: 5,
                                  child: Container(
                                    margin:
                                        EdgeInsets.only(right: 10, left: 10),
                                    padding: EdgeInsets.all(10),
                                    // decoration: BoxDecoration(
                                    //   color: Colors.deepPurple,
                                    //   borderRadius: BorderRadius.circular(5),
                                    // ),
                                    child: TextFormField(
                                      // controller: _emailController,
                                      onChanged: (value) {
                                        courseTitle = value;
                                      },
                                      validator: (value) {
                                        if (value!.isEmpty) {
                                          return 'Field required';
                                        }
                                        return null;
                                      },
                                      keyboardType: TextInputType.text,
                                      textCapitalization:
                                          TextCapitalization.characters,
                                      decoration: InputDecoration(
                                        hintText: 'Course Title',
                                        hintStyle: TextStyle(
                                          fontSize: 14,
                                          color: Color(0xff2C3D57)
                                              .withOpacity(0.46),
                                        ),
                                        border: InputBorder.none,
                                        focusedBorder: InputBorder.none,
                                        enabledBorder: InputBorder.none,
                                        errorBorder: InputBorder.none,
                                        disabledBorder: InputBorder.none,
                                        contentPadding: EdgeInsets.all(10),
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 15,
                                ),
                                Card(
                                  elevation: 5,
                                  child: Container(
                                    margin:
                                        EdgeInsets.only(right: 10, left: 10),
                                    padding: EdgeInsets.all(10),
                                    // decoration: BoxDecoration(
                                    //   color: Colors.deepPurple,
                                    //   borderRadius: BorderRadius.circular(5),
                                    // ),
                                    child: TextFormField(
                                      // controller: _emailController,
                                      onChanged: (value) {
                                        attendanceTitle = value;
                                      },
                                      validator: (value) {
                                        if (value!.isEmpty) {
                                          return 'Field required';
                                        }
                                        return null;
                                      },
                                      keyboardType: TextInputType.text,
                                      textCapitalization:
                                          TextCapitalization.characters,
                                      decoration: InputDecoration(
                                        hintText:
                                            'Attendance Title (e.g Week 1)',
                                        hintStyle: TextStyle(
                                          fontSize: 14,
                                          color: Color(0xff2C3D57)
                                              .withOpacity(0.46),
                                        ),
                                        border: InputBorder.none,
                                        focusedBorder: InputBorder.none,
                                        enabledBorder: InputBorder.none,
                                        errorBorder: InputBorder.none,
                                        disabledBorder: InputBorder.none,
                                        contentPadding: EdgeInsets.all(10),
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 15,
                                ),
                                Card(
                                  elevation: 5,
                                  child: Container(
                                    margin:
                                        EdgeInsets.only(right: 10, left: 10),
                                    padding: EdgeInsets.all(10),
                                    // decoration: BoxDecoration(
                                    //   color: Colors.deepPurple,
                                    //   borderRadius: BorderRadius.circular(5),
                                    // ),
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

                                      decoration: InputDecoration(
                                        hintText: 'Attendance Password',
                                        hintStyle: TextStyle(
                                          fontSize: 14,
                                          color: Color(0xff2C3D57)
                                              .withOpacity(0.46),
                                        ),
                                        border: InputBorder.none,
                                        focusedBorder: InputBorder.none,
                                        enabledBorder: InputBorder.none,
                                        errorBorder: InputBorder.none,
                                        disabledBorder: InputBorder.none,
                                        contentPadding: EdgeInsets.all(10),
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(height: 40),
                                Container(
                                  padding: EdgeInsets.all(5),
                                  margin: EdgeInsets.only(right: 10, left: 10),
                                  width: MediaQuery.of(context).size.width,
                                  child: TextButton(
                                    onPressed: () {
                                      _submit();
                                    },
                                    child: Text(
                                      'Create Attendance',
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
