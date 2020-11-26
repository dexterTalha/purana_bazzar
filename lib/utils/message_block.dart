import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:purana_bazzar/firebase_helper/firebase_operations.dart';
import 'package:purana_bazzar/models/firebase_user_model.dart';
import 'package:purana_bazzar/models/message_model.dart';
import '../screens/chat_screen.dart';
import '../utils/constants.dart';

class MessageBlock extends StatefulWidget {

  final MessageModel model;
  final String otherId;
  final bool isseen;

  MessageBlock({this.model, this.otherId, this.isseen = true});

  @override
  _MessageBlockState createState() => _MessageBlockState();
}

class _MessageBlockState extends State<MessageBlock> {
  final User user = FirebaseAuth.instance.currentUser;
  Future<FirebaseUserModel> d;


  @override
  void initState() {
    super.initState();
    String otheruid = widget.otherId;
    d = FirebaseFirestore.instance.collection("Users").doc(otheruid).get().then((value) => FirebaseUserModel.fromSnapshot(value));
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return FutureBuilder<FirebaseUserModel>(
        future: d,
        builder: (context, snapshot) {
          return Padding(
            padding: const EdgeInsets.only(left: 20.0, right: 20, ),
            child: Container(
              width: size.width,
              height: 70,
              child: InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    CupertinoPageRoute(
                      builder: (_) => ChatScreen(
                        chatUser: snapshot.data,
                        messageModel: widget.model,
                      ),
                    ),
                  );
                },
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Container(
                      height: 70,
                      width: 70,
                      padding: const EdgeInsets.all(2),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(50)),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(50),
                        child: CachedNetworkImage(
                          imageUrl:
                          widget.model.adImage,
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
                          children: [
                            SizedBox(
                              height: 10,
                            ),
                            Text(
                              snapshot.connectionState == ConnectionState.waiting?"Loading":snapshot.data.name,
                              style: googleBtnTextStyle.copyWith(fontSize: 16),
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Text(
                              widget.model.adTitle,
                              style: googleBtnTextStyle.copyWith(fontSize: 14),
                            ),
                            SizedBox(
                              height: 3,
                            ),
                            Text(
                              "\u20B9 ${widget.model.adPrice}",
                              style: googleBtnTextStyle.copyWith(fontSize: 14),
                            ),
                          ],
                        ),
                      ),
                    ),

                    !widget.isseen?Container(
                      height: 15,
                      width: 15,
                      decoration: BoxDecoration(
                          color: mPrimaryDarkColor,
                          borderRadius: BorderRadius.circular(10)
                      ),
                    ):Container(),
                  ],
                ),
              ),
            ),
          );
        }
    );
  }
}