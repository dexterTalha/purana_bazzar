import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseUserModel{
  String uid, image, name, email, address, zipCode, mobile, location, bio;


  FirebaseUserModel({this.uid, this.image, this.name, this.email, this.address, this.zipCode, this.mobile, this.location, this.bio});

  factory FirebaseUserModel.fromSnapshot(DocumentSnapshot d){
    return FirebaseUserModel(
      name: d.get("name"),
      image: d.get("image"),
      address: d.get("address"),
      email: d.get("email"),
      uid: d.get("uid"),
      zipCode: d.get("zipcode"),
      mobile: d.get("mobile"),
      location: d.get("location"),
      bio: d.get("bio"),
    );
  }
}