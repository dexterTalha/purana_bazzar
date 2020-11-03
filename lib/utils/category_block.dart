import 'package:flutter/material.dart';
import 'package:purana_bazzar/utils/constants.dart';

class CategoryBlock extends StatelessWidget {
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

            },
            title: Text("Testing"),
            leading: Icon(Icons.ac_unit),
          ),
          ListTile(
            onTap: () {},
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
