import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:like_button/like_button.dart';
import '../helper/favourites_helper.dart';
import '../models/ad_model.dart';
import '../screens/product_detail_screen.dart';
import '../utils/constants.dart';
import 'package:shimmer/shimmer.dart';

class AdViewBlock extends StatelessWidget {
  final AdModel ad;
  final bool isMyAdd;
  final String type;
  final bool isFav;

  AdViewBlock({this.ad, this.isMyAdd = false, this.type, this.isFav = false});

  final AdsFavorites fav = AdsFavorites();

  @override
  Widget build(BuildContext context) {

    return GestureDetector(
      onTap: () {
        //print(type+ad.id);
        Navigator.push(
          context,
          CupertinoPageRoute(
            builder: (_) => ProductDetailScreen(
              ad: ad,
              type: type,
            ),
          ),
        );
      },
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Card(
          elevation: 8,
          child: Stack(
            children: [
              Container(
                height: 250,
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
                          tag: "Product${ad.id},$type",
                          child: CachedNetworkImage(
                            imageUrl: ad.images[0],
                            height: 210,
                            width: 180,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Text(
                        ad.title,
                        style: googleBtnTextStyle.copyWith(fontSize: 15),
                      ),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Text(
                        "\u20B9 ${ad.price}",
                        style: googleBtnRegularTextStyle.copyWith(fontSize: 13),
                      ),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Container(
                      width: 180,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: Row(
                          children: [
                            Icon(
                              Icons.pin_drop,
                              color: googleTextColor,
                              size: 15,
                            ),
                            SizedBox(
                              width: 5,
                            ),
                            Expanded(
                              child: Text(
                                ad.address,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: googleBtnRegularTextStyle.copyWith(fontSize: 13),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                    !isMyAdd
                        ? Container(
                            height: 10,
                          )
                        : Row(
                          children: [
                            Expanded(
                              child: GestureDetector(
                                  onTap: () {
                                    Fluttertoast.showToast(msg: "Edit");
                                  },
                                  child: Container(
                                    margin: const EdgeInsets.only(top: 10),
                                    padding: const EdgeInsets.all(4),
                                    decoration: BoxDecoration(
                                      color: mPrimaryColor,
                                      borderRadius: BorderRadius.only(
                                        bottomLeft: Radius.circular(4),
                                      ),
                                    ),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Icon(
                                          Icons.edit,
                                          size: 20,
                                          color: Colors.white,
                                        ),
                                        SizedBox(
                                          width: 10,
                                        ),
                                        Text(
                                          "Edit",
                                          style: googleBtnTextStyle.copyWith(fontSize: 14, color: Colors.white),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                            ),
                            Expanded(
                              child: GestureDetector(
                                onTap: () {
                                  Fluttertoast.showToast(msg: "Sold");
                                },
                                child: Container(
                                  margin: const EdgeInsets.only(top: 10),
                                  padding: const EdgeInsets.all(4),
                                  decoration: BoxDecoration(
                                    color: Colors.redAccent,
                                    borderRadius: BorderRadius.only(
                                      bottomRight: Radius.circular(4),
                                    ),
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.check,
                                        size: 20,
                                        color: Colors.white,
                                      ),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      Text(
                                        "Sold",
                                        style: googleBtnTextStyle.copyWith(fontSize: 14, color: Colors.white),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                  ],
                ),
              ),
              Positioned(
                top: 10,
                right: 10,
                left: 5,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                     ad.isPrime?Container(
                       decoration: BoxDecoration(
                         color: Colors.green
                       ),
                       child: Padding(
                         padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                         child: Shimmer.fromColors(
                           period: Duration(milliseconds: 600),
                           baseColor: Colors.white,
                           highlightColor: Colors.white.withAlpha(20),
                           child: Text(
                             "Premium",
                             style: googleBtnTextStyle.copyWith(color: Colors.white, fontSize: 14),
                           ),
                         ),
                       ),
                     ):Container(),
                    //ad.isPrime? Lottie.asset("assets/lottie/premium.json", height: 40, width: 60) : Container(),
                    LikeButton(
                      isLiked: isFav,
                      animationDuration: Duration(milliseconds: 600),
                      onTap: (t) async{
                        
                        !t? fav.addFavorite(ad) : fav.removeFavorite(ad);
                        return !t;
                      },
                      likeBuilder: (bool isLiked) {
                        return Icon(
                          Icons.favorite,
                          color: isLiked ? Colors.deepPurpleAccent : Colors.grey,
                          size: 30,
                        );
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
