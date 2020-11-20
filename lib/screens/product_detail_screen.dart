import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:like_button/like_button.dart';
import 'package:purana_bazzar/utils/constants.dart';

class ProductDetailScreen extends StatefulWidget {
  final String id;
  final String type;

  ProductDetailScreen({this.id,this.type});

  @override
  _ProductDetailScreenState createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(statusBarColor: mPrimaryDarkColor));
    final size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.white,
      body: customScrollView(size),
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
                  animationDuration: Duration(milliseconds: 600),
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
                  tag: "Product${widget.id},${widget.type}",
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
