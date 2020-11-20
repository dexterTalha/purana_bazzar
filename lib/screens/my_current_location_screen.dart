import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geocoder/geocoder.dart';
import 'package:geocoder/model.dart';
import 'package:location/location.dart' as loc;
import 'package:geolocator/geolocator.dart';
import '../firebase_helper/firebase_operations.dart';
import '../helper/shared_pref.dart';
import '../screens/login_screen.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:neumorphic/neumorphic.dart';
import '../utils/constants.dart';
import 'package:permission_handler/permission_handler.dart';

import 'home_screen.dart';

class MyCurrentLocationScreen extends StatefulWidget {
  @override
  _MyCurrentLocationScreenState createState() =>
      _MyCurrentLocationScreenState();
}

class _MyCurrentLocationScreenState extends State<MyCurrentLocationScreen> {
  final Duration _duration = Duration(milliseconds: 400);
  bool _isCollapsed = false, _isLoading = false;
  final Permission _permission = Permission.location;
  PermissionStatus _permissionStatus = PermissionStatus.undetermined;
  User user;
  var location = loc.Location();

  _getGpsSettings() async {
    if (!await location.serviceEnabled()) {
      location.requestService();
    }
  }

  @override
  void initState() {
    _listenForPermissionStatus();
    User u = FirebaseAuth.instance.currentUser;
    if (u == null) {
      Navigator.pushReplacement(
        context,
        CupertinoPageRoute<Null>(
          builder: (_) => LoginScreen(),
        ),
      );
    }else{
      user = u;
    }
    super.initState();
  }

  void _listenForPermissionStatus() async {
    final status = await _permission.status;
    setState(() => _permissionStatus = status);
  }

  _getLocation() async {
    await _getGpsSettings();
    setState(() {
      _isLoading = true;
    });

    Geolocator _locator = Geolocator();
    Position pos = await _locator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.best);
    final lat = pos.latitude;
    final lng = pos.longitude;
    await SharedPref().createLocationData(lat, lng);
    String street, area, pincode, city, state;
    final coordinates = Coordinates(lat, lng);
    var address = await Geocoder.local.findAddressesFromCoordinates(
        coordinates);
    street = address.first.featureName;
    area = address.first.subLocality;
    pincode = address.first.postalCode;
    city = address.first.subAdminArea;
    state = address.first.adminArea;
    Map<String, dynamic> map = {
      'address' : "$street, $area, $city, $pincode, $state",
      'location' : "${pos.latitude},${pos.longitude}",
    };
    bool st = await FirebaseCheck.updateLocation(map: map, uid: user.uid);

