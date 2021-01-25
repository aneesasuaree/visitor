import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:visitor_app/models/user.dart';
import 'dart:convert';

import '../models/user.dart';

class DatabaseService {
  final String uid;

  DatabaseService({this.uid});

  final CollectionReference userCollection = FirebaseFirestore.instance.collection('USER');
  final CollectionReference visitorCollection = FirebaseFirestore.instance.collection('VISITOR');


// Register user info
  Future registerUser(String email, String password, String name,
      String phoneNum, String role) async {
    return await userCollection.doc(uid).set({
      'id': uid,
      'email': email,
      'password': password,
      'name': name,
      'phone_number': phoneNum,
      'role': "user",
    });
  }

// Get Customer using Future Data Type
  Future getUser(String id) async {
    final DocumentSnapshot snapshot = await userCollection.doc(id).get();
    
    print('User Id:' + id);

    return Users(
      uid: snapshot.get('id'),
      name: snapshot.get('name'),
      email: snapshot.get('email'),
      phoneNum: snapshot.get('phone_number'),
      password: snapshot.get('password'),
      role: snapshot.get('role'),
    );
  }
  //Checking Password
  Future checkPassword(String password) async {
    bool status = false;
    try {
      await userCollection.doc(uid).get().then((value) {
        var checkPassword = value.get('password');
        if (password == checkPassword) {
          status = true;
        } else {
          status = false;
        }
      });
      return status;
    } catch (e) {
      print(e.toString());
      return false;
    }
  }

//Visiting Form
Future visitForm(String email, String name,
      String phoneNum, String childName, String visitReason, 
      String dateVisit, String dateApply) async {
    return await visitorCollection.doc(uid).set({
      'id': uid,
      'email': email,
      'name': name,
      'phone_number': phoneNum,
      'childName': childName,
      'visitReason': visitReason,
      'dateVisit': dateVisit,
      'dateApply': dateApply,
    });
  }

//Update User Profile
  Future userInfo(String email, String password, String name, String phoneNum,
      String role) async {
    String pass;
    try {
      await userCollection.doc(uid).get().then((value) {
        pass = value.get('password');

        if (password == pass) {
          return userCollection.doc(uid).set({
            'id': uid,
            'name': name,
            'email': email,
            'phone_number': phoneNum,
            'password': password,
            'role': role,
          });
        } else {
          var bytes = utf8.encode(password);
          var passwordEncode = base64.encode(bytes);

          return userCollection.doc(uid).set({
            'id': uid,
            'name': name,
            'email': email,
            'phone_number': phoneNum,
            'password': passwordEncode,
            'role': role,
          });
        }
      });
    } catch (e) {
      print(e.toString());
    }
  }

  Users _usersDataFromSnapshot(DocumentSnapshot snapshot) {
    return Users(
      uid: uid,
      name: snapshot.get('name') ?? '',
      phoneNum: snapshot.get('phone_number') ?? '',
      email: snapshot.get('email') ?? '',
      password: snapshot.get('password') ?? '',
      role: snapshot.get('role') ?? '',
    );
  }

  Stream<Users> get userData {
    print(uid);
    return userCollection.doc(uid).snapshots().map(_usersDataFromSnapshot);
  }
}
