import 'package:flutter/material.dart';
import 'package:purana_bazzar/utils/constants.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin{
  AnimationController _animationController;
  Animation<double> _animation, _animationFade;
  Animation<Offset> _animationSlide;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(
        milliseconds: 300
      ),
    );
    _animation = _animationController.drive(Tween<double>(begin: 1.5, end: 1.0));
    _animationFade = _animationController.drive(Tween<double>(begin: 0.1, end: 1.0));
    _animationSlide = _animationController.drive(Tween<Offset>(begin: Offset(0, 0.5), end: Offset.zero));
    _animationController.forward();
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
