import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:purana_bazzar/utils/constants.dart';

class MessageBlock extends StatelessWidget {

  @override
  Widget build(BuildContext context) {

    final size = MediaQuery.of(context).size;

    return Padding(
      padding: const EdgeInsets.only(left: 20.0, right: 20, bottom: 5),
      child: Container(
        width: size.width,
        height: 120,
        child: Column(
          children: [
            Expanded(
              child: Row(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Container(
                    height: 100,
                    width: 100,
                    padding: const EdgeInsets.all(2),
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(50)
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(50),
                      child: CachedNetworkImage(
                        imageUrl: "http://loftyinterior.com/ikart/assets/image/app_image/no_message.png",
                        fit: BoxFit.fill,
                      ),
                    ),
                  ),
                  SizedBox(width: 10,),
                  Expanded(
                    child: Container(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Text("Username", style: googleBtnTextStyle.copyWith(fontSize: 16),),
                          Text("Ad title", style: googleBtnTextStyle.copyWith(fontSize: 14),),
                          Text("price",  style: googleBtnTextStyle.copyWith(fontSize: 14),),
                        ],
                      ),
                    ),
                  ),

                ],
              ),
            ),
            Divider(thickness: 0.5, color: googleTextColor,),
          ],
        ),
      ),
    );
  }
}
