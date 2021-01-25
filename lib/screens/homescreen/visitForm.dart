import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:visitor_app/services/authservice.dart';
import 'package:visitor_app/shared/constants.dart';
import 'package:visitor_app/screens/authenticate/sign_in.dart';
import 'package:intl/intl.dart';
import 'package:visitor_app/screens/homescreen/homescreen.dart';

class VisitForm  extends StatefulWidget {
  final Function toggleView;
  VisitForm({this.toggleView});
  @override
  _VisitFormState createState() => _VisitFormState();
}

class _VisitFormState extends State<VisitForm> {
  TextStyle style = TextStyle(fontFamily: 'Montserrat', fontSize: 20.0);
  final AuthService _auth = AuthService();
  final formkey = GlobalKey<FormState>();
  TextEditingController email =new TextEditingController();
  TextEditingController name =new  TextEditingController();
  TextEditingController phoneNum =new  TextEditingController();
  TextEditingController childName =new  TextEditingController();
  TextEditingController visitReason =new  TextEditingController();
  String ApplyDate = new DateFormat.yMMMd().format(new DateTime.now());
  DateTime selectedDate = DateTime.now();
  String VisitDate = " ";


  _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
      context: context,
      initialDate: selectedDate, // Refer step 1
      firstDate: DateTime(2000),
      lastDate: DateTime(2025),
    );
    if (picked != null && picked != selectedDate)
      setState(() {
        selectedDate = picked;
      });
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      resizeToAvoidBottomPadding: false,
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/bg.jpg"),
            fit: BoxFit.cover,
          ),
        ),
        child: Container(
          child: Padding(
            padding: const EdgeInsets.all(36.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                SizedBox(
                  height: 150.0,
                  width: 150.0,
                  child: Image.asset(
                    "assets/lado.jpg",
                  ),
                ),
                SizedBox(height: 10.0),
                Form(
                  key: formkey,
                  child: Column(
                    children: [
                      TextFormField(
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Please enter your email';
                          }
                          else if (!value.contains("@")) {
                            return 'Please enter correct email format';
                          }
                          return null;
                        },
                        controller: email,
                        obscureText: false,
                        style: style,
                        decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.white,
                            contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                            hintText: " Enter your email",
                            border:
                            OutlineInputBorder(borderRadius: BorderRadius.circular(32.0))),
                      ),
                      SizedBox(height: 10.0),
                      TextFormField(
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Please enter name';
                          }
                          return null;
                        },
                        controller: name,
                        obscureText: false,
                        style: style,
                        decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.white,
                            contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                            hintText: "Enter a valid name",
                            border:
                            OutlineInputBorder(borderRadius: BorderRadius.circular(32.0))),
                      ),
                      SizedBox(height: 10.0),
                      TextFormField(
                        // ignore: deprecated_member_use
                        inputFormatters: [WhitelistingTextInputFormatter.digitsOnly],
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Please enter phone number';
                          }
                          else if (value.length < 9){
                            return 'Please enter a valid phone number';
                          }
                          return null;
                        },
                        controller: phoneNum,
                        obscureText: false,
                        style: style,
                        decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.white,
                            contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                            hintText: "Enter your phone number",
                            border:
                            OutlineInputBorder(borderRadius: BorderRadius.circular(32.0))),
                      ),


                      SizedBox(height: 10.0),
                      TextFormField(
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Please enter your child name';
                          }
                          return null;
                        },
                        controller: childName,
                        obscureText: false,
                        style: style,
                        decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.white,
                            contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                            hintText: "Enter a valid child name",
                            border:
                            OutlineInputBorder(borderRadius: BorderRadius.circular(32.0))),
                      ),

                      SizedBox(height: 10.0),
                      TextFormField(
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Please enter the reason for visiting';
                          }
                          return null;
                        },
                        controller: visitReason,
                        obscureText: false,
                        style: style,
                        decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.white,
                            contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                            hintText: "Enter a valid reason",
                            border:
                            OutlineInputBorder(borderRadius: BorderRadius.circular(32.0))),
                      ),
                      RaisedButton(
                        onPressed: () => _selectDate(context), // Refer step 3
                        child: Text(
                          'Select date',
                          style:
                          TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
                        ),
                        color: Colors.greenAccent,
                      ),
                    ],
                  ),

                ),


                SizedBox(height: 10.0),
                Material(
                  elevation: 2.0,
                  borderRadius: BorderRadius.circular(30.0),
                  color: Colors.deepPurple[200],
                  child: MaterialButton(
                    minWidth: MediaQuery.of(context).size.width*0.6,
                    padding: EdgeInsets.fromLTRB(5.0, 5.0, 5.0, 5.0),
                    onPressed: () async {
                      if (formkey.currentState.validate()) {
                        //register .. send data  to authservices
                        dynamic result = await _auth.visitForm(email.text,name.text,phoneNum.text,childName.text,visitReason.text,VisitDate = selectedDate.toString(),ApplyDate);
                        showDialog(
                          context: context,
                          barrierDismissible: false, // user must tap button!
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: Text('Submitted!'),
                              content: SingleChildScrollView(
                                child: ListBody(
                                  children: <Widget>[
                                    Text('Continue to login'),
                                  ],
                                ),
                              ),
                              actions: <Widget>[
                                TextButton(
                                  child: Text('OK'),
                                  onPressed: () async {
                                    dynamic result = await _auth.signOut();
                                    if (result == null) {
                                      int i = 1;
                                      print(i.toString());
                                      Navigator.pushAndRemoveUntil(
                                        context,
                                        MaterialPageRoute(
                                          builder: (BuildContext context) =>
                                              homescreen(),
                                        ),
                                            (route) => false,
                                      );
                                    }
                                  },
                                ),
                              ],
                            );
                          },
                        );
                        if (result == null) {
                          showDialog(
                            context: context,
                            barrierDismissible: false, // user must tap button!
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: Text('This account had already been used'),
                                content: SingleChildScrollView(
                                  child: ListBody(
                                    children: <Widget>[
                                      Text('Please use other email account'),
                                    ],
                                  ),
                                ),
                                actions: <Widget>[
                                  TextButton(
                                    child: Text('OK'),
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                  ),
                                ],
                              );
                            },
                          );
                        }
                      }
                    },
                    child: Text("Submit",textAlign: TextAlign.center, style: style.copyWith(color: Colors.white, fontWeight: FontWeight.bold)),
                  ),
                ),


// SizedBox(height: 10.0),
                // // Text("Already registered?"),
                // FlatButton(
                //   child: Text("Sign in here!", style: style),
                //   onPressed: () {
                //     Navigator.pop(context);
                //   },
                // ),
                // SizedBox(
                //   height: 10.0,
                // ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
