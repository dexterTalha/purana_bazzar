import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:purana_bazzar/models/slider_model.dart';
import 'package:url_launcher/url_launcher.dart';

import 'constants.dart';

class AdSliderBlock extends StatefulWidget {
  @override
  _AdSliderBlockState createState() => _AdSliderBlockState();
}

class _AdSliderBlockState extends State<AdSliderBlock> {
  int _current = 0;
  List<AdSliderModel> ads = [];
  bool isAdLoading = true;


  @override
  initState() {
    super.initState();
    _getAdSlider();
  }

  Future<void> _getAdSlider() async {
    ads = [];
    final url = "${baseUrl}get_slider.php";
    final dio = Dio();
    Response response = await dio.get(url);
    var data = jsonDecode(response.data);
    bool status = data['status'];
    if (!status) {
      Fluttertoast.showToast(msg: "Error");
      return;
    }
    for (Map<String, dynamic> map in data['data']) {
      ads.add(AdSliderModel.fromJson(map));
    }
    if (this.mounted) {
      setState(() {
        isAdLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return isAdLoading ? CupertinoActivityIndicator() : Container(
      height: 200,
      width: MediaQuery.of(context).size.width,
      child: ads.length <= 0
          ? Center(
              child: Text("No Ads found"),
            )
          : Stack(
              fit: StackFit.expand,
              children: [
                CarouselSlider(
                  items: List.generate(ads.length, (index) {
                    return GestureDetector(
                      onTap: () async {
                        String url = ads[index].url;
                        if (url != null) {
                          if (await canLaunch(url)) {
                            await launch(url);
                          } else {
                            throw 'Could not launch $url';
                          }
                        }
                      },
                      child: Container(
                        child: CachedNetworkImage(
                          imageUrl: ads[index].image,
                          fit: BoxFit.cover,
                          width: double.infinity,
                        ),
                      ),
                    );
                  }),
                  options: CarouselOptions(
                      scrollPhysics: BouncingScrollPhysics(),
                      viewportFraction: 1,
                      enableInfiniteScroll: false,
                      enlargeCenterPage: true,
                      autoPlay: true,
                      autoPlayCurve: Curves.linear,
                      aspectRatio: 16 / 9,
                      onPageChanged: (index, reason) {
                        setState(() {
                          _current = index;
                        });
                      }),
                ),
                Positioned(
                  bottom: 0,
                  right: MediaQuery.of(context).size.width * 0.35,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(
                      ads.length,
                      (index) => Container(
                        width: 15.0,
                        height: 15.0,
                        margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 2.0),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: _current == index ? mPrimaryDarkColor : Colors.black87,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}
