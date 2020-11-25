import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:purana_bazzar/models/firebase_user_model.dart';
import 'package:purana_bazzar/models/message_model.dart';
import '../utils/constants.dart';
import '../utils/messages.dart';

extension DateOnlyCompare on DateTime {
  bool isSameDate(DateTime other) {
    return this.year == other.year && this.month == other.month && this.day == other.day;
  }
}

class ChatScreen extends StatefulWidget {
  final FirebaseUserModel chatUser;
  final MessageModel messageModel;

  ChatScreen({this.chatUser, this.messageModel});

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final appBarHeight = AppBar().preferredSize.height;
  final User user = FirebaseAuth.instance.currentUser;
  final _textMessageController = TextEditingController();
  String otherId;

  Future<bool> onBackPress() {
    FirebaseFirestore.instance.collection('Users').doc(user.uid).update({'chattingWith': null});
    Navigator.pop(context);

    return Future.value(false);
  }

  @override
  void initState() {
    super.initState();
    FirebaseFirestore.instance.collection('Users').doc(user.uid).update({'chattingWith': widget.chatUser.uid});
    _updateIsSeen();
  }

  _updateIsSeen() async {
    try {
      CollectionReference r = FirebaseFirestore.instance.collection("Users").doc(user.uid).collection("ChatList");

      r.doc(widget.chatUser.uid + widget.messageModel.adId).update({
        "isseen": true,
      });
    }catch(e){}
    FirebaseFirestore.instance.collection("Chats").get().then((value) {
      value.docs.forEach((element) async {
        if (element.get("receiver") == user.uid) {
          CollectionReference ref = FirebaseFirestore.instance.collection("Chats");
          await ref.doc(element.id).update({"isseen": true});
        }
      });
    });
  }

