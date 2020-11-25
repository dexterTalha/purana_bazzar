import 'package:flutter/material.dart';

class AdModel{
  String id, parent, child, title, price, address, uid;
  bool isPrime;
  List<String> images;

  AdModel({this.id, this.parent, this.child, this.title, this.price, this.address, this.isPrime, this.images, this.uid});
  factory AdModel.fromJson(Map<String, dynamic> map){
    return AdModel(
      id: map['id'],
      parent: map['parent_id'],
      child: map['cat_id'],
      title: map['title'],
      price: map['price'],
      address: map['address'],
      images: map['thumbnail'].toString().split(","),
      isPrime: map['isprime'],
      uid: map['uid']
    );
  }
  Map<String, dynamic> toJson(){

    return {
      "id": this.id,
      "parent_id": this.parent,
      "cat_id": this.child,
      "title": this.title,
      "price": this.price,
      "address": this.address,
      "thumbnail": "${this.images[0]}",
      "isprime": this.isPrime,
      "uid" : this.uid
    };
  }
}
