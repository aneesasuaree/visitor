import 'package:flutter/material.dart';
import 'package:visitor_app/models/user.dart';
import 'package:visitor_app/services/database.dart';
import 'package:visitor_app/screens/authenticate/register.dart';
import 'package:visitor_app/screens/homescreen/homescreen.dart';
import 'package:provider/provider.dart';
import '../models/user.dart';
import 'package:visitor_app/screens/authenticate/register.dart';
import 'authenticate/sign_in.dart';
import 'homescreen/List.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'homescreen/homeAdmin.dart';
import 'package:visitor_app/services/authservice.dart';

class Wrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<Users>(context);
    final AuthService _auth = AuthService();

    if (user == null) {
      return SignIn();
    }
    return FutureBuilder(
      future: DatabaseService().getUser(user.uid),
      builder: (context, snapshot) {
        Users getUser = snapshot.data;
        print(getUser.email);
        if (snapshot.hasError || !snapshot.hasData) {
          return Scaffold(
            body: Container(
                color: Colors.white,
                child: SpinKitFoldingCube(
                  color: Colors.deepOrange,
                ),
            ),
          );
        }
        //Return either the Login or HomeCustomer or HomeCourier
        if (getUser.role == 'user') {
          return homescreen(uid: user.uid);
        } else if (getUser.role == 'admin') {
          return homeAdmin(uid: user.uid);
        } else {
          return SignIn();
        }
      },
    );
  }
}
