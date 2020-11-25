
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/widgets.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../helper/shared_pref.dart';
import '../screens/home_screen.dart';
import '../screens/login_screen.dart';
import '../screens/my_current_location_screen.dart';
import '../screens/signup_screen.dart';
import '../screens/walkthrough_screen.dart';
import '../utils/fancy_background_app.dart';
import 'package:flutter/material.dart';

import 'firebase_operations.dart';

enum Status { Uninitialized, Authenticated, Authenticating, Unauthenticated }

class FirebaseLogin{
  FirebaseAuth _auth = FirebaseAuth.instance;
  User _user;
  Status _status = Status.Uninitialized;


  Future<User> signInWithGoogle() async {
    final GoogleSignIn googleSignIn = new GoogleSignIn();

    try {
      await googleSignIn.disconnect();
    } catch (e) {}
    final GoogleSignInAccount googleSignInAccount = await googleSignIn.signIn();
    if (googleSignInAccount == null) {
      Fluttertoast.showToast(msg: "Login denied");
      return null;
    }
    final GoogleSignInAuthentication googleSignInAuthentication = await googleSignInAccount.authentication;


    final AuthCredential credential = GoogleAuthProvider.credential(
      accessToken: googleSignInAuthentication.accessToken,
      idToken: googleSignInAuthentication.idToken,
    );

    final UserCredential authResult = await _auth.signInWithCredential(credential);
    final User user = authResult.user;

    if (user != null) {
      assert(!user.isAnonymous);
      assert(await user.getIdToken() != null);

      final User currentUser = _auth.currentUser;
      assert(user.uid == currentUser.uid);

      print('signInWithGoogle succeeded: $user');


      return user;
    }
    _status = Status.Unauthenticated;

    return null;
  }

  Status get status => _status;
  User get user => _user;



  Future signOut() async {
    _auth.signOut();
    _status = Status.Unauthenticated;
    return Future.delayed(Duration.zero);
  }

  Future<void> onAuthStateChanged(BuildContext context, {User firebaseUser}) async {

    if (firebaseUser == null) {
      bool isOld = await SharedPref().isOld();
      Navigator.pushAndRemoveUntil(context, CupertinoPageRoute(builder: (_) => isOld ? FancyBackgroundApp(child:LoginScreen()):WalkThroughScreen()), (b) => false);
    } else {
      _user = firebaseUser;
      _status = Status.Authenticated;
      bool isOld = await FirebaseCheck.checkOldUser(uid: user.uid);
      if(isOld){
        bool isLocation = await FirebaseCheck.checkLocation(uid: user.uid);
        if(!isLocation)
          Navigator.pushReplacement(context, CupertinoPageRoute(builder: (_)=> MyCurrentLocationScreen()));
        else
          Navigator.pushReplacement(context, CupertinoPageRoute(builder: (_)=> HomeScreen()));
      }else {

        Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (_)=> SignUpScreen(isGoogle: user.email!='',)), (b) => false);
      }
    }
    //notifyListeners();
  }
}