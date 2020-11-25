import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import '../firebase_helper/firebase_operations.dart';
import '../helper/helper.dart';
import '../screens/login_screen.dart';
import '../screens/my_current_location_screen.dart';
import '../utils/constants.dart';

class SignUpScreen extends StatefulWidget {

  final bool isGoogle;

  SignUpScreen({this.isGoogle = false});

  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> with SingleTickerProviderStateMixin{

  File _selectedImage;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  AnimationController _animationController;
  Animation<double> _animation;
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _mobileController = TextEditingController();
  String mobile;
  String name, email, uid;
  FirebaseAuth _auth;
  User user;
  bool isLoading = false;

  @override
  void dispose() {
    _animationController.dispose();
    _mobileController.dispose();
    _emailController.dispose();
    _nameController.dispose();
    super.dispose();
  }

  @override
  initState(){
    super.initState();
    _auth = FirebaseAuth.instance;
    user = _auth.currentUser;
    _animationController = AnimationController(
      duration: Duration(milliseconds: 1200), vsync: this
    );
    _animation = Tween<double>(begin: 1.1, end: 1.0).animate(_animationController)..addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _animationController.reverse();
      }
      else if (status == AnimationStatus.dismissed) {
        _animationController.forward();
      }
    });
    _animationController.forward();
    if(user == null){
      Fluttertoast.showToast(msg: "Error! Please login again");
      Navigator.pushReplacement(context, CupertinoPageRoute(builder: (_)=>LoginScreen()));
    }else {
      uid = user.uid;
      if (widget.isGoogle && user.email != null) {
        email = user.email;

        name = user.displayName;
        _emailController.value = TextEditingValue(text: email);
        _nameController.value = TextEditingValue(text: name);
        setState(() {});
      }else{
        mobile = user.phoneNumber.substring(3);
        _mobileController.value = TextEditingValue(text: mobile);
        setState(() {});
      }
    }

  }

  Future<void> getImage(ImageSource source) async {
    var image = await ImagePicker().getImage(source: source);
    setState(() {
      _selectedImage = File(image.path);
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return WillPopScope(
      onWillPop: ()=> HelperClass.buildDiscardDialog(context),
      child: Scaffold(
        resizeToAvoidBottomPadding: false,
        backgroundColor: Colors.white,
        body: Container(
          width: size.width,
          height: size.height,
          child: Stack(
            overflow: Overflow.clip,
            children: [
              Positioned(
                top: -size.width * 0.40,
                left: -size.width * 0.40,
                child: ScaleTransition(
                  scale: _animation,
                  child: Container(
                    height: size.width * 0.8,
                    width: size.width * 0.8,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(size.width * 0.5),
                      gradient: RadialGradient(
                        colors: [
                          mPrimaryDarkColor.withOpacity(0.8),
                          mPrimaryDarkColor.withOpacity(0.6),
                          mPrimaryColor.withOpacity(0.8),
                          mPrimaryColor.withOpacity(0.6),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              Positioned(
                top: 100,
                right: 20,
                child: ScaleTransition(
                  scale: _animation,
                  child: Container(
                    height: 50,
                    width: 50,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(size.width * 0.5),
                      gradient: RadialGradient(
                        colors: [
                          mPrimaryDarkColor.withOpacity(0.8),
                          mPrimaryColor.withOpacity(0.6),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              Positioned(
                bottom: 100,
                left: 20,
                child: ScaleTransition(
                  scale: _animation,
                  child: Container(
                    height: 50,
                    width: 50,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(size.width * 0.5),
                      gradient: RadialGradient(
                        colors: [
                          mPrimaryDarkColor.withOpacity(0.8),
                          mPrimaryColor.withOpacity(0.6),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              Positioned(
                bottom: -size.width * 0.40,
                right: -size.width * 0.40,
                child:  ScaleTransition(
                  scale: _animation,
                  child: Container(
                    height: size.width * 0.8,
                    width: size.width * 0.8,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(size.width * 0.5),
                      gradient: RadialGradient(
                        colors: [
                          mPrimaryDarkColor.withOpacity(0.8),
                          mPrimaryDarkColor.withOpacity(0.6),
                          mPrimaryColor.withOpacity(0.8),
                          mPrimaryColor.withOpacity(0.6),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              Form(
                key: _formKey,
                child: SafeArea(
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          height: AppBar().preferredSize.height,
                          child: IconButton(
                            icon: Icon(Icons.close),
                            color: Colors.white,
                            onPressed: () async{
                              await HelperClass.buildDiscardDialog(context);
                            },
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 10),
                          child: Center(
                            child: Text(
                              "Registration",
                              style: googleBtnTextStyle.copyWith(fontSize: 20),
                            ),
                          ),
                        ),
                        Center(
                          child: Container(
                            margin: const EdgeInsets.only(top: 15),
                            height: size.height * 0.15,
                            width: size.height * 0.15,
                            padding: const EdgeInsets.all(3),
                            decoration: BoxDecoration(
                              color: mPrimaryDarkColor,
                              borderRadius: BorderRadius.circular(size.height * 0.15 * 0.5),
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(size.height * 0.15 * 0.5),
                              child: _selectedImage == null?Image.asset(
                                'assets/png/user_image.png',
                                fit: BoxFit.fill,
                              ) : Image.file(
                                _selectedImage,
                                fit: BoxFit.fill,
                              ),
                            ),
                          ),
                        ),
                        Center(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: InkWell(
                              onTap: (){
                                showDialog(context: context, builder: (_)=> makeImageChooser(context));
                              },
                              child: Text(
                                "Select picture",
                                style: googleBtnTextStyle.copyWith(
                                  color: mPrimaryDarkColor,
                                  fontWeight: FontWeight.w100,
                                  fontSize: 16,
                                  decoration: TextDecoration.underline,
                                ),
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                          child: TextFormField(
                            controller: _nameController,
                            validator: (text){
                              if(text.isEmpty){
                                return 'Please enter your name';
                              }
                              return null;
                            },
                            decoration: InputDecoration(
                              hintText: "e.g. Alex",
                              labelText: "Name",
                              border: OutlineInputBorder()
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                          child: TextFormField(
                            readOnly: widget.isGoogle,
                            controller: _emailController,
                            validator: (text){
                              if(text.isEmpty){
                                return 'Please enter email';
                              }
                              if(!text.contains("@")){
                                return 'Please enter valid email';
                              }
                              return null;
                            },
                            decoration: InputDecoration(
                                hintText: "e.g. example@something.com",
                                labelText: "Email",
                                border: OutlineInputBorder()
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                          child: TextFormField(
                            validator: (text){
                              if(text.isEmpty){
                                return 'Please enter mobile number';
                              }
                              if(text.length < 10){
                                return 'Please enter valid mobile number';
                              }
                              return null;
                            },
                            controller: _mobileController,
                            readOnly: !widget.isGoogle,
                            decoration: InputDecoration(
                                hintText: "e.g. 1234567890",
                                labelText: "Mobile",
                                prefix: Text("+91"),
                                border: OutlineInputBorder()
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                          child: InkWell(
                            onTap: isLoading? null :() async{
                              if (_formKey.currentState.validate()) {
                                setState(() {
                                  isLoading = true;
                                });

                                String url = "default";
                                if(_selectedImage!=null) {
                                  url = await FirebaseCheck.uploadImage(user, _selectedImage);
                                  if(!url.startsWith("https://")){
                                    Fluttertoast.showToast(msg: "Error in uploading image");
                                    return;
                                  }
                                }
                                Map<String, dynamic> map = {
                                  'uid': user.uid,
                                  'mobile': _mobileController.text.trim(),
                                  'email': _emailController.text.trim().toLowerCase(),
                                  'name': _nameController.text.trim(),
                                  'image': url,
                                  'bio': "default",
                                  'address': "default",
                                  'zipcode': "default",
                                };
                                await FirebaseCheck.insertUser(map:map);
                                Navigator.pushReplacement(context, CupertinoPageRoute(builder: (_) => MyCurrentLocationScreen()));
                              }
                            },
                            child: Container(
                              height: 50,
                              color: mPrimaryDarkColor,
                              child: Center(
                                child: isLoading? CircularProgressIndicator(
                                  valueColor: AlwaysStoppedAnimation(Colors.white),
                                ) : Text(
                                  "Continue",
                                  style: googleBtnTextStyle.copyWith(
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        )
                      ],
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

  Widget makeImageChooser(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.white,
      elevation: 8,
      title: Text(
        "Choose Source",
        style: TextStyle(
          fontFamily: 'Maven',
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
      ),
      content: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                  getImage(ImageSource.camera);
                },
                child: Container(
                  height: 60,
                  width: 60,
                  decoration: BoxDecoration(
                      color: Theme.of(context).cardColor,
                      borderRadius: BorderRadius.circular(15)),
                  child: Center(
                    child: Icon(
                      Icons.camera_enhance,
                      size: 30,
                      color: Colors.green,
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Text("Camera")
            ],
          ),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                  getImage(ImageSource.gallery);
                },
                child: Container(
                  height: 60,
                  width: 60,
                  decoration: BoxDecoration(
                      color: Theme.of(context).cardColor,
                      borderRadius: BorderRadius.circular(15)),
                  child: Center(
                    child: Icon(
                      Icons.photo,
                      size: 30,
                      color: Colors.blueAccent,
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Text("Gallery")
            ],
          ),
          _selectedImage!= null?Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                  setState(() {
                    _selectedImage = null;
                  });
                },
                child: Container(
                  height: 60,
                  width: 60,
                  decoration: BoxDecoration(
                      color: Theme.of(context).cardColor,
                      borderRadius: BorderRadius.circular(15)),
                  child: Center(
                    child: Icon(
                      Icons.close,
                      size: 30,
                      color: Colors.red,
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Text("Remove")
            ],
          ):Container(height: 1,),
        ],
      ),
    );
  }
}
