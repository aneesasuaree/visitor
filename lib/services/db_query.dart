import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:visitor_app/models/user.dart';

class DBQuery {
  final CollectionReference _users =
      FirebaseFirestore.instance.collection('USER');

  // Get User Info
  Future getAdminInfo(String id) async {
    try {
      final DocumentSnapshot snapshot = await _users.doc(id).get();

      return Users(
        uid: snapshot.get('id'),
        email: snapshot.get('email'),
        password: snapshot.get('password'),
        name: snapshot.get('name'),
        phoneNum: snapshot.get('phone_number'),
        role: snapshot.get('role'),
      );
    } catch (e) {
      print(e.toString());
    }
  }

  Future getAllUsers() async {
    try {
      QuerySnapshot _querysnapshot = await _users.where('role', isEqualTo: 'user').get();

      return _querysnapshot.docs.map((e) => Users(
        uid: e.get('id'),
        email: e.get('email'),
        password: e.get('password'),
        name: e.get('name'),
        phoneNum: e.get('phone_number'),
        role: e.get('role'),

      )).toList();

    } catch(e) {
      print(e.toString());
    }
  }
}
