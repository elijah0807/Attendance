import 'dart:io';

import 'package:attendance_system/screens/lecturer/attendance.dart';
import 'package:attendance_system/screens/lecturer/lecturer_register.dart';
import 'package:attendance_system/screens/student/attendance.dart';
import 'package:attendance_system/screens/student/student_register.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  var _emailController = TextEditingController();
  var _passwordController = TextEditingController();
  var _useremail;
  var _userpassword;

  bool _isLoading = false;
  final _formKey = GlobalKey<FormState>();

  final _auth = FirebaseAuth.instance;

  _login(BuildContext ctx) async {
    try {
      final isValid = _formKey.currentState!.validate();
      FocusScope.of(context).unfocus();
      if (isValid) {
        setState(() {
          _isLoading = true;
        });

        UserCredential authResult = await _auth.signInWithEmailAndPassword(
            email: _emailController.text, password: _passwordController.text);
        await FirebaseFirestore.instance
            .doc('users/${authResult.user!.uid}')
            .get()
            .then((DocumentSnapshot docsnapshot) {
          if (docsnapshot.exists) {
            if (docsnapshot['type'] == 'student') {
              Navigator.of(context)
                  .pushReplacement(MaterialPageRoute(builder: (context) {
                return AttendanceStudent();
              }));
            }
            if (docsnapshot['type'] == 'lecturer') {
              Navigator.of(context)
                  .pushReplacement(MaterialPageRoute(builder: (context) {
                return Attendance();
              }));
            }
          } else {
            showDialog(
              context: context,
              builder: (context) => AlertDialog(
                title: Text('Error!'),
                content: Text('Account does not exist, Please sign up'),
                actions: [
                  TextButton(
                      child: Text('Close'),
                      onPressed: () {
                        Navigator.of(context).pop();
                      })
                ],
              ),
            );
            setState(() {
              _isLoading = false;
            });
          }
        });
        //     .then((value) {
        //   return Navigator.of(context).pushReplacement(
        //     MaterialPageRoute(
        //       builder: (ctx) {
        //         return LecturerDashboard();
        //       },
        //     ),
        //   );
        // });
      }
    } catch (err) {
      var message = 'An error occurred, pelase check your credentials!';

      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          content: Text(err.toString()),
          actions: [
            TextButton(
                child: Text('Ok'),
                onPressed: () {
                  Navigator.of(context).pop();
                })
          ],
        ),
      );
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          child: Column(
            children: [
              Container(
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
                      Align(
                        alignment: Alignment.centerLeft,
                        child: IconButton(
                          icon: Icon(
                            Icons.arrow_back,
                            color: Colors.white,
                          ),
                          onPressed: () => showDialog<bool>(
                            context: context,
                            builder: (c) => AlertDialog(
                              title: Text('Warning'),
                              content: Text('Are you sure you want to exit?'),
                              actions: [
                                TextButton(
                                    child: Text('Yes'),
                                    onPressed: () {
                                      Navigator.pop(c, true);
                                      Navigator.pop(context);
                                      exit(0);
                                    }),
                                TextButton(
                                  child: Text('No'),
                                  onPressed: () => Navigator.pop(c, false),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 60,
                      ),
                      Text(
                        'Login',
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
                child: Form(
                  key: _formKey,
                  child: Padding(
                    padding: const EdgeInsets.only(
                      left: 20.0,
                      right: 20,
                    ),
                    child: Column(
                      children: [
                        SizedBox(height: 80),
                        Container(
                          margin: EdgeInsets.only(
                            left: 10,
                            bottom: 10,
                          ),
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'Email Address',
                            style: TextStyle(
                              fontWeight: FontWeight.normal,
                              fontSize: 14,
                            ),
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(right: 10, left: 10),
                          padding: EdgeInsets.all(2),
                          decoration: BoxDecoration(
                            color: Colors.deepPurple.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: TextFormField(
                            controller: _emailController,
                            onSaved: (value) {
                              _useremail = value;
                            },
                            decoration: InputDecoration(
                                hintText: 'Email Address',
                                hintStyle: TextStyle(
                                  fontSize: 14,
                                  color: Color(0xff2C3D57).withOpacity(0.46),
                                ),
                                border: InputBorder.none,
                                focusedBorder: InputBorder.none,
                                enabledBorder: InputBorder.none,
                                errorBorder: InputBorder.none,
                                disabledBorder: InputBorder.none,
                                contentPadding: EdgeInsets.all(10)),
                          ),
                        ),
                        SizedBox(height: 40),
                        Container(
                          margin: EdgeInsets.only(
                            left: 10,
                            bottom: 10,
                          ),
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'Password',
                            style: TextStyle(
                              fontWeight: FontWeight.normal,
                              fontSize: 14,
                            ),
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(right: 10, left: 10),
                          padding: EdgeInsets.all(2),
                          decoration: BoxDecoration(
                            color: Colors.deepPurple.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: TextFormField(
                            controller: _passwordController,
                            onSaved: (value) {
                              _userpassword = value;
                            },
                            obscureText: true,
                            decoration: InputDecoration(
                                hintText: 'Password',
                                hintStyle: TextStyle(
                                  fontSize: 14,
                                  color: Color(0xff2C3D57).withOpacity(0.46),
                                ),
                                border: InputBorder.none,
                                focusedBorder: InputBorder.none,
                                enabledBorder: InputBorder.none,
                                errorBorder: InputBorder.none,
                                disabledBorder: InputBorder.none,
                                contentPadding: EdgeInsets.all(10)),
                          ),
                        ),
                        SizedBox(height: 40),
                        if (_isLoading) CircularProgressIndicator(),
                        if (!_isLoading)
                          Container(
                            padding: EdgeInsets.all(5),
                            margin: EdgeInsets.only(right: 10, left: 10),
                            width: MediaQuery.of(context).size.width,
                            child: TextButton(
                              onPressed: () {
                                _login(context);
                              },
                              child: Text(
                                'Login',
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
                        SizedBox(height: 20),
                        Container(
                          alignment: Alignment.center,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text('Don\'t have account'),
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (ctx) {
                                        return SignUpStudent();
                                      },
                                    ),
                                  );
                                },
                                child: Text('Student Sign up'),
                              ),
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (ctx) {
                                        return SignUpLecturer();
                                      },
                                    ),
                                  );
                                },
                                child: Text('Lecturer Sign up'),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
