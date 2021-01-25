
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:visitor_app/component/rounded_button.dart';
import 'package:visitor_app/models/user.dart';
import 'package:visitor_app/services/database.dart';

import 'edit_profile.dart';

class VerifyPasswordForEmail extends StatefulWidget {
  VerifyPasswordForEmail({this.uid, this.title, this.hintText});

  final String uid, title, hintText;

  @override
  _VerifyPasswordForEmailState createState() => _VerifyPasswordForEmailState();
}

class _VerifyPasswordForEmailState extends State<VerifyPasswordForEmail> {
  final _formKey = GlobalKey<FormState>();

  String _currentPassword;

  String error = '';

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<Users>(
      stream: DatabaseService(uid: widget.uid).userData,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          Users usersData = snapshot.data;
          return Scaffold(
            appBar: AppBar(
              title: Text(widget.title),
            ),
            body: Form(
              key: _formKey,
              child: Column(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(
                      top: 20.0,
                      left: 15.0,
                    ),
                    child: Align(
                      alignment: Alignment.topLeft,
                      child: Text(
                        'Please verify your identify by entering your password.',
                        style: TextStyle(
                          fontSize: 15.0,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 15.0,
                  ),
                  Container(
                    margin: EdgeInsets.all(15.0),
                    child: TextFormField(
                      obscureText: true,
                      validator: (value) =>
                      value.length < 6 ? 'Password is too short' : null,
                      decoration: InputDecoration(
                        hintText: widget.hintText,
                        border: OutlineInputBorder(),
                      ),
                      onChanged: (value) {
                        _currentPassword = value;
                      },
                    ),
                  ),
                  //TODO: Make long rounded button
                  RoundedButton(
                    colour: Colors.blue,
                    title: 'Continue',
                    onPressed: () async {
                      if (_formKey.currentState.validate()) {
                        dynamic result = await DatabaseService(uid: widget.uid)
                            .checkPassword(_currentPassword);
                        print(result);
                        if (result == true) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => editProfile(
                                uid: widget.uid,
                                title: 'Edit Email',
                                hintText: 'Enter a email',
                                value: usersData.email,
                                validate: 'Please enter a email',
                                u: usersData,
                              ),
                            ),
                          );
                        } else if (result == false) {
                          setState(() {
                            error = 'Password is not match';
                          });
                        }
                      }
                    },
                  ),
                  Text(
                    error,
                    style: TextStyle(
                      color: Colors.red,
                      fontSize: 14.0,
                    ),
                  ),
                ],
              ),
            ),
          );
        } else {
          return SpinKitFoldingCube(
            color: Colors.deepOrange,
          );
        }
      },
    );
  }
}
