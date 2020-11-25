import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../firebase_helper/firebase_login.dart';
import '../helper/dark_theme_provider.dart';
import '../helper/shared_pref.dart';
import '../screens/home_screen.dart';
import '../screens/login_screen.dart';
import '../screens/walkthrough_screen.dart';
import '../utils/fancy_background_app.dart';
import '../utils/constants.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin{
  AnimationController _animationController;
  Animation<double> _animation, _animationFade;
  Animation<Offset> _animationSlide;
  DarkThemeProvider themeChangeProvider = new DarkThemeProvider();
  User currentUser;

  void getCurrentAppTheme() async {
    themeChangeProvider.darkTheme =
    await themeChangeProvider.darkThemePreference.getTheme();
  }

  @override
  void initState() {
    super.initState();

    currentUser = FirebaseAuth.instance.currentUser;
    getCurrentAppTheme();
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(
        milliseconds: 400
      ),
    );
    _animation = _animationController.drive(Tween<double>(begin: 1.5, end: 1.0));
    _animationFade = _animationController.drive(Tween<double>(begin: 0.1, end: 1.0));
    _animationSlide = _animationController.drive(Tween<Offset>(begin: Offset(0, 0.5), end: Offset.zero));
    _animationController.forward();
    handlerTimer();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Future<void> handlerTimer() async{

    User user = FirebaseAuth.instance.currentUser;
    Timer(Duration(milliseconds: 1500), (){
      //Navigator.pushReplacement(context, MateialPageRoute(builder: (_) => isOld ? FancyBackgroundApp(child: currentUser == null ? LoginScreen() : HomeScreen(),):WalkThroughScreen()));
      FirebaseLogin().onAuthStateChanged(context, firebaseUser: user);
    });
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              mPrimaryColor, mPrimaryDarkColor
            ],
            begin: Alignment.bottomLeft,
            end: Alignment.topRight
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            children: [
              ScaleTransition(
                scale: _animation,
                child: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10)
                  ),
                  child: FlutterLogo(
                    size: 60,
                  ),
                ),
              ),
              SizedBox(height: 25,),
              SlideTransition(
                position: _animationSlide,
                child: FadeTransition(
                  opacity: _animationFade,
                  child: Text(
                    "Purana Bazzar",
                    style: splashTextStyle22.copyWith(color: Colors.white),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
