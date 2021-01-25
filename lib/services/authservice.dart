import 'dart:wasm';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:visitor_app/models/user.dart';
import 'package:visitor_app/services/database.dart';

class AuthService{

  final FirebaseAuth _auth = FirebaseAuth.instance;
  String email = "";
  String userId = "";
  String role = "";
  String name = "";
  String phoneNum = "";

  Users _userFromFirebase(User user){
    return user != null ? Users(uid: user.uid) : null ;
  }

  Stream<Users> get user {
    return _auth.authStateChanges()
        .map(_userFromFirebase);
  }

  Future<String> getCurrentUID() async {
    return  _auth.currentUser.uid;
  }


  Future regUser(String email, String password, String name,
      String phoneNumber) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      result.user.updateProfile(displayName: name);
      User user = result.user;
      await DatabaseService(uid: user.uid).registerUser(email,password,name, phoneNumber, role);
      return _userFromFirebase(user);
    } catch (e) {
      print(e.toString());
      return null;
    }
  }
  Future signInUser(String email, String password) async{
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(email: email, password: password);
      User user = result.user;
      return _userFromFirebase(user);
    } catch(e){
      print(e.toString());
      return null;
    }
  }

  Future visitForm(String email, String name,
      String phoneNum, String childName, String visitReason, 
      String dateVisit, String dateApply) async {
    try {
      userId = (await _auth.currentUser.uid);
      await DatabaseService(uid: userId).visitForm(email, name, 
      phoneNum, childName, visitReason, dateVisit, dateApply);
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  Future updateUserData(
      String email,
      String password,
      String name,
      String phoneNum,
      String role)  async {
    bool status = true;
    try {
      User user = _auth.currentUser;
      await user.updateEmail(email);

      await DatabaseService(uid: user.uid).userInfo(
          _auth.currentUser.email,
          password,
          name,
          phoneNum,
          role);
      return status;
    } catch(e){
      print(e.toString());
    }
  }


  Future signOut() async {
    try {
      return await _auth.signOut();
    } catch(e){
      print(e.toString());
      return null ;
    }
  }


Future getData() async {
  userId = (await FirebaseAuth.instance.currentUser).uid;
  email = (await FirebaseAuth.instance.currentUser).email;
  // print(userid);
  // print(email);
  var document = await FirebaseFirestore.instance.collection('USER')
      .doc(userId)
      .get();
  role = document.data().toString();
  return email;
}


// Change Customer's Email
  Future changeEmail(
      String email,
      String password,
      String name,
      String phoneNum,
      String role) async {
    bool status = true;
    try {
      User user = _auth.currentUser;
      await user.updateEmail(email);

      await DatabaseService(uid: user.uid).userInfo(
          _auth.currentUser.email,
          password,
          name,
          phoneNum,
          role);
      return status;
    }
    catch (e) {
      print(e.toString());
    }
  }
}




/*
class AuthService{
  final FirebaseAuth _firebaseAuth;

  AuthService(this._firebaseAuth);

  Stream<User> get authStateChanges => _firebaseAuth.onAuthStateChanged();

  Future<void> signOut() async{
    await _firebaseAuth.signOut();
  }

  Future<String> signIn({String email, String password}) async{
    try{
      await _firebaseAuth.signInWithEmailAndPassword(email: email, password: password);
      return "Signed In";
    }
    on FirebaseAuthException catch(e){return e.message;}
  }

  Future<String> signUp({String email, String password}) async {
    try{
      await _firebaseAuth.createUserWithEmailAndPassword(email: email, password: password);
      return "Signed Up ";
    }
    on FirebaseAuthException catch(e){return e.message;}
}
}
*/