import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:purana_bazzar/firebase_helper/firebase_login.dart';
import 'package:purana_bazzar/firebase_helper/firebase_operations.dart';
import 'package:purana_bazzar/screens/home_screen.dart';
import 'package:purana_bazzar/screens/signup_screen.dart';
import 'package:purana_bazzar/utils/constants.dart';

import 'my_current_location_screen.dart';

class OtpScreen extends StatefulWidget {
  final String mobile;

  OtpScreen({this.mobile});

  @override
  _OtpScreenState createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  TextEditingController controller1 = TextEditingController();
  TextEditingController controller2 = TextEditingController();
  TextEditingController controller3 = TextEditingController();
  TextEditingController controller4 = TextEditingController();
  TextEditingController controller5 = TextEditingController();
  TextEditingController controller6 = TextEditingController();

  TextEditingController currController = TextEditingController();

  bool isFilled = false, isLoading = true, isCodeNotSent = true;
  String smsCode;
  String _message;
  FirebaseAuth _auth;
  String _verificationId;

  @override
  void dispose() {
    super.dispose();
    controller1.dispose();
    controller2.dispose();
    controller3.dispose();
    controller4.dispose();
    controller5.dispose();
    controller6.dispose();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    currController = controller1;
    _auth = FirebaseAuth.instance;
    _verifyPhoneNumber();
  }

  void _verifyPhoneNumber() async {
    setState(() {
      _message = '';
      isLoading = true;
    });
    final PhoneVerificationCompleted verificationCompleted =
        (AuthCredential phoneAuthCredential) {

      _signInWithPhoneNumber(credential: phoneAuthCredential);

    };

    final PhoneVerificationFailed verificationFailed =
        (authException) {
      setState(() {
        isLoading = false;
        _message =
        'Phone number verification failed. Code: ${authException.code}. Message: ${authException.message}';
      });
      Fluttertoast.showToast(msg: _message);
    };

    final PhoneCodeSent codeSent =
        (String verificationId, [int forceResendingToken]) async {
      Fluttertoast.showToast(msg: "OTP sent");
      setState(() {
        isLoading = false;
        isCodeNotSent = false;
      });
      _verificationId = verificationId;
    };

    final PhoneCodeAutoRetrievalTimeout codeAutoRetrievalTimeout =
        (String verificationId) {
      _verificationId = verificationId;
    };

    await _auth.verifyPhoneNumber(
        phoneNumber: "+91"+widget.mobile,
        timeout: const Duration(seconds: 5),
        verificationCompleted: verificationCompleted,
        verificationFailed: verificationFailed,
        codeSent: codeSent,
        codeAutoRetrievalTimeout: codeAutoRetrievalTimeout);
  }

  // Example code of how to sign in with phone.
  void _signInWithPhoneNumber({AuthCredential credential}) async {
    bool isOld = false;
    print(smsCode);
    setState(() {
      isLoading = true;
    });
    AuthCredential authCredential;
    if(smsCode == null){
      authCredential = credential;
    }else{
      authCredential = PhoneAuthProvider.credential(
        verificationId: _verificationId,
        smsCode: this.smsCode,
      );
    }

    Fluttertoast.showToast(msg: "Verification in progress...");
    try {
      UserCredential _results = await _auth.signInWithCredential(authCredential);
      User user = _results.user;

      setState(() {
        if (user != null) {
          _message = 'Successfully signed in';
          matchOtp();
        } else {
          FirebaseLogin().onAuthStateChanged(context);
          _message = 'Sign in failed';
        }
      });
      Fluttertoast.showToast(msg: _message);

    }on PlatformException catch(e){
      setState(() {
        isLoading = false;
      });
      print(e.message);
    }
  }