    setState(() {
      _isLoading = false;
    });
    if (st) {
      Navigator.pushReplacement(
        context,
        CupertinoPageRoute<Null>(
          builder: (_) => HomeScreen(),
        ),
      );
    } else {
      Fluttertoast.showToast(msg: "Error! Please try again");
    }

  }

  Future<void> requestPermission(Permission permission) async {
    final status = await permission.request();

    setState(() {
      print(status);
      _permissionStatus = status;
      print(_permissionStatus);
    });
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.white,
      body: LoadingOverlay(
        isLoading: _isLoading,
        color: mPrimaryColor,
        child: Container(
          padding:
              const EdgeInsets.only(right: 20, left: 20, bottom: 20, top: 20),
          height: size.height,
          width: size.width,
          child: Column(
            children: <Widget>[
              AnimatedContainer(
                duration: _duration,
                height: !_isCollapsed ? size.height * 0.5 : 0,
                child: Align(
                  alignment: Alignment(0, 0.3),
                  child: NeuCard(
                    width: 120,
                    height: 120,
                    curveType: CurveType.concave,
                    decoration: NeumorphicDecoration(
                      borderRadius: BorderRadius.circular(60),
                      color: Color(0xFFF2F3F6),
                    ),
                    child: Center(
                      child: Icon(
                        Icons.my_location,
                        size: 50,
                        color: Colors.grey,
                      ),
                    ),
                  ),
                ),
              ),
              AnimatedContainer(
                duration: _duration,
                height: !_isCollapsed ? size.height * 0.2 : 0,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    !_isCollapsed
                        ? Expanded(
                            child: Align(
                              alignment: Alignment.bottomCenter,
                              child: Text(
                                "Enable Location",
                                style: googleBtnTextStyle.copyWith(
                                    fontSize: 28,
                                    color: Colors.black54,
                                    fontWeight: FontWeight.bold,),
                              ),
                            ),
                          )
                        : Container(),
                    !_isCollapsed
                        ? SizedBox(
                            height: 15,
                          )
                        : Container(),
                    !_isCollapsed
                        ? Expanded(
                            child: Align(
                              alignment: Alignment.topCenter,
                              child: Text(
                                !_isCollapsed
                                    ? "You'll need to enable your\nlocation in order to use iKart"
                                    : "",
                                textAlign: TextAlign.center,
                                style: googleBtnTextStyle.copyWith(
                                    fontSize: !_isCollapsed ? 16 : 0,
                                    color: Colors.grey,),
                              ),
                            ),
                          )
                        : Container(),
                  ],
                ),
              ),
              !_isCollapsed ? Spacer() : Container(),
              _isCollapsed
                  ? GestureDetector(
                      onTap: () {
                        setState(() {
                          _isCollapsed = false;
                        });
                      },
                      child: Padding(
                        padding: const EdgeInsets.only(top: 30.0),
                        child: Icon(
                          Icons.keyboard_arrow_up,
                          color: Colors.black54,
                        ),
                      ),
                    )
                  : Container(),
              SizedBox(
                height: 15,
              ),
              Padding(
                padding: const EdgeInsets.only(right: 10, left: 10),
                child: GestureDetector(
                  onTap: () async {
                    await requestPermission(_permission);
                    if (_permissionStatus == PermissionStatus.granted) {
                      _getLocation();
                    } else {
                      Scaffold.of(context).showSnackBar(
                        SnackBar(
                          content: Text("Please allow location permission"),
                        ),
                      );
                    }
                  },
                  child: Container(
                    height: 50.00,
                    width: size.width,
                    decoration: BoxDecoration(
                      color: mPrimaryColor,
                      borderRadius: BorderRadius.circular(25.00),
                    ),
                    child: Center(
                      child: Text(
                        "ALLOW LOCATION",
                        textAlign: TextAlign.center,
                        style: googleBtnTextStyle.copyWith(
                            color: Colors.white, fontSize: 16,),
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 15,
              ),
              !_isCollapsed
                  ? GestureDetector(
                      onTap: () {
                        setState(() {
                          _isCollapsed = true;
                        });
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text(
                            "TELL ME MORE ",
                            textAlign: TextAlign.center,
                            style: googleBtnTextStyle.copyWith(
                                fontSize: 16,
                                color: Colors.grey,
                                fontWeight: FontWeight.bold),
                          ),
                          Icon(
                            Icons.keyboard_arrow_down,
                            color: Colors.black54,
                          ),
                        ],
                      ),
                    )
                  : Container(),
              Expanded(
                child: AnimatedContainer(
                  duration: _duration,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      _isCollapsed
                          ? Expanded(
                              child: Align(
                                alignment: Alignment.bottomCenter,
                                child: Text(
                                  "Get Your City Services",
                                  textAlign: TextAlign.center,
                                  style: googleBtnTextStyle.copyWith(
                                      fontSize: 28,
                                      color: Colors.black54,
                                      fontWeight: FontWeight.bold,),
                                ),
                              ),
                            )
                          : Container(),
                      _isCollapsed
                          ? SizedBox(
                              height: 15,
                            )
                          : Container(),
                      _isCollapsed
                          ? Expanded(
                              child: Align(
                                alignment: Alignment.topCenter,
                                child: Text(
                                  _isCollapsed
                                      ? "We'll be using your location to\nget the available services nearby"
                                      : "",
                                  textAlign: TextAlign.center,
                                  style: googleBtnTextStyle.copyWith(
                                      fontSize: 16, color: Colors.grey,),
                                ),
                              ),
                            )
                          : Container(),
                    ],
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
