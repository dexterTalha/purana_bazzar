import 'package:flutter/material.dart';
import 'package:purana_bazzar/firebase_helper/firebase_login.dart';
import 'package:purana_bazzar/utils/constants.dart';

class ProfileFragment extends StatefulWidget {
  @override
  _ProfileFragmentState createState() => _ProfileFragmentState();
}

class _ProfileFragmentState extends State<ProfileFragment> {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Container(
      width: size.width,
      height: size.height,
      child: ListView(
        physics: NeverScrollableScrollPhysics(),
        children: [
          buildImage(size),
          SizedBox(height: 15),
          Center(
            child: Text(
              "Shoaib",
              style: googleBtnTextStyle,
            ),
          ),
          SizedBox(height: 3),
          Center(
            child: Text(
              "shoaib@gmail.com",
              style: googleBtnTextStyle.copyWith(fontSize: 14, fontWeight: FontWeight.normal),
            ),
          ),
          SizedBox(height: 3),
          Center(
            child: Text(
              "+91 9876543210",
              style: googleBtnTextStyle.copyWith(fontSize: 14, fontWeight: FontWeight.normal),
            ),
          ),
          SizedBox(height: 12),
          Padding(
            padding: const EdgeInsets.only(left: 8, right: 8),
            child: ListTile(
              isThreeLine: false,
              leading: Icon(
                Icons.mode_edit,
                size: 20,
              ),
              title: Text(
                "Edit Profile",
                style: googleBtnTextStyle,
              ),
              onTap: () {},
            ),
          ),
          Divider(
            thickness: 0.5,
            height: 1,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 8, right: 8),
            child: ListTile(
              leading: Icon(
                Icons.pin_drop,
                size: 20,
              ),
              title: Text(
                "Address",
                style: googleBtnTextStyle,
              ),
              onTap: () {},
            ),
          ),
          Divider(
            thickness: 0.5,
            height: 1,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 8, right: 8),
            child: ListTile(
              leading: Icon(
                Icons.work,
                size: 20,
              ),
              title: Text(
                "Usage",
                style: googleBtnTextStyle,
              ),
              onTap: () {},
            ),
          ),
          Divider(
            thickness: 0.5,
            height: 1,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 8, right: 8),
            child: ListTile(
              leading: Icon(
                Icons.share,
                size: 20,
              ),
              title: Text(
                "Share",
                style: googleBtnTextStyle,
              ),
              onTap: () {},
            ),
          ),
          Divider(
            thickness: 0.5,
            height: 1,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 8, right: 8),
            child: ListTile(
              leading: Icon(
                Icons.warning,
                size: 20,
              ),
              title: Text(
                "Privacy & Policy",
                style: googleBtnTextStyle,
              ),
              onTap: () {},
            ),
          ),
          Divider(
            thickness: 0.5,
            height: 1,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 8, right: 8),
            child: ListTile(
              leading: Icon(
                Icons.logout,
                size: 20,
                color: Colors.red,
              ),
              title: Text(
                "Logout",
                style: googleBtnTextStyle.copyWith(color: Colors.red),
              ),
              onTap: () async {
                await FirebaseLogin().signOut();
                FirebaseLogin().onAuthStateChanged(context);

              },
            ),
          ),
        ],
      ),
    );
  }

  Widget buildImage(Size size) {
    return Center(
      child: Container(
        margin: const EdgeInsets.only(top: 15),
        height: size.height * 0.15,
        width: size.height * 0.15,
        padding: const EdgeInsets.all(5),
        decoration: BoxDecoration(
          color: Colors.blue,
          borderRadius: BorderRadius.circular(size.height * 0.15 * 0.5),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(size.height * 0.15 * 0.5),
          child: Image.asset(
            'assets/png/no_message.png',
            fit: BoxFit.fill,
          ),
        ),
      ),
    );
  }
}
