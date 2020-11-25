import 'dart:math';

import 'package:flutter/material.dart';
import 'package:geocoder/geocoder.dart';
import 'package:geocoder/model.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../firebase_helper/firebase_login.dart';
import '../utils/constants.dart';

class HelperClass {
  static Future<bool> buildDiscardDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(
          "Discard",
          style: googleBtnTextStyle,
        ),
        content: Text(
          "Do you want to discard?",
          style: googleBtnTextStyle.copyWith(fontSize: 16),
        ),
        actions: [
          RaisedButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text("No", style: TextStyle(color: Colors.white),),
            color: mPrimaryColor,
          ),
          FlatButton(
            onPressed: () {
              Navigator.pop(context);
              FirebaseLogin().signOut();
              FirebaseLogin().onAuthStateChanged(context);
            },
            child: Text("Yes"),
          ),
        ],
      ),
    );
    return Future.value(true);
  }

  static Future<List<String>> getAddressFromCoordinates(LatLng lt) async{
    final coordinates = Coordinates(lt.latitude, lt.longitude);
    var address = await Geocoder.local.findAddressesFromCoordinates(
        coordinates);
    String street = address.first.featureName;
    String area = address.first.subLocality;
    String pincode = address.first.postalCode;
    String city = address.first.subAdminArea;
    String state = address.first.adminArea;
    return ["$street, $area, $city, $state, $pincode", "$pincode"];
  }

  static const _chars = 'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
  Random _rnd = Random();
  String getRandomString(int length) => String.fromCharCodes(Iterable.generate(
      length, (_) => _chars.codeUnitAt(_rnd.nextInt(_chars.length))));

}
