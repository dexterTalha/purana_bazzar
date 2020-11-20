import 'package:flutter/material.dart';
import 'package:purana_bazzar/firebase_helper/firebase_login.dart';
import 'package:purana_bazzar/utils/constants.dart';

class HelperClass {
  static Future<bool> buildDiscardDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(
          "Discard",
          style: googleBtnTextStyle,
        ),
        content: Text(
          "Do you want to discard?",
          style: googleBtnTextStyle.copyWith(fontSize: 16),
        ),
        actions: [
          RaisedButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text("No", style: TextStyle(color: Colors.white),),
            color: mPrimaryColor,
          ),
          FlatButton(
            onPressed: () {
              Navigator.pop(context);
              FirebaseLogin().signOut();
              FirebaseLogin().onAuthStateChanged(context);
            },
            child: Text("Yes"),
          ),
        ],
      ),
    );
    return Future.value(true);
  }
}
