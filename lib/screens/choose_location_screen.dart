import 'package:android_intent/android_intent.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart';
import '../helper/shared_pref.dart';
import '../utils/constants.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:neumorphic/neumorphic.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'home_screen.dart';

class ChooseLocationScreen extends StatefulWidget {

  final LatLng latLng;
  ChooseLocationScreen({this.latLng});

  @override
  _ChooseLocationScreenState createState() => _ChooseLocationScreenState();
}

class _ChooseLocationScreenState extends State<ChooseLocationScreen> {

  bool isLoading = false;
  final Permission _permission = Permission.location;
  PermissionStatus _permissionStatus = PermissionStatus.undetermined;
  GoogleMapController mapController;

  LatLng myLatLng;
  Map<String,Marker> myMarker = {};


  @override
  void initState() {
    super.initState();
    _checkGps();
  }

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
    CameraUpdate c = CameraUpdate.newLatLngZoom(widget.latLng, 16);
    mapController.animateCamera(c);
    myMarker.clear();
    myMarker["default"] = Marker(
      markerId: MarkerId("default"),
      position: widget.latLng,
    );

    setState(() {
    });
  }

  Future _checkGps() async {
    if (!(await Geolocator().isLocationServiceEnabled())) {
      if (Theme.of(context).platform == TargetPlatform.android) {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text("GPS disabled"),
              content:
              const Text('Please make sure you enable GPS and try again'),
              actions: <Widget>[
                FlatButton(
                  child: Text('Ok'),
                  onPressed: () {
                    final AndroidIntent intent = AndroidIntent(
                        action: 'android.settings.LOCATION_SOURCE_SETTINGS');

                    intent.launch();
                    Navigator.of(context, rootNavigator: true).pop();
                  },
                ),
              ],
            );
          },
        );
      }
      return null;
    }
    return true;
  }


  void _listenForPermissionStatus() async {
    final status = await _permission.status;
    setState(() => _permissionStatus = status);
  }


  _getLocation(context) async{
    bool s = await _checkGps() ??  false;
    if(!s){
      Fluttertoast.showToast(msg: "Please enable GPS to proceed");
      return;
    }
    setState(() {
      isLoading = true;
    });
    Geolocator _locator = Geolocator();
    Position pos = await _locator.getCurrentPosition(desiredAccuracy: LocationAccuracy.best);
    final lat = pos.latitude;
    final lng = pos.longitude;
    if(pos != null){
      await SharedPref().createLocationData(lat, lng, isAllowed: true);
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => HomeScreen()));
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

    return WillPopScope(
      onWillPop: () => Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => HomeScreen())),
      child: Scaffold(
        body: LoadingOverlay(
          isLoading: isLoading,
          child: SafeArea(
            child: Container(
              height: size.height,
              width: size.width,
              margin: const EdgeInsets.only(top: 20),
              child: Column(
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 20),
                    child: Container(
                      height: 50,
                      width: 50,
                      child: IconButton(
                        onPressed: () => Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => HomeScreen())),

                        icon: Icon(Icons.arrow_back_ios, size: 20, color: mPrimaryColor,),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 20.0, left: 20, top: 20, bottom: 10),
                    child: RaisedButton(
                      color: mPrimaryColor,
                      onPressed: () async{
                        _listenForPermissionStatus();
                        if(_permissionStatus != PermissionStatus.granted){
                          await requestPermission(_permission);
                        }
                        if(_permissionStatus == PermissionStatus.granted) _getLocation(context);
                      },

                      child: Padding(
                        padding: const EdgeInsets.only(top: 10.0, bottom: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Center(
                              child: Icon(
                                Icons.location_searching,
                                size: 20,
                                color: Colors.white,
                              ),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Text(
                              "Use my current location",
                              style: googleBtnTextStyle.copyWith(
                                  color: Colors.white,
                                  fontSize: 16
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 10,),
                  Center(child: Text("OR CHOOSE FROM MAP", style: TextStyle(color: Colors.grey, fontFamily: "Maven"),),),
                  SizedBox(height: 10,),
                  Expanded(
                    child:
                        GoogleMap(
                          markers: myMarker.values.toSet(),
                          myLocationButtonEnabled: true,
                          myLocationEnabled: true,
                          onMapCreated: _onMapCreated,
                          initialCameraPosition: CameraPosition(
                            target: widget.latLng,
                            zoom: 11.0,
                          ),
                          zoomControlsEnabled: true,
                          gestureRecognizers:<Factory<OneSequenceGestureRecognizer>>[
                            new Factory<OneSequenceGestureRecognizer>(() => new EagerGestureRecognizer(),),
                          ].toSet(),
                          onTap: (latlng){
                            myMarker["default"] = Marker(
                              markerId: MarkerId("default"),
                              position: latlng,
                            );

                            setState(() { myLatLng = latlng;});
                          },
                        ),

                    ),
                  Padding(
                    padding: EdgeInsets.all(myLatLng == null ? 0 : 10.0),
                    child: GestureDetector(
                      onTap: myLatLng == null ? null : () async{
                        setState(() {
                          isLoading = true;
                        });
                        await SharedPref().createLocationData(myLatLng.latitude, myLatLng.longitude, isAllowed: true);
                        Fluttertoast.showToast(msg: "Location updated");
                        Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => HomeScreen()));
                      },
                      child: AnimatedContainer(
                        duration: Duration(milliseconds: 300),
                        color: mPrimaryColor,
                        height:  myLatLng == null ? 0 : 56,
                        width: MediaQuery.of(context).size.width,
                        child: Center(
                          child: Text(
                            "Set Location",
                            style: TextStyle(
                              fontSize: 20,
                              fontFamily: "Maven",
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),

                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
