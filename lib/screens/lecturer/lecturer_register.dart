import 'package:attendance_system/screens/login.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SignUpLecturer extends StatefulWidget {
  @override
  _SignUpLecturerState createState() => _SignUpLecturerState();
}

class _SignUpLecturerState extends State<SignUpLecturer> {
  var _firstnameController = TextEditingController();

  var _emailController = TextEditingController();
  var _passwordController = TextEditingController();
  var _lastnameController = TextEditingController();
  var _userpassword, _firstname, _useremail, _lastname;

  bool _isLoading = false;
  final _formKey = GlobalKey<FormState>();

  final _auth = FirebaseAuth.instance;

  _register(BuildContext ctx) async {
    try {
      final isValid = _formKey.currentState!.validate();
      FocusScope.of(context).unfocus();
      if (isValid) {
        setState(() {
          _isLoading = true;
        });
        var authResult = await _auth.createUserWithEmailAndPassword(
            email: _emailController.text, password: _passwordController.text);
        var displayName =
            '${_firstnameController.text} ${_lastnameController.text}';
        await authResult.user!.updateDisplayName(displayName);
        await FirebaseFirestore.instance
            .collection('users')
            .doc(authResult.user!.uid)
            .set({
          'type': 'lecturer',
          'firstname': _firstnameController.text,
          'lastname': _lastnameController.text,
          'email': _emailController.text,
          'displayname': displayName,
          'id': authResult.user!.uid,
        }).then((value) {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (ctx) {
                return LoginScreen();
              },
            ),
          );
        });
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
              ));
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sign up'),
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.only(
              left: 20.0,
              right: 20,
            ),
            child: Column(
              children: [
                SizedBox(height: 60),
                Container(
                  margin: EdgeInsets.only(
                    left: 10,
                    bottom: 10,
                  ),
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'First Name',
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
                    controller: _firstnameController,
                    onSaved: (value) {
                      _firstname = value;
                    },
                    validator: (val) {
                      if (val!.isEmpty) {
                        return 'Field Required';
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                        hintText: 'Enter First Name',
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
                SizedBox(height: 20),
                Container(
                  margin: EdgeInsets.only(
                    left: 10,
                    bottom: 10,
                  ),
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Last Name',
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
                    controller: _lastnameController,
                    onSaved: (value) {
                      _lastname = value;
                    },
                    validator: (val) {
                      if (val!.isEmpty) {
                        return 'Field Required';
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                        hintText: 'Enter Last Name',
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
                SizedBox(height: 20),
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
                    validator: (val) {
                      if (val!.isEmpty) {
                        return 'Field Required';
                      }
                      return null;
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
                SizedBox(height: 20),
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
                    validator: (val) {
                      if (val!.isEmpty) {
                        return 'Field Required';
                      }
                      return null;
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
                Container(
                  padding: EdgeInsets.all(5),
                  margin: EdgeInsets.only(right: 10, left: 10),
                  width: MediaQuery.of(context).size.width,
                  child: _isLoading
                      ? CircularProgressIndicator()
                      : TextButton(
                          onPressed: () {
                            _register(context);
                          },
                          child: Text(
                            'Register',
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
                      Text('Already have account'),
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (ctx) {
                                return LoginScreen();
                              },
                            ),
                          );
                        },
                        child: Text('Sign in'),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
