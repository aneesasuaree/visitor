
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:visitor_app/component/card_profile.dart';
import 'package:visitor_app/screens/homescreen/edit_profile.dart';
import 'package:visitor_app/screens/homescreen/verify_pass_for_email.dart';
import 'package:visitor_app/services/database.dart';
import 'package:intl/intl.dart';
import 'package:visitor_app/models/user.dart';

class UserProfile extends StatefulWidget {
  UserProfile({this.uid, this.u});

  final String uid;
  final Users u;

  @override
  _UserProfileState createState() => _UserProfileState(u);
}

class _UserProfileState extends State<UserProfile> {
  Users _user;

  _UserProfileState(Users u) {
    this._user = u;
  }

  TextEditingController _email, _name, _phoneNum, _address, _city, _postcode, _state, _password, _gender, _role;

  DateTime now = DateTime.now();
  DateTime _date;
  final _dateFormat = DateFormat('dd-MM-yyyy');
  String _dateString = '';

  @override
  void initState() {
    super.initState();
    _name = TextEditingController(text: _user.name);
    _phoneNum = TextEditingController(text: _user.phoneNum);
    _email = TextEditingController(text: _user.email);
    _password = TextEditingController(text: _user.password);
    _role = TextEditingController(text: _user.role);
  }

  @override
  Widget build(BuildContext context) {
    void _showSettingsPanel(Widget widget) {
      showModalBottomSheet(
        context: context,
        builder: (context) {
          return Container(
            padding: EdgeInsets.symmetric(
              vertical: 20.0,
              horizontal: 60.0,
            ),
            height: 200.0,
            child: widget,
          );
        },
      );
    }

    Future<DateTime> _selectDate(BuildContext context) async {
      final DateTime picked = await showDatePicker(
        context: context,
        initialDate: now,
        firstDate: DateTime(1950),
        lastDate: DateTime(2025),
      );
      if (picked != null && picked != now) {
        now = picked;
      }

      return now;
    }

    return StreamBuilder<Users>(
      stream: DatabaseService(uid: widget.uid).userData,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          Users usersData = snapshot.data;
          return Scaffold(
            appBar: AppBar(
              title: Text('Update Profile'),
            ),
            body: SingleChildScrollView(
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.only(top: 30.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      //TODO: Add image
                      CircleAvatar(
                        radius: 40.0,
                      ),
                      SizedBox(
                        height: 40.0,
                      ),
                      Divider(
                        thickness: 15.0,
                        color: Colors.grey,
                      ),
                      Column(
                        children: <Widget>[
                          CardProfile(
                            title: 'Name',
                            data: usersData.name,
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => editProfile(
                                    uid: widget.uid,
                                    title: 'Edit Name',
                                    hintText: 'Enter a name',
                                    value: usersData.name,
                                    validate: 'Please enter a name',
                                    u: usersData,
                                  ),
                                ),
                              );
                            },
                          ),
                          CardProfile(
                            title: 'Phone Number',
                            data: usersData.phoneNum,
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => editProfile(
                                    uid: widget.uid,
                                    title: 'Edit Phone Number',
                                    hintText: 'Enter your phone number',
                                    value: usersData.phoneNum,
                                    validate: 'Please enter a phone number',
                                    u: usersData,
                                  ),
                                ),
                              );
                            },
                          ),
                          CardProfile(
                            title: 'Email',
                            data: usersData.email,
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => VerifyPasswordForEmail(
                                    uid: widget.uid,
                                    title: 'Verify Password',
                                    hintText: 'Current Password',
                                  ),
                                ),
                              );
                            },
                          ),


                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        } else {
          return SpinKitFoldingCube(
            color: Colors.cyan[200],
          );
        }
      },
    );
  }
}
