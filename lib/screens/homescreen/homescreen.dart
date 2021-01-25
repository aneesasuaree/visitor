import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:visitor_app/services/authservice.dart';
import 'package:visitor_app/models/user.dart';
import 'package:visitor_app/services/database.dart';
import 'package:firebase_auth/firebase_auth.dart';
//import 'package:visitor_app/screens/authenticate/sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:visitor_app/screens/homescreen/userProfile.dart';
import 'package:visitor_app/screens/homescreen/visitForm.dart';
//import 'package:visitor_app/screens/homescreen/viewProfile.dart';

class homescreen extends StatefulWidget {
  final appTitle = 'VISITOR';
  final String uid;

  homescreen({this.uid});

  @override
  _homescreen createState() => _homescreen();
}

class _homescreen extends State<homescreen> {
  final AuthService _auth = AuthService();
  final FirebaseAuth auth = FirebaseAuth.instance;
  User user;

  var name, phoneNum, email;

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
    CollectionReference users = FirebaseFirestore.instance.collection('USER');
    //to get size variable
    var size = MediaQuery
        .of(context)
        .size;

    // style
    var cardTextStyle =
    TextStyle(fontFamily: "Montserrat Regular", fontSize: 16);

    return StreamBuilder<Users>(
      stream: DatabaseService(uid: widget.uid).userData,
      builder: (context, snapshot) {
        Users user = snapshot.data;

        if(!snapshot.hasData) {
          return SpinKitCircle(
            color: Colors.deepOrange[200],
          );
        }
        return Scaffold(
            backgroundColor: Colors.lightBlueAccent[50],
            appBar: AppBar(
              title: Text('VISITOR'),
              backgroundColor: Colors.cyan[200],
              elevation: 0.0,
              actions: <Widget>[
                FlatButton.icon(
                  icon: Icon(Icons.logout),
                  label: Text('Signout'),
                  onPressed: () async {
                    await _auth.signOut();
                  },
                )
              ],
            ),
            body: Stack(
              children: <Widget>[
                Container(
                  height: size.height * 0.4,
                  // decoration: BoxDecoration(
                  //   image: DecorationImage(
                  //       alignment: Alignment.topCenter,
                  //        image: AssetImage('assets/bg2.jpg')),
                  // ),
                ),
                SafeArea(
                  child: Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Column(
                      //Gambar profile
                      children: <Widget>[
                        Container(
                          height: 64,
                          margin: EdgeInsets.only(bottom: 20),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              CircleAvatar(
                                  radius: 40,
                                  backgroundImage:
                                  AssetImage('assets/usericonB.png')),

                              SizedBox(height: MediaQuery.of(context).size.height * 0.05), //Gap gmbr dengan tulisan

                              Column(
                                //Text sebelah Gambar
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text("Name: "+"${user.name}"),
                                  Text("Email : "+"${user.email}"),
                                ],
                              ),
                            ],
                          ),
                        ),


                        Expanded(
                          //kotak2 grid menu
                          child: GridView.count(
                            mainAxisSpacing: 10,
                            crossAxisCount: 2,
                            crossAxisSpacing: 10,
                            primary: false,
                            children: <Widget>[
                            Card(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8)),
                                elevation: 10,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Image(image: AssetImage('assets/user.png' ) ,height: MediaQuery
                      .of(context)
                      .size
                      .height *
                      0.09),

                                    RaisedButton(
                                      child: Text(
                                        'Visiting Request Form',
                                        style: cardTextStyle, textAlign: TextAlign.center,
                                      ),
                                      onPressed: () {
                                         Navigator.push(context, MaterialPageRoute(builder: (context) => VisitForm(),),);
                                      },
                                    ),
                                  ],
                                ),
                              ),

                              Card(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8)),
                                elevation: 10,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Image(image: AssetImage('assets/user.png' ) ,height: MediaQuery
                      .of(context)
                      .size
                      .height *
                      0.09),

                                    RaisedButton(
                                      child: Text(
                                        'Update Profile',
                                        style: cardTextStyle,
                                      ),
                                      onPressed: () {
                                         Navigator.push(context, MaterialPageRoute(builder: (context) => UserProfile(uid: widget.uid, u: user,),),);
                                      },
                                    ),
                                  ],
                                ),
                              ),

                      //        Card(
                      //           shape: RoundedRectangleBorder(
                      //               borderRadius: BorderRadius.circular(8)),
                      //           elevation: 10,
                      //           child: Column(
                      //             mainAxisAlignment: MainAxisAlignment.center,
                      //             children: <Widget>[
                      //               Image(image: AssetImage('assets/user.png' ) ,height: MediaQuery
                      // .of(context)
                      // .size
                      // .height *
                      // 0.09),

