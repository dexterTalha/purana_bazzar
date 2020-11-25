import 'package:cloud_firestore/cloud_firestore.dart';

class MessageModel{
  String message, sender, receiver, adId, posting, imageUrl, adImage, adTitle, adPrice;
  bool isSeen;
  int timeStamp;


  MessageModel({this.message, this.sender, this.receiver, this.adId, this.posting, this.imageUrl, this.adImage, this.adTitle, this.adPrice, this.isSeen, this.timeStamp});

  factory MessageModel.fromFireStore(DocumentSnapshot d){
    return MessageModel(
      isSeen: d.get("isseen"),
      message: d.get('message'),
      receiver: d.get("receiver"),
      sender: d.get("sender"),
      imageUrl: d.get("image"),
      timeStamp: d.get("timestamp"),
      adId: d.get("adid"),
      adImage: d.get("adimage"),
      adPrice: d.get("adprice"),
      adTitle: d.get("adtitle"),
      posting: d.get("posting")
    );
  }
}
