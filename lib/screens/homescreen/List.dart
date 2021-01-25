
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:visitor_app/models/user.dart';
import 'package:visitor_app/screens/authenticate/sign_in.dart';
import 'package:visitor_app/services/authservice.dart';
import 'package:visitor_app/services/database.dart';
import 'package:visitor_app/services/db_query.dart';
import 'package:provider/provider.dart';
import 'package:visitor_app/screens/homescreen/homeAdmin.dart';

import '../Wrapper.dart';


class listUsers extends StatefulWidget {
  final appTitle = 'List';
  final String uid;

  listUsers({this.uid});
  @override
  _Home createState() => _Home();
}

class _Home extends State<listUsers> {

  String role;
  String email;
  final FirebaseAuth auth = FirebaseAuth.instance;
  User user;
  User testuser = FirebaseAuth.instance.currentUser;
  final DBQuery _dbQuery = DBQuery();

  TextStyle style = TextStyle(fontFamily: 'Montserrat', fontSize: 20.0);
  final AuthService _auth = AuthService();
  // final FirebaseUser user = await _auth.currentUser();
  @override
  void initState() {
    super.initState();
    initUser();
  }

  initUser() async {
    user = await auth.currentUser;
    setState(() {});
    print(user.uid);
  }


  @override
  Widget build(BuildContext context) {

    final shome = Material(
      elevation: 5.0,
      borderRadius: BorderRadius.circular(20.0),
      color: Colors.cyan[600],
      child: MaterialButton(
        minWidth: MediaQuery.of(context).size.width,
        padding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
        onPressed: () async {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
              builder: (BuildContext context) => homeAdmin(),
            ),
                (route) => false,
          );
        },
        child: Text("Home",
            textAlign: TextAlign.center,
            style: style.copyWith(
                color: Colors.white, fontWeight: FontWeight.bold)),
      ),
    );

//
//    final btc = Material(
//      elevation: 5.0,
//      borderRadius: BorderRadius.circular(30.0),
//      color: Color(0xff01A0C7),
//      child: MaterialButton(
//        minWidth: MediaQuery.of(context).size.width,
//        padding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
//        onPressed: () async {
//          Navigator.pushAndRemoveUntil(
//            context,
//            MaterialPageRoute(
//              builder: (BuildContext context) => connect(),
//            ),
//                (route) => false,
//          );
//        },
//        child: Text("ArduinoConnect",
//            textAlign: TextAlign.center,
//            style: style.copyWith(
//                color: Colors.white, fontWeight: FontWeight.bold)),
//      ),
//    );

    final logout = Material(
      elevation: 5.0,
      borderRadius: BorderRadius.circular(20.0),
      color: Colors.cyan[600],
      child: MaterialButton(
        minWidth: MediaQuery.of(context).size.width * 0.3,
        padding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
        onPressed: () async {
          dynamic result = await _auth.signOut();
          if(result == null) {
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                builder: (BuildContext context) => SignIn(),
              ),
                  (route) => false,
            );
          }
        },
        child: Text("Sign out",
            textAlign: TextAlign.center,
            style: style.copyWith(
                color: Colors.white, fontWeight: FontWeight.bold)),
      ),
    );

    final request = Material(
      elevation: 5.0,
      borderRadius: BorderRadius.circular(20.0),
      color: Colors.cyan[600],
      child: MaterialButton(
        minWidth: MediaQuery.of(context).size.width * 0.3,
        padding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
        onPressed: () async {
        },
        child: Text("Request",
            textAlign: TextAlign.center,
            style: style.copyWith(
                color: Colors.white, fontWeight: FontWeight.bold)),
      ),
    );

//    fetchMech() {
//      return   Firestore.instance
//          .collection("MECH")
//          .snapshots();
//    }


    Size size = MediaQuery.of(context).size;

