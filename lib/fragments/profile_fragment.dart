import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:purana_bazzar/firebase_helper/firebase_operations.dart';
import 'package:purana_bazzar/models/firebase_user_model.dart';
import '../firebase_helper/firebase_login.dart';
import '../utils/constants.dart';

class ProfileFragment extends StatefulWidget {
  @override
  _ProfileFragmentState createState() => _ProfileFragmentState();
}

class _ProfileFragmentState extends State<ProfileFragment> {

  final User user = FirebaseAuth.instance.currentUser;

  @override
  void initState() {
    super.initState();
    if(user == null){
      FirebaseLogin().onAuthStateChanged(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return FutureBuilder<FirebaseUserModel>(
      future: FirebaseCheck().getUserDetails(user.uid),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(mPrimaryDarkColor),
            ),
          );
        }
        if (!snapshot.hasData || snapshot.hasError) {
          return Center(
            child: Text("Error", style: googleBtnTextStyle,),
          );
        }

        return Container(
          width: size.width,
          height: size.height,
          child: ListView(
            physics: NeverScrollableScrollPhysics(),
            children: [
              buildImage(size, snapshot.data.image),
              SizedBox(height: 15),
              Center(
                child: Text(
                  snapshot.data.name,
                  style: googleBtnTextStyle,
                ),
              ),
              SizedBox(height: 3),
              Center(
                child: Text(
                  snapshot.data.email,
                  style: googleBtnTextStyle.copyWith(fontSize: 14, fontWeight: FontWeight.normal),
                ),
              ),
              SizedBox(height: 3),
              Center(
                child: Text(
                  "+91 ${snapshot.data.mobile}",
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
    );
  }

  Widget buildImage(Size size, String image) {
    bool isImage = image != 'default';
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
          child: isImage
              ? CachedNetworkImage(
                  imageUrl: image,
                  fit: BoxFit.fill,
                )
              : Image.asset(
                  'assets/png/user_image.png',
                  fit: BoxFit.fill,
                ),
        ),
      ),
    );
  }
}