                      //               RaisedButton(
                      //                 child: Text(
                      //                   'View Profile',
                      //                   style: cardTextStyle,
                      //                 ),
                      //                 onPressed: () {
                      //                    Navigator.push(context, MaterialPageRoute(builder: (context) => ViewProfile(uid: widget.uid, u: user,),),);
                      //                 },
                      //               ),
                      //             ],
                      //           ),
                      //         ),


                              // Card(
                              //   shape: RoundedRectangleBorder(
                              //       borderRadius: BorderRadius.circular(8)),
                              //   elevation: 10,
                              //   child: Column(
                              //     mainAxisAlignment: MainAxisAlignment.center,
                              //     children: <Widget>[
                              //       SvgPicture.asset( 'assets/user.svg',
                              //           height: MediaQuery
                              //               .of(context)
                              //               .size
                              //               .height *
                              //               0.09),
                              //       RaisedButton(
                              //         child: Text('Visitor History',
                              //             style: cardTextStyle),
                              //         onPressed: () {
                              //           // Navigator.push(context, MaterialPageRoute(builder: (context) => promo()));
                              //         },
                              //       ),
                              //     ],
                              //   ),
                              // ),

//                               Card(
//                                 shape: RoundedRectangleBorder(
//                                     borderRadius: BorderRadius.circular(8)),
//                                 elevation: 10,
//                                 child: Column(
//                                   mainAxisAlignment: MainAxisAlignment.center,
//                                   children: <Widget>[
//                                     SvgPicture.asset( 'assets/user.svg',
//                                         height: MediaQuery
//                                             .of(context)
//                                             .size
//                                             .height *
//                                             0.09),
//                                     RaisedButton(
//                                       child:
//                                       Text('Diagnose Plant', style: cardTextStyle),
//                                       onPressed: () {
// //                                  Navigator.push(context, MaterialPageRoute(builder: (context) => Diagnose()));
//                                       },
//                                     ),
//                                   ],
//                                 ),
//                               ),

                              // Card(
                              //   shape: RoundedRectangleBorder(
                              //     borderRadius: BorderRadius.circular(8)
                              //   ),
                              //   elevation: 10,
                              //   child: Column(
                              //     mainAxisAlignment: MainAxisAlignment.center,
                              //     children: <Widget>[
                              //       SvgPicture.network('https://www.flaticon.com/svg/static/icons/svg/2794/2794147.svg', height: MediaQuery.of(context).size.height*0.09),
                              //       RaisedButton(
                              //         child: Text('Tracking History', style: cardTextStyle),
                              //         onPressed: () {
                              //           Navigator.push(context, MaterialPageRoute(builder: (context) => Profile()));
                              //         },
                              //       ),
                              //     ],
                              //   ),
                              // ),

//                               Card(
//                                 shape: RoundedRectangleBorder(
//                                     borderRadius: BorderRadius.circular(8)),
//                                 elevation: 10,
//                                 child: Column(
//                                   mainAxisAlignment: MainAxisAlignment.center,
//                                   children: <Widget>[
//                                     SvgPicture.asset( 'assets/user.svg',
//                                         height: MediaQuery
//                                             .of(context)
//                                             .size
//                                             .height *
//                                             0.09),
//                                     RaisedButton(
//                                       child: Text('contact us', style: cardTextStyle),
//                                       onPressed: () {
// //                                  Navigator.push(context, MaterialPageRoute(builder: (context) => Contact()));
//                                       },
//                                     ),
//                                   ],
//                                 ),
//                               ),
// //
//                          Card(
//                            shape: RoundedRectangleBorder(
//                                borderRadius: BorderRadius.circular(8)),
//                            elevation: 10,
//                            child: Column(
//                              mainAxisAlignment: MainAxisAlignment.center,
//                              children: <Widget>[
//                                SvgPicture.network(
//                                    'https://www.flaticon.com/svg/static/icons/svg/813/813357.svg',
//                                    height: MediaQuery
//                                        .of(context)
//                                        .size
//                                        .height *
//                                        0.09),
//                                RaisedButton(
//                                  child: Text('Feedback', style: cardTextStyle),
//                                  onPressed: () {
////                                  Navigator.push(context, MaterialPageRoute(builder: (context) => Feedbackpage()));
//                                  },
//                                ),
//                              ],
//                            ),
//                          ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            )
        );
      }
    );
  }
  }
