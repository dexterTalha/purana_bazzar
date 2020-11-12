import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:purana_bazzar/screens/ad_post_screen.dart';
import 'package:purana_bazzar/utils/constants.dart';

class CategoryBlock extends StatelessWidget {

  final bool isPostAd;


  CategoryBlock({this.isPostAd = false});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        showChildCatDialog(context);
      },
      child: Container(
        height: 200,
        width: 180,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Expanded(
                  child: Image.asset(
                "assets/png/otp_icon.png",
                height: 80,
                width: 80,
                fit: BoxFit.contain,
              )),
              SizedBox(
                height: 4,
              ),
              Text(
                "Testing",
                style: TextStyle(fontSize: 14, color: Colors.black),
              ),
            ],
          ),
        ),
      ),
    );
  }

  showChildCatDialog(BuildContext context) {
    AlertDialog dialog = AlertDialog(
      elevation: 8,
      title: Text(
        "Testing",
        style: googleBtnTextStyle,
      ),
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            onTap: () {
              if(isPostAd){
                Navigator.pushReplacement(context,
                    CupertinoPageRoute<Null>(builder: (_) => AdPostScreen()));
              }
            },
            title: Text("Testing"),
            leading: Icon(Icons.ac_unit),
          ),
          ListTile(
            onTap: () {
              if(isPostAd){
                Navigator.pushReplacement(context,
                    CupertinoPageRoute<Null>(builder: (_) => AdPostScreen()));
              }
            },
            title: Text("Testing"),
            leading: Icon(Icons.ac_unit),
          )
        ],
      ),
    );
    showDialog(
      context: context,
      builder: (_) => StatefulBuilder(
        builder: (_, setState) => dialog,
      ),
    );
  }
}