//    getData() async {
//      uid = (await FirebaseAuth.instance.currentUser).uid;
//      email = (await FirebaseAuth.instance.currentUser).email;
//      print(uid);
//      var document = await FirebaseFirestore.instance.collection('USER')
//          .doc(uid)
//          .get();
//      role = document.data()['role'].toString();
//      print(role);
//    }

    return Scaffold(
      resizeToAvoidBottomPadding: false,
      appBar: AppBar(
        title: Text("VISITOR DETAILS"),
        backgroundColor: Colors.cyan[200],
      ),
      body:Container(
        color: Colors.black12,
        child: Column(
          children: [
            SizedBox(height: 15.0),
            Center(child: Text('List of Visitor Details', textAlign: TextAlign.center,
                style: style)),
            // RaisedButton(
            //     child: Text("Logout"),
            //     onPressed: () async {
            //         getData();
            //     }
            // ),
            SizedBox(height: 20.0),
            Container(
              height: size.height * 0.8,
              child: FutureBuilder(
                future: _dbQuery.getAllUsers(),
                builder:  (context, snapshot) {
                  List<Users> _user = snapshot.data;
                  if (!snapshot.hasData) {
                    return new Container(
                      child: Text(" No data"),
                    );
                  } else {
                    return ListView.builder(
                        itemCount: _user.length,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.all(5.0),
                            child: Container(
                              decoration: BoxDecoration(
                                  color: Colors.white
                              ),
                              width: size.width*1,
                              height: size.height*0.2,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Card(
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(20), // if you need this
                                        side: BorderSide(
                                          color: Colors.grey.withOpacity(0.2),
                                          width: 1,
                                        ),
                                      ),
                                      child: Container(
                                          color: Colors.white,
                                          width: 350,
                                          height: 70,
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.center, 
                                            children: [
                                              Row(
                                                children: [
                                                  Text("Name: "),
                                                  Text(_user[index].name),
                                                ],
                                              ),
                                              Row(
                                                children: [
                                                  Text("Email: "),
                                                  Text(_user[index].email),
                                                ],
                                              ),
                                              Row(
                                                children: [
                                                  Text("Phone Number: "),
                                                  Text(_user[index].phoneNum),
                                                  // IconButton(
                                                  //   icon: Icon(Icons.auto_awesome_motion),
                                                  //   onPressed: (){
                                                  //     // Navigator.push(
                                                  //     //   context,
                                                  //     //   MaterialPageRoute(
                                                  //     //       builder: (context) =>
                                                  //     //           StudentEdit(snapshot
                                                  //     //               .data.documents[i])),
                                                  //     // );
                                                  //   },
                                                  // )
                                                ],
                                              ),

                                            ],
                                          )
                                      ),
                                    ),

                                    // Row(
                                    //   children: [
                                    //     IconButton(
                                    //         icon: Icon(Icons.edit),
                                    //         onPressed: () {
                                    //           Navigator.push(
                                    //             context,
                                    //             MaterialPageRoute(
                                    //                 builder: (context) =>
                                    //                     StudentUpdate(snapshot
                                    //                         .data.docs[i])),
                                    //           );
                                    //         }),
                                    //     IconButton(
                                    //       icon: Icon(Icons.delete),
                                    //       onPressed: (){
                                    //         deleteStudent(i);
                                    //       },
                                    //     )                                      ],
                                    // ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        });
                  }
                },
              ),
            )
          ],
        ),
      ),
      drawer: Theme(
        data: Theme.of(context).copyWith(
          canvasColor: Colors
              .cyan[50], //This will change the drawer background to blue.
          //other styles
        ),
        child: Drawer(
          // Add a ListView to the drawer. This ensures the user can scroll
          // through the options in the drawer if there isn't enough vertical
          // space to fit everything.
          child: ListView(
            // Important: Remove any padding from the ListView.
            padding: EdgeInsets.zero,
            children: <Widget>[
              UserAccountsDrawerHeader(
                decoration: BoxDecoration(
                  color: Colors.cyan[600],
                ),
                currentAccountPicture: CircleAvatar(
                  backgroundColor: Colors.cyan[100],
                  child: Image.asset("assets/user.png", fit: BoxFit.fitHeight,),
                ),
                accountName: null,
                accountEmail: Text("Email : "+"${user?.email}"),
              ),
              // DrawerHeader(
              //   decoration: BoxDecoration(
              //       color: Colors.purple,
              //       image: DecorationImage(
              //           image: AssetImage("assets/logo.png"),
              //           fit: BoxFit.cover)
              //   ),
              //
              // ),
              ListTile(
                title: shome,
                onTap: () {
                  // Update the state of the app
                  // ...
                  // Then close the drawer
                  Navigator.pop(context);
                },
                // ...
                // Then close the drawer
              ),

//              ListTile(
//                title: btc,
//                onTap: () {
//                  // Update the state of the app
//                  // ...
//                  // Then close the drawer
//                },
//              ),
              ListTile(
                title: request,
                onTap: () {
                  // Update the state of the app
                  // ...
                  // Then close the drawer
                },
              ),
              ListTile(

                title: logout,
                onTap: () {
                  // Update the state of the app
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
