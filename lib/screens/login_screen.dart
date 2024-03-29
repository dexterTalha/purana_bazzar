import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import '../firebase_helper/firebase_login.dart';
import '../screens/home_screen.dart';
import '../screens/otp_screen.dart';
import '../screens/signup_screen.dart';
import 'package:url_launcher/url_launcher.dart';
import '../utils/slide_fade_transition.dart';
import '../utils/constants.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> with TickerProviderStateMixin{
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _mobileController = TextEditingController();
  AnimationController rotationController;
  bool isAuthenticating = false;
  _launchURL() async {
    const url = 'https://flutter.dev';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  void initState() {
    rotationController = AnimationController(duration: const Duration(milliseconds: 500), vsync: this)..addStatusListener((status) {
      if(status == AnimationStatus.completed){
        rotationController.repeat();
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    _mobileController.dispose();
    rotationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.transparent,
      body: Container(
        height: size.height,
        width: size.width,
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            SlideFadeTransition(
              padding: EdgeInsets.only(top: 100),
              duration: Duration(milliseconds: 400),
              child: Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(10)),
                child: FlutterLogo(
                  size: 60,
                ),
              ),
            ),
            SlideFadeTransition(
              padding: EdgeInsets.only(top: 30),
              duration: Duration(milliseconds: 500),
              child: Text(
                "Login or SignUp",
                style: splashTextStyle22.copyWith(color: Colors.white),
              ),
            ),
            SizedBox(
              height: size.width * 0.7 / 4.5,
            ),
            SlideFadeTransition(
              child: buildGoogleButton(size),
              duration: Duration(milliseconds: 600),
            ),
            SizedBox(
              height: 20,
            ),
            buildDivider(),
            SizedBox(
              height: 20,
            ),
            buildPhoneNumberAuth(size),
            Spacer(),
            SlideFadeTransition(
              duration: Duration(milliseconds: 1100),
              child: Padding(
                padding: const EdgeInsets.only(bottom: 20, left: 10, right: 10),
                child: RichText(
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: "By Logging in you will agree ",
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 18,
                        ),
                      ),
                      TextSpan(
                        text: "Terms & Condition",
                        recognizer: TapGestureRecognizer()
                          ..onTap = () async {
                            await _launchURL();
                          },
                        style: TextStyle(
                          color: Colors.red,
                          fontSize: 18,
                          decoration: TextDecoration.underline,
                        ),
                      )
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget buildGoogleButton(Size size) {

    return Padding(
      padding: const EdgeInsets.only(left: 20, right: 20),
      child: InkWell(
        onTap: isAuthenticating? null : () async{
          setState(() {
            isAuthenticating = true;
          });
          rotationController.forward();
          User isLogin = await FirebaseLogin().signInWithGoogle();
          setState(() {
            isAuthenticating = false;
          });
          rotationController.stop();
          rotationController.reset();
          if(isLogin != null){
            Fluttertoast.showToast(msg: "Success");
            FirebaseLogin().onAuthStateChanged(context, firebaseUser: isLogin);
          }else{
            Fluttertoast.showToast(msg: "Error");
          }

        },
        splashColor: mPrimaryColor,
        child: Card(
          elevation: 10,
          child: Container(
            height: 55,
            padding: const EdgeInsets.only(top: 8, bottom: 8),
            width: size.width,
            decoration: BoxDecoration(
              color: Colors.white,
            ),
            child: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.only(
                    left: isAuthenticating?0:15,
                  ),
                  child: RotationTransition(
                    turns: Tween(begin: 0.0, end: 1.0).animate(rotationController),
                    child: AnimatedContainer(
                      width: isAuthenticating? size.width *0.84:35,
                      duration: Duration(milliseconds: 800),
                      child: Image.asset(
                        'assets/png/google_icon.png',
                        height: 35,
                        width: 35,
                      ),
                    ),
                  ),
                ),
                Expanded(
                  //flex:isAuthenticating ? 0 : 1,
                  child: Text(
                    isAuthenticating ?"":"Continue with Google",
                    textAlign: TextAlign.center,
                    style: googleBtnTextStyle,
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildDivider() {
    return SlideFadeTransition(
      duration: Duration(milliseconds: 800),
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 20.0, right: 20),
            child: Row(
              mainAxisSize: MainAxisSize.max,
              children: [
                Expanded(
                  child: Divider(
                    thickness: 0.8,
                    color: Colors.white,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Text(
                    "OR",
                    style: TextStyle(
                      backgroundColor: Colors.transparent,
                      color: Colors.white,
                      fontSize: 14,
                    ),
                  ),
                ),
                Expanded(
                  child: Divider(
                    thickness: 0.8,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget buildPhoneNumberAuth(Size size) {
    return SlideFadeTransition(
      padding: const EdgeInsets.only(left: 20, right: 20),
      duration: Duration(milliseconds: 1000),
      child: Container(
        width: size.width,
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              Container(
                decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(4)),
                child: TextFormField(
                  keyboardType: TextInputType.number,
                  maxLength: 10,
                  buildCounter: (context, {currentLength: 0, isFocused: false, maxLength: 10}) {
                    return null;
                  },
                  style: TextStyle(color: Colors.black, fontSize: 18),
                  validator: (text) {
                    if (text.isEmpty) {
                      return 'Please enter mobile number';
                    }
                    if (text.length < 10) {
                      return 'Please enter valid mobile number';
                    }
                    return null;
                  },
                  controller: _mobileController,
                  decoration: InputDecoration(
                      errorStyle: TextStyle(backgroundColor: Colors.transparent),

                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(4)),
                      hintText: "Mobile Number",
                      prefixIcon: Icon(Icons.phone_iphone),
                      prefixText: "+91",
                      prefixStyle: TextStyle(color: Colors.black, fontSize: 18)),
                ),
              ),
              SizedBox(
                height: 15,
              ),
              InkWell(
                onTap: () {
                  //FirebaseLogin().signOut();
                  if (_formKey.currentState.validate()) {
                    Navigator.pushReplacement(
                      context,
                      CupertinoPageRoute(
                        builder: (_) => OtpScreen(
                          mobile: _mobileController.text.trim(),
                        ),
                      ),
                    );
                  }
                },
                splashColor: Colors.white,
                child: Container(
                  height: 50,
                  width: size.width,
                  decoration: BoxDecoration(
                    color: mPrimaryColor,
                  ),
                  child: Center(
                    child: Text(
                      "Send OTP",
                      textAlign: TextAlign.center,
                      style: googleBtnTextStyle.copyWith(color: Colors.white),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
