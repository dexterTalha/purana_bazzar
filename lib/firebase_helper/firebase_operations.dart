import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:purana_bazzar/models/firebase_user_model.dart';
import '../helper/shared_pref.dart';
import '../utils/constants.dart';

class FirebaseCheck {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  static Future<bool> checkOldUser({uid}) async {

    CollectionReference users = FirebaseFirestore.instance.collection('Users');

    final data = await users.doc(uid).get();
    print("is old user : ${data.exists}");
    return data.exists;
  }

  Future<FirebaseUserModel> getUserDetails(String uid) async{
    try {
      return FirebaseUserModel.fromSnapshot(await FirebaseFirestore.instance.collection("Users").doc(uid).get());
    }catch(e){
      return null;
    }
  }

  static Future<bool> checkLocation({uid}) async {
    bool isAlready = false;

    CollectionReference users = FirebaseFirestore.instance.collection('Users');
    final data = await users.doc(uid).get();
    if(data.exists) {
      isAlready =  data.data()['location'] != null;
      if (isAlready) {
        String latlng = data["location"];
        double lat = double.parse(latlng.split(",")[0].trim());
        double lng = double.parse(latlng.split(",")[1].trim());
        await SharedPref().createLocationData(lat, lng);
      }
    }
    return isAlready;
  }

  static Future<void> insertUser({Map<String, dynamic> map}) async{
    String uid = map['uid'];
    CollectionReference users = FirebaseFirestore.instance.collection('Users');
    await users.doc(uid).set(map);

  }

  static Future<bool> updateLocation({Map map, String uid}) async {
    bool status = true;
    CollectionReference users = FirebaseFirestore.instance.collection('Users');
    await users.doc(uid).update(map);
    return status;
  }

  static Future<String> uploadImage(User user, File image) async{
    FirebaseStorage storage = FirebaseStorage.instance;
    String path = image.absolute.path;

    String fileName = path.split("/").last;
    String extension = fileName.split(".")[1];
    try {
      Reference reference = storage.ref().child("profileImages/${user.uid}.$extension");

      //Upload the file to firebase
      TaskSnapshot uploadTask = await reference.putFile(image).whenComplete(() => {});

      String url = await uploadTask.ref.getDownloadURL();
      print(url);
      return url;
    }on FirebaseException catch (e) {
      String code = e.code;
      return code;
    }
  }

}
