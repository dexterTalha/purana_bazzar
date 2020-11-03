import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:like_button/like_button.dart';
import 'package:purana_bazzar/screens/product_detail_screen.dart';
import 'package:purana_bazzar/utils/constants.dart';

class AdViewBlock extends StatelessWidget {

  final int id;


  AdViewBlock({this.id});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        Navigator.push(context, CupertinoPageRoute(builder: (_) =>ProductDetailScreen(id: id,)));
      },
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Card(
          elevation: 8,
          child: Stack(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: ClipRRect(
                        borderRadius: BorderRadius.only(topLeft: Radius.circular(10), topRight: Radius.circular(10)),
                        child: Hero(
                          tag: "Product$id",
                          child: Image.asset(
                            "assets/png/testing.png",
                            height: 200,
                            width: 180,
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 10,),
                    Text(
                      "Testing product",
                      style: googleBtnTextStyle.copyWith(fontSize: 15),
                    ),
                    SizedBox(height: 5,),
                    Text(
                      "\u20B9 250",
                      style: googleBtnTextStyle.copyWith(fontSize: 13),
                    ),
                    SizedBox(height: 5,),
                    Row(
                      children: [
                        Icon(Icons.pin_drop, color: googleTextColor, size: 15,),
                        SizedBox(width: 5,),
                        Text(
                          "address...",
                          style: googleBtnTextStyle.copyWith(fontSize: 13),
                        )
                      ],
                    )
                  ],
                ),
              ),
              Positioned(
                top: 10,
                right: 10,
                child: LikeButton(
                  animationDuration: Duration(milliseconds: 600),
                  likeBuilder: (bool isLiked) {
                    return Icon(
                      Icons.favorite,
                      color: isLiked ? Colors.deepPurpleAccent : Colors.grey,
                      size: 30,
                    );
                  },
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
