import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:purana_bazzar/screens/chat_screen.dart';
import 'package:purana_bazzar/utils/constants.dart';

class MessageBlock extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Padding(
      padding: const EdgeInsets.only(left: 20.0, right: 20, bottom: 5),
      child: Container(
        width: size.width,
        height: 90,
        child: InkWell(
          onTap: () {
            Navigator.push(
                context, CupertinoPageRoute(builder: (_) => ChatScreen()));
          },
          child: Row(
            mainAxisSize: MainAxisSize.max,
            children: [
              Container(
                height: 70,
                width: 70,
                padding: const EdgeInsets.all(2),
                decoration: BoxDecoration(
                    color: Colors.red, borderRadius: BorderRadius.circular(50)),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(50),
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
                    children: [
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        "Username",
                        style: googleBtnTextStyle.copyWith(fontSize: 16),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Text(
                        "Ad title",
                        style: googleBtnTextStyle.copyWith(fontSize: 14),
                      ),
                      SizedBox(
                        height: 3,
                      ),
                      Text(
                        "price",
                        style: googleBtnTextStyle.copyWith(fontSize: 14),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