  @override
  Widget build(BuildContext context) {
    List<Widget> widgetList = [
      Padding(
        padding: EdgeInsets.only(left: 0.0, right: 2.0),
        child: Container(
          color: Colors.transparent,
        ),
      ),
      Padding(
        padding: const EdgeInsets.only(right: 2.0, left: 2.0),
        child: Container(
            alignment: Alignment.center,
            decoration: BoxDecoration(color: Color.fromRGBO(0, 0, 0, 0.1), border: Border.all(width: 1.0, color: Color.fromRGBO(0, 0, 0, 0.1)), borderRadius: BorderRadius.circular(4.0)),
            child: TextField(
              inputFormatters: [
                LengthLimitingTextInputFormatter(1),
              ],
              enabled: false,
              controller: controller1,
              autofocus: false,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 24.0, color: Colors.black),
            )),
      ),
      Padding(
        padding: const EdgeInsets.only(right: 2.0, left: 2.0),
        child: Container(
          alignment: Alignment.center,
          decoration: BoxDecoration(color: Color.fromRGBO(0, 0, 0, 0.1), border: Border.all(width: 1.0, color: Color.fromRGBO(0, 0, 0, 0.1)), borderRadius: BorderRadius.circular(4.0)),
          child: TextField(
            inputFormatters: [
              LengthLimitingTextInputFormatter(1),
            ],
            controller: controller2,
            autofocus: false,
            enabled: false,
            keyboardType: TextInputType.number,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 24.0, color: Colors.black),
          ),
        ),
      ),
      Padding(
        padding: const EdgeInsets.only(right: 2.0, left: 2.0),
        child: Container(
          alignment: Alignment.center,
          decoration: BoxDecoration(color: Color.fromRGBO(0, 0, 0, 0.1), border: Border.all(width: 1.0, color: Color.fromRGBO(0, 0, 0, 0.1)), borderRadius: BorderRadius.circular(4.0)),
          child: TextField(
            inputFormatters: [
              LengthLimitingTextInputFormatter(1),
            ],
            keyboardType: TextInputType.number,
            controller: controller3,
            textAlign: TextAlign.center,
            autofocus: false,
            enabled: false,
            style: TextStyle(fontSize: 24.0, color: Colors.black),
          ),
        ),
      ),
      Padding(
        padding: const EdgeInsets.only(right: 2.0, left: 2.0),
        child: Container(
          alignment: Alignment.center,
          decoration: BoxDecoration(color: Color.fromRGBO(0, 0, 0, 0.1), border: Border.all(width: 1.0, color: Color.fromRGBO(0, 0, 0, 0.1)), borderRadius: BorderRadius.circular(4.0)),
          child: TextField(
            inputFormatters: [
              LengthLimitingTextInputFormatter(1),
            ],
            textAlign: TextAlign.center,
            controller: controller4,
            autofocus: false,
            enabled: false,
            style: TextStyle(fontSize: 24.0, color: Colors.black),
          ),
        ),
      ),
      Padding(
        padding: const EdgeInsets.only(right: 2.0, left: 2.0),
        child: Container(
          alignment: Alignment.center,
          decoration: BoxDecoration(color: Color.fromRGBO(0, 0, 0, 0.1), border: Border.all(width: 1.0, color: Color.fromRGBO(0, 0, 0, 0.1)), borderRadius: BorderRadius.circular(4.0)),
          child: TextField(
            inputFormatters: [
              LengthLimitingTextInputFormatter(1),
            ],
            textAlign: TextAlign.center,
            controller: controller5,
            autofocus: false,
            enabled: false,
            style: TextStyle(fontSize: 24.0, color: Colors.black),
          ),
        ),
      ),
      Padding(
        padding: const EdgeInsets.only(right: 2.0, left: 2.0),
        child: Container(
          alignment: Alignment.center,
          decoration: BoxDecoration(color: Color.fromRGBO(0, 0, 0, 0.1), border: Border.all(width: 1.0, color: Color.fromRGBO(0, 0, 0, 0.1)), borderRadius: BorderRadius.circular(4.0)),
          child: TextField(
            inputFormatters: [
              LengthLimitingTextInputFormatter(1),
            ],
            textAlign: TextAlign.center,
            controller: controller6,
            autofocus: false,
            enabled: false,
            style: TextStyle(fontSize: 24.0, color: Colors.black),
          ),
        ),
      ),
      Padding(
        padding: EdgeInsets.only(left: 2.0, right: 0.0),
        child: Container(
          color: Colors.transparent,
        ),
      ),
    ];
    final size = MediaQuery.of(context).size;
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      backgroundColor: Color(0xFFffffff),
      body: Stack(
        overflow: Overflow.clip,
        children: [
          AnimatedPositioned(
            duration: Duration(milliseconds: 300),
            top: - size.height *0.25,
            left: - size.height *0.25,
            child: Container(
              height: size.height * 0.5,
              width: size.height *0.5,
              decoration: BoxDecoration(
                  color: mPrimaryColor,
                  borderRadius: BorderRadius.circular(size.height * 0.25)
              ),
            ),
          ),
          AnimatedPositioned(
            duration: Duration(milliseconds: 300),
            top: size.height *0.45,
            right: - size.height * 0.35,
            child: Container(
              height: size.height * 0.5,
              width: size.height *0.5,
              decoration: BoxDecoration(
                  color: mPrimaryColor,
                  borderRadius: BorderRadius.circular(size.height * 0.25)
              ),
            ),
          ),
          SafeArea(
            child: Container(
              padding: const EdgeInsets.only(top: 20),
              child: Column(
                children: <Widget>[
                  Flexible(
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: Text(
                            "Verifying your number!",
                            style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 16.0, top: 4.0, right: 16.0),
                          child: Text(
                            "Please type the verification code sent to",
                            style: TextStyle(fontSize: 15.0, fontWeight: FontWeight.normal),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 30.0, top: 2.0, right: 30.0),
                          child: Text(
                            "+91 ${widget.mobile}",
                            style: TextStyle(fontSize: 15.0, fontWeight: FontWeight.bold, color: Colors.red),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 16.0),
                          child: Image(
                            image: AssetImage('assets/png/otp_icon.png'),
                            height: 120.0,
                            width: 120.0,
                          ),
                        )
                      ],
                    ),
                    flex: 90,
                  ),
                  Flexible(
                    child: Column(mainAxisSize: MainAxisSize.max, mainAxisAlignment: MainAxisAlignment.start, children: <Widget>[
                      GridView.count(
                          crossAxisCount: 8,
                          mainAxisSpacing: 10.0,
                          shrinkWrap: true,
                          primary: false,
                          scrollDirection: Axis.vertical,
                          children: List<Container>.generate(8, (int index) => Container(child: widgetList[index]))),
                    ]),
                    flex: 20,
                  ),
                  Flexible(
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Container(
                          child: Padding(
                            padding: const EdgeInsets.only(left: 8.0, top: 16.0, right: 8.0, bottom: 0.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                MaterialButton(
                                  onPressed: () {
                                    inputTextToField("1");
                                  },
                                  child: Text("1", style: TextStyle(fontSize: 25.0, fontWeight: FontWeight.w400), textAlign: TextAlign.center),
                                ),
                                MaterialButton(
                                  onPressed: () {
                                    inputTextToField("2");
                                  },
                                  child: Text("2", style: TextStyle(fontSize: 25.0, fontWeight: FontWeight.w400), textAlign: TextAlign.center),
                                ),
                                MaterialButton(
                                  onPressed: () {
                                    inputTextToField("3");
                                  },
                                  child: Text("3", style: TextStyle(fontSize: 25.0, fontWeight: FontWeight.w400), textAlign: TextAlign.center),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Container(
                          child: Padding(
                            padding: const EdgeInsets.only(left: 8.0, top: 4.0, right: 8.0, bottom: 0.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                MaterialButton(
                                  onPressed: () {
                                    inputTextToField("4");
                                  },
                                  child: Text("4", style: TextStyle(fontSize: 25.0, fontWeight: FontWeight.w400), textAlign: TextAlign.center),
                                ),
                                MaterialButton(
                                  onPressed: () {
                                    inputTextToField("5");
                                  },
                                  child: Text("5", style: TextStyle(fontSize: 25.0, fontWeight: FontWeight.w400), textAlign: TextAlign.center),
                                ),
                                MaterialButton(
                                  onPressed: () {
                                    inputTextToField("6");
                                  },
                                  child: Text("6", style: TextStyle(fontSize: 25.0, fontWeight: FontWeight.w400), textAlign: TextAlign.center),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Container(
                          child: Padding(
                            padding: const EdgeInsets.only(left: 8.0, top: 4.0, right: 8.0, bottom: 0.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                MaterialButton(
                                  onPressed: () {
                                    inputTextToField("7");
                                  },
                                  child: Text("7", style: TextStyle(fontSize: 25.0, fontWeight: FontWeight.w400), textAlign: TextAlign.center),
                                ),
                                MaterialButton(
                                  onPressed: () {
                                    inputTextToField("8");
                                  },
                                  child: Text("8", style: TextStyle(fontSize: 25.0, fontWeight: FontWeight.w400), textAlign: TextAlign.center),
                                ),
                                MaterialButton(
                                  onPressed: () {
                                    inputTextToField("9");
                                  },
                                  child: Text("9", style: TextStyle(fontSize: 25.0, fontWeight: FontWeight.w400), textAlign: TextAlign.center),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Container(
                          child: Padding(
                            padding: const EdgeInsets.only(left: 8.0, top: 4.0, right: 8.0, bottom: 0.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                MaterialButton(
                                    onPressed: () {
                                      deleteText();
                                    },
                                    child: Image.asset('assets/png/delete.png', width: 25.0, height: 25.0)),
                                MaterialButton(
                                  onPressed: () {
                                    inputTextToField("0");
                                  },
                                  child: Text("0", style: TextStyle(fontSize: 25.0, fontWeight: FontWeight.w400), textAlign: TextAlign.center),
                                ),
                                MaterialButton(
                                    onPressed: () {
                                      if(isCodeNotSent){
                                        Fluttertoast.showToast(msg: "Please wait");
                                        return;
                                      }
                                      smsCode = "${controller1.text}${controller2.text}${controller3.text}${controller4.text}${controller5.text}${controller6.text}";
                                      setState(() {});
                                      _signInWithPhoneNumber();

                                    },
                                    child: Image.asset('assets/png/success.png', width: 25.0, height: 25.0)),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    flex: 90,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void inputTextToField(String str) {
    //Edit first textField
    if (currController == controller1) {
      controller1.text = str;
      currController = controller2;
    }

    //Edit second textField
    else if (currController == controller2) {
      controller2.text = str;
      currController = controller3;
    }

    //Edit third textField
    else if (currController == controller3) {
      controller3.text = str;
      currController = controller4;
    }

    //Edit fourth textField
    else if (currController == controller4) {
      controller4.text = str;
      currController = controller5;
    }

    //Edit fifth textField
    else if (currController == controller5) {
      controller5.text = str;
      currController = controller6;
    }

    //Edit sixth textField
    else if (currController == controller6) {
      controller6.text = str;
      currController = controller6;
    }
  }

  void deleteText() {
    if (currController.text.length == 0) {
    } else {
      currController.text = "";
      currController = controller5;
      return;
    }

    if (currController == controller1) {
      controller1.text = "";
    } else if (currController == controller2) {
      controller1.text = "";
      currController = controller1;
    } else if (currController == controller3) {
      controller2.text = "";
      currController = controller2;
    } else if (currController == controller4) {
      controller3.text = "";
      currController = controller3;
    } else if (currController == controller5) {
      controller4.text = "";
      currController = controller4;
    } else if (currController == controller6) {
      controller5.text = "";
      currController = controller5;
    }
  }

  void matchOtp() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Successfully"),
            content: Text("Otp matched successfully."),
            actions: <Widget>[
              IconButton(
                  icon: Icon(Icons.check),
                  onPressed: () {
                    Navigator.of(context).pop();
                    FirebaseLogin().onAuthStateChanged(context, firebaseUser: _auth.currentUser);
                  })
            ],
          );
        });
  }
}
