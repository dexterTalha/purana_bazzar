import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:purana_bazzar/utils/constants.dart';
import 'package:purana_bazzar/utils/messages.dart';

class ChatScreen extends StatefulWidget {
  ChatScreen({Key key}) : super(key: key);

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final appBarHeight = AppBar().preferredSize.height;
  List<Map<String, dynamic>> msgs = [
    {"msg": "hello", "issender": true},
    {"msg": "hi dexter", "issender": false},
    {"msg": "bye", "issender": true},
  ];

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
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
                    imageUrl:
                        "http://loftyinterior.com/ikart/assets/image/app_image/no_message.png",
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
                  "Username",
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
              child: ListView.builder(
                reverse: true,
                itemCount: msgs.length,
                itemBuilder: (_, index) {
                  bool isSender = msgs[index]['issender'];
                  return Message(
                    dateTime: "05 Nov, 2020",
                    direction: isSender ? "right" : "left",
                    msg: msgs[index]['msg'],
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
                            decoration: InputDecoration.collapsed(
                              hintText: "Enter message",
                            ),
                          ),
                        ),
                      ),

                      //right send button

                      IconButton(onPressed: () {}, icon: Icon(Icons.image)),

                      InkWell(
                        onTap: () {},
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
                      imageUrl:
                          "http://loftyinterior.com/ikart/assets/image/app_image/no_message.png",
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
                          "Username",
                          style: googleBtnTextStyle.copyWith(fontSize: 14),
                        ),
                        Text(
                          "Ad title",
                          style: googleBtnTextStyle.copyWith(fontSize: 12),
                        ),
                        Text(
                          "price",
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
}
