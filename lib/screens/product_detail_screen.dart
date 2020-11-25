import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:like_button/like_button.dart';
import 'package:purana_bazzar/firebase_helper/firebase_operations.dart';
import 'package:purana_bazzar/models/firebase_user_model.dart';
import 'package:purana_bazzar/models/message_model.dart';
import 'package:purana_bazzar/screens/chat_screen.dart';
import '../helper/favourites_helper.dart';
import '../models/ad_model.dart';
import '../utils/constants.dart';

class ProductDetailScreen extends StatefulWidget {
  final AdModel ad;
  final String type;

  ProductDetailScreen({this.ad, this.type});

  @override
  _ProductDetailScreenState createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {

  final AdsFavorites fav = AdsFavorites();
  List<AdModel> favAds = [];
  final User user = FirebaseAuth.instance.currentUser;
  @override
  void initState() {
    super.initState();
    fav.readAllFavorites().then((value) {
      favAds = value;
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(statusBarColor: mPrimaryDarkColor));

    final size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.white,
      body: customScrollView(size),
      bottomNavigationBar:  BottomAppBar(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: InkWell(
            onTap: () async{
              if(widget.ad.uid == user.uid){
                Fluttertoast.showToast(msg: "Cannot send message to own ad");
                return;
              }
              FirebaseUserModel chatUser = await FirebaseCheck().getUserDetails(widget.ad.uid);
              if(chatUser == null){
                Fluttertoast.showToast(msg: "Cannot send message to this user");
                return;
              }
              MessageModel m = MessageModel(
                timeStamp: 0,
                adPrice: widget.ad.price,
                imageUrl: null,
                adId: widget.ad.id,
                adImage: widget.ad.images[0],
                isSeen: false,
                message: "",
                receiver: null,
                sender: null,
                adTitle: widget.ad.title,
                posting: widget.ad.uid,
              );
              Navigator.push(context, CupertinoPageRoute(builder: (_) => ChatScreen(messageModel: m,chatUser: chatUser,)));
            },
            child: Container(
              height: 50,
              color: mPrimaryDarkColor,
              child: Center(
                child: Text(
                  "Chat".toUpperCase(),
                  style: googleBtnTextStyle.copyWith(
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  customScrollView(Size size) {
    return SafeArea(
      child: Container(
        height: size.height,
        width: size.width,
        child: CustomScrollView(

          slivers: [
            SliverAppBar(
              expandedHeight: size.height * 0.4,
              pinned: true,
              backgroundColor: mPrimaryColor,
              actions: [
                LikeButton(
                  isLiked: fav.isFavorite(widget.ad),
                  animationDuration: Duration(milliseconds: 600),
                  onTap: (t)async{
                    !t? fav.addFavorite(widget.ad) : fav.removeFavorite(widget.ad);
                    return !t;
                  },
                  likeBuilder: (bool isLiked) {
                    return Icon(
                      isLiked ?Icons.favorite:Icons.favorite_border,
                      color:  Colors.red,
                      size: 28,
                    );
                  },
                ),
              ],
              leading: GestureDetector(
                onTap: () => Navigator.pop(context),
                child: Icon(
                  Icons.arrow_back_ios,
                  color: Colors.white,
                ),
              ),
              flexibleSpace: FlexibleSpaceBar(
                background: Hero(
                  tag: "Product${widget.ad.id},${widget.type}",
                  child: Image.asset(
                    "assets/png/testing.png",
                    fit: BoxFit.fill,
                  ),
                ),
              ),
            ),
            SliverList(
              delegate: SliverChildListDelegate.fixed(
                [
                  SizedBox(
                    height: 2,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8),
                    child: Text(
                      "Apple Macbook Pro 13 with Touch Bar",
                      style: googleBtnTextStyle.copyWith(fontSize: 22),
                    ),
                  ),
                  SizedBox(
                    height: 3,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8),
                    child: Text(
                      "\u20B9 1300",
                      style: googleBtnTextStyle.copyWith(color: mPrimaryDarkColor, fontSize: 20),
                    ),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Card(

                    child: Container(
                      width: size.width,
                      child: Padding(
                        padding: const EdgeInsets.all(10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Detail Product",
                              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                            SizedBox(
                              height: 7,
                            ),
                            Text(
                              "1) MackBook Pro",
                              style: TextStyle(fontSize: 16, fontWeight: FontWeight.normal),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Card(
                    child: Container(
                      width: size.width,
                      child: Padding(
                        padding: const EdgeInsets.all(10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Description",
                              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                            ),
                            SizedBox(
                              height: 4,
                            ),
                            Text(
                              "cdfjkdsff ",
                              style: TextStyle(fontSize: 16, fontWeight: FontWeight.normal),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Card(
                    child: Container(
                      width: size.width,
                      child: Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(12),
                            child: FlutterLogo(
                              size: 60,
                            ),
                          ),
                          SizedBox(
                            width: 20,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 20),
                            child: Column(
                              children: [
                                Text(
                                  "User Profile",
                                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                                ),
                                SizedBox(
                                  height: 4,
                                ),
                                Text(
                                  "Md Talha",
                                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.normal),
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Card(
                    child: Container(
                      width: size.width,
                      child: Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(12),
                            child: FlutterLogo(
                              size: 60,
                            ),
                          ),
                          SizedBox(
                            width: 20,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 20),
                            child: Column(
                              children: [
                                Text(
                                  "User Profile",
                                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                                ),
                                SizedBox(
                                  height: 4,
                                ),
                                Text(
                                  "Md Talha",
                                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.normal),
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 5,
                  ),

                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
