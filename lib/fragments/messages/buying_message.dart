import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:purana_bazzar/models/message_model.dart';
import 'package:purana_bazzar/utils/constants.dart';
import '../../utils/message_block.dart';

class BuyingMessagesFragment extends StatefulWidget {
  @override
  _BuyingMessagesFragmentState createState() => _BuyingMessagesFragmentState();
}

class _BuyingMessagesFragmentState extends State<BuyingMessagesFragment> with AutomaticKeepAliveClientMixin {

  final User user = FirebaseAuth.instance.currentUser;
  bool isChatsLoading = true;
  List<QueryDocumentSnapshot> messageList = [];



  @override
  void initState() {
    super.initState();
    //getChatListAll();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final size = MediaQuery.of(context).size;
    return Container(
      width: size.width,
      height: size.height,
      padding: const EdgeInsets.only(top: 10),
      child: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance.collection("Users").doc(user.uid).collection("ChatList").orderBy("timestamp", descending: true).snapshots(),
          builder: (context, snapshot) {
            messageList = [];
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(mPrimaryDarkColor),
                ),
              );
            }
            if (snapshot.data.size<=0) {
              return Center(
                child: Text(
                  "No Chats",
                  style: googleBtnTextStyle,
                ),
              );
            }
            snapshot.data.docs.forEach((element) {
              if(element.get("posting") != user.uid)
                messageList.add(element);
            });

            return ListView.separated(
              itemCount: messageList.length,
              separatorBuilder: (context, index) => Divider(thickness: 0.5),
              itemBuilder: (_, index) {
                final f = messageList[index];
                final o = messageList[index].get("chatting");
                final b = messageList[index].get("isseen");
                MessageModel m = MessageModel(
                    posting: f.get("posting"),
                    adTitle: f.get("adtitle"),
                    adId: f.get("adid"),
                    adImage: f.get("adimage"),
                    adPrice: f.get("adprice"),
                    timeStamp: f.get("timestamp")
                );

                return Slidable(
                  actionPane: SlidableDrawerActionPane(),
                  closeOnScroll: true,
                  secondaryActions: [
                    IconSlideAction(
                      closeOnTap: true,
                      caption: 'Delete',
                      color: Colors.red,
                      icon: Icons.delete_outline,
                      onTap: () {
                        Fluttertoast.showToast(msg: "Delete");
                      },
                    ),
                  ],
                  child: MessageBlock(
                    model: m,
                    otherId: o,
                    isseen: b??true,
                  ),
                );
              },
            );
          }),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
