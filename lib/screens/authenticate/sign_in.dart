import 'package:flutter/material.dart';
import 'package:visitor_app/services/authservice.dart';
import 'register.dart';
import 'package:visitor_app/screens/Wrapper.dart';
import 'package:visitor_app/models/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:visitor_app/screens/homescreen/homeAdmin.dart';

TextEditingController emailController = new TextEditingController();
TextEditingController pwdController = new TextEditingController();


class SignIn extends StatefulWidget {
  SignIn({this.uid, this.u,this.toggleView});

  final String uid;
  final Users u;
  final Function toggleView;

  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  TextStyle style = TextStyle(fontFamily: 'Montserrat', fontSize: 20.0);
  final AuthService _auth = AuthService();
  final formkey = GlobalKey<FormState>();
  TextEditingController email = new TextEditingController();
  TextEditingController pw = new TextEditingController();
  TextEditingController name = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    // String email="";
    //  String pw="";

    final registButton = Material(
      elevation: 2.0,
      borderRadius: BorderRadius.circular(30.0),
      color: Colors.deepPurple[200],
      child: MaterialButton(
        minWidth: MediaQuery.of(context).size.width * 0.6,
        padding: EdgeInsets.fromLTRB(5.0, 5.0, 5.0, 5.0),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => Register()),
          ); //signup screen
        },
        child: Text("Register",
            textAlign: TextAlign.center,
            style: style.copyWith(
                color: Colors.white, fontWeight: FontWeight.bold)),
      ),
    );

    return Scaffold(
      resizeToAvoidBottomPadding: false,
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/bg.jpg"),
            fit: BoxFit.fill,
          ),
        ),
        child: Container(
          child: Padding(
            padding: const EdgeInsets.all(25.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                //   width: 150,
                //   height: 150,
                //   child: Image.asset(
                //     "assets/lado.jpg",
                //     fit: BoxFit.cover,
                //   ),
                ),
                SizedBox(height: 25.0),
                Form(
                  key: formkey,
                  child: Column(
                    children: [
                      TextFormField(
                        controller: email,
                        obscureText: false,
                        style: style,
                        decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.white,
                            contentPadding:
                            EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                            hintText: "Email",
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(32.0))),
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Please enter email';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 25.0),
                      TextFormField(
                        controller: pw,
                        obscureText: true,
                        style: style,
                        decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.white,
                            contentPadding:
                            EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                            hintText: "Password",
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(32.0))),
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Please enter password';
                          }
                          return null;
                        },
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 25.0,
                ),
                Material(
                  elevation: 2.0,
                  borderRadius: BorderRadius.circular(30.0),
                  color: Colors.deepPurple[200],
                  child: MaterialButton(
                    minWidth: MediaQuery.of(context).size.width * 0.6,
                    padding: EdgeInsets.fromLTRB(5.0, 5.0, 5.0, 5.0),
                    onPressed: () async {
                      if (formkey.currentState.validate()) {
                        dynamic result = await _auth.signInUser(email.text, pw.text);
                        //print(result.uid);
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                            builder: (BuildContext context) => Wrapper(),
                          ),
                              (route) => false,
                        );
                        if (result == null) {
                          showDialog(
                            context: context,
                            barrierDismissible: false, // user must tap button!
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: Text('Invalid email/password'),
                                content: SingleChildScrollView(
                                  child: ListBody(
                                    children: <Widget>[
                                      Text('Email or password is not a match'),
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
                      // print("Email:" + email.text);
                      // print("password:" + pw.text);
                    },
                    child: Text("Sign in",
                        textAlign: TextAlign.center,
                        style: style.copyWith(
                            color: Colors.white, fontWeight: FontWeight.bold)),
                  ),
                ),
                SizedBox(
                  height: 15.0,
                ),
                registButton,
                SizedBox(
                  height: 15.0,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

////
//save() async {
//  SharedPreferences localStorage = await SharedPreferences.getInstance();
//  localStorage.setString('email', emailController.text.toString());
//  localStorage.setString('password', pwdController.text.toString());
//
//  final fb = FirebaseFirestore.instance.doc("USER");
//
//  fb.get().then((DocumentSnapshot snapshot){
//    Map<dynamic, dynamic> values = snapshot.data();
//    values.forEach((key,values) {
//      if( emailController.text.toString()==values["email"])
//      {
//        localStorage.setString('name', values["name"]);
//        localStorage.setString('phone Number', values["phone Number"]);
//      }
//    });
//  });
//}
