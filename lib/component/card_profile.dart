import 'package:flutter/material.dart';

class CardProfile extends StatelessWidget {
  CardProfile({this.title, this.data, this.onPressed});

  final String title;
  final String data;
  final Function onPressed;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(1.0),
      child: ListTile(
        title: Text(title),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Text(data),
            IconButton(
              icon: Icon(Icons.keyboard_arrow_right),
              onPressed: onPressed,
            ),
          ],
        ),
      ),
    );
  }
}
