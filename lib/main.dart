import 'package:flutter/material.dart';
import 'package:visitor_app/models/user.dart';
import 'package:visitor_app/screens/Wrapper.dart';
import 'package:visitor_app/services/authservice.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';

import 'models/user.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(context) {
    return StreamProvider<Users>.value(
      value: AuthService().user,
      child:  MaterialApp(
        home: Wrapper() ,
    )

    );
  }
}