  @override
  void dispose() {
    _textMessageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return WillPopScope(
      onWillPop: onBackPress,
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        appBar: AppBar(
          leading: IconButton(
            onPressed: () {
              onBackPress();
            },
            icon: Icon(
              Icons.arrow_back,
              color: Colors.white,
            ),
          ),
          title: Padding(
            padding: const EdgeInsets.only(top: 8.0, bottom: 8),
            child: Row(
              children: [
                Container(
                  height: appBarHeight - 8,
                  width: appBarHeight - 8,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(appBarHeight * 0.5),
                    color: Colors.white,
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(appBarHeight * 0.5),
                    child: CachedNetworkImage(
                      imageUrl: widget.chatUser.image == "default" ? "http://pb.loftyinterior.com/product_images/mCo9nJEG42OsB0XeIkDz.jpg" : widget.chatUser.image,
                      height: appBarHeight - 8,
                      width: appBarHeight - 8,
                      fit: BoxFit.fill,
                    ),
                  ),
                ),
                SizedBox(
                  width: 10,
                ),
                Expanded(
                  child: Text(
                    widget.chatUser.name,
                    textAlign: TextAlign.left,
                    style: googleBtnTextStyle.copyWith(color: Colors.white),
                  ),
                )
              ],
            ),
          ),
        ),
        body: Container(
          child: Column(
            children: [
              adBlockView(size),
              Flexible(
                child: StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance.collection("Chats").orderBy("timestamp", descending: true).snapshots(),
                  builder: (context, snapshot) {
                    _updateIsSeen();
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(
                        child: CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(mPrimaryDarkColor),
                        ),
                      );
                    }
                    if (!snapshot.hasData || snapshot.hasError) {
                      return Center(
                        child: Text(
                          "No Chats",
                          style: googleBtnTextStyle,
                        ),
                      );
                    }

                    return Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: ListView.builder(
                        reverse: true,
                        itemCount: snapshot.data.size,
                        itemBuilder: (_, index) {
                          if (snapshot.data.docs[index]['sender'] == user.uid || snapshot.data.docs[index]['receiver'] == user.uid) {
                            if(snapshot.data.docs[index]['sender'] == widget.chatUser.uid || snapshot.data.docs[index]['receiver'] == widget.chatUser.uid) {
                              if (snapshot.data.docs[index]['adid'] == widget.messageModel.adId) {
                                MessageModel m = MessageModel.fromFireStore(snapshot.data.docs[index]);
                                bool isSender = m.sender == user.uid;
                                DateTime date = DateTime.fromMillisecondsSinceEpoch(m.timeStamp);
                                bool isToday = date.isSameDate(DateTime.now());
                                DateFormat formatter = DateFormat(isToday ? "hh:mm a" : "dd MMM, yyyy");
                                String d = formatter.format(date);
                                return Message(
                                  dateTime: d,
                                  direction: isSender ? "right" : "left",
                                  msg: m.message,
                                );
                              }
                            }
                          }
                          return Container();
                        },
                      ),
                    );
                  },
                ),
              ),
              Divider(height: 1.0),
              Container(
                decoration: BoxDecoration(color: Theme.of(context).cardColor),
                child: IconTheme(
                  data: IconThemeData(color: Theme.of(context).accentColor),
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 2.0),
                    child: Row(
                      children: <Widget>[
                        //Enter Text message here
                        Flexible(
                          child: Padding(
                            padding: const EdgeInsets.only(left: 8.0),
                            child: TextFormField(
                              controller: _textMessageController,
                              keyboardType: TextInputType.multiline,
                              enableSuggestions: true,
                              maxLines: 4,
                              minLines: 1,
                              textInputAction: TextInputAction.newline,
                              decoration: InputDecoration.collapsed(
                                hintText: "Enter message",
                              ),
                            ),
                          ),
                        ),

                        //right send button

                        IconButton(onPressed: () {}, icon: Icon(Icons.image)),

                        InkWell(
                          onTap: () async{
                            if (_textMessageController.text.trim().isEmpty) {
                              Fluttertoast.showToast(msg: "Cannot send empty message");
                              return;
                            }

                            //bool isNew = await FirebaseFirestore.instance.collection("Chats").where("sender", isEqualTo: widget.chatUser.uid).where("receiver", isEqualTo: widget.chatUser.uid).;
                            _sendMessage(true);
                          },
                          child: Container(
                            margin: EdgeInsets.symmetric(
                              horizontal: 2.0,
                            ),
                            width: 48.0,
                            height: 48.0,
                            child: Icon(
                              Icons.send_rounded,
                              color: mPrimaryDarkColor,
                            ),
                          ),
                        ),
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

  adBlockView(Size size) {
    return InkWell(
      onTap: () {},
      child: Card(
        elevation: 8,
        child: Padding(
          padding: const EdgeInsets.only(left: 20.0, right: 20, bottom: 5),
          child: Container(
            width: size.width,
            height: 90,
            child: Row(
              mainAxisSize: MainAxisSize.max,
              children: [
                Container(
                  height: 60,
                  width: 60,
                  padding: const EdgeInsets.all(2),
                  decoration: BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(30),
                    child: CachedNetworkImage(
                      imageUrl: widget.messageModel.adImage,
                      fit: BoxFit.fill,
                    ),
                  ),
                ),
                SizedBox(
                  width: 10,
                ),
                Expanded(
                  child: Container(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Text(
                          widget.chatUser.name,
                          style: googleBtnTextStyle.copyWith(fontSize: 14),
                        ),
                        Text(
                          widget.messageModel.adTitle,
                          style: googleBtnTextStyle.copyWith(fontSize: 12),
                        ),
                        Text(
                          "\u20B9 ${widget.messageModel.adPrice}",
                          style: googleBtnTextStyle.copyWith(fontSize: 12),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  _sendMessage(bool isNew) {
    Map<String, dynamic> map = {
      "isseen": false,
      "message": _textMessageController.text.trim(),
      "receiver": widget.chatUser.uid,
      "sender": user.uid,
      "image": null,
      "timestamp": DateTime.now().millisecondsSinceEpoch,
      "adid": widget.messageModel.adId,
      "adimage": widget.messageModel.adImage,
      "adprice": widget.messageModel.adPrice,
      "adtitle": widget.messageModel.adTitle,
      "posting": widget.messageModel.posting
    };
    _textMessageController.text = "";
    CollectionReference ref = FirebaseFirestore.instance.collection("Chats");
    ref.add(map);

    CollectionReference ref1 = FirebaseFirestore.instance.collection("Users");
    ref1.doc(user.uid).collection("ChatList").doc(widget.chatUser.uid+widget.messageModel.adId).set({
      "chatting": widget.chatUser.uid,
      "timestamp": DateTime
          .now()
          .millisecondsSinceEpoch,
      "adid": widget.messageModel.adId,
      "adimage": widget.messageModel.adImage,
      "adprice": widget.messageModel.adPrice,
      "adtitle": widget.messageModel.adTitle,
      "posting": widget.messageModel.posting,
      "isseen": true,
    });
    ref1.doc(widget.chatUser.uid).collection("ChatList").doc(user.uid+widget.messageModel.adId).set({
      "chatting": user.uid,
      "timestamp": DateTime
          .now()
          .millisecondsSinceEpoch,
      "adid": widget.messageModel.adId,
      "adimage": widget.messageModel.adImage,
      "adprice": widget.messageModel.adPrice,
      "adtitle": widget.messageModel.adTitle,
      "posting": widget.messageModel.posting,
      "isseen": false,
    });



  }
}
