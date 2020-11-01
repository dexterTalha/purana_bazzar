import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:purana_bazzar/helper/shared_pref.dart';
import 'package:purana_bazzar/screens/login_screen.dart';
import 'package:purana_bazzar/utils/constants.dart';
import 'package:purana_bazzar/utils/fancy_background_app.dart';

class WalkThroughScreen extends StatefulWidget {
  @override
  _WalkThroughScreenState createState() => _WalkThroughScreenState();
}

class _WalkThroughScreenState extends State<WalkThroughScreen> {
  int _current = 0;
  final List<Map<String, dynamic>> imgList = [
    {
      'index': 0,
      'title': 'Title 1',
      'image': 'https://images.unsplash.com/photo-1520342868574-5fa3804e551c?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=6ff92caffcdd63681a35134a6770ed3b&auto=format&fit=crop&w=1951&q=80',
    },
    {
      'index': 1,
      'title': 'Title 2',
      'image': 'https://images.unsplash.com/photo-1522205408450-add114ad53fe?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=368f45b0888aeb0b7b08e3a1084d3ede&auto=format&fit=crop&w=1950&q=80',
    },
    {
      'index': 2,
      'title': 'Title 3',
      'image': 'https://images.unsplash.com/photo-1519125323398-675f0ddb6308?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=94a1e718d89ca60a6337a6008341ca50&auto=format&fit=crop&w=1950&q=80',
    },
    {
      'index': 3,
      'title': 'Title 4',
      'image': 'https://images.unsplash.com/photo-1523205771623-e0faa4d2813d?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=89719a0d55dd05e2deae4120227e6efc&auto=format&fit=crop&w=1953&q=80',
    }
  ];

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      bottomNavigationBar: InkWell(
        onTap: () async{
          await SharedPref().setOld();
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => FancyBackgroundApp(child: LoginScreen(),)));
        },
        splashColor: mPrimaryColor,
        child: Container(
          height: 50,
          color: mPrimaryDarkColor,
          child: Center(
            child: Text(
              "Get Started",
              style: splashTextStyle22.copyWith(
                color: Colors.white,
                fontSize: 17,
                fontWeight: FontWeight.normal,
              ),
            ),
          ),
        ),
      ),
      body: Stack(
        overflow: Overflow.clip,
        children: [
          AnimatedPositioned(
            duration: Duration(milliseconds: 300),
            top: - size.height *0.25 + (_current*20),
            right: - size.height *0.25 + (_current*20),
            child: Container(
              height: size.height * 0.5,
              width: size.height *0.5,
              decoration: BoxDecoration(
                color: mPrimaryColor,
                borderRadius: BorderRadius.circular(size.height * 0.25)
              ),
            ),
          ),
          AnimatedPositioned(
            duration: Duration(milliseconds: 300),
            top: size.height *0.45 + (_current*20),
            left: - size.height * 0.35 + (_current*20),
            child: Container(
              height: size.height * 0.5,
              width: size.height *0.5,
              decoration: BoxDecoration(
                  color: mPrimaryColor,
                  borderRadius: BorderRadius.circular(size.height * 0.25)
              ),
            ),
          ),
          Container(
            height: size.height,
            width: size.width,
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  height: size.height * 0.8,
                  width: size.width,
                  child: CarouselSlider(
                    items: buildWalkThrough(context, size),
                    options: CarouselOptions(
                        scrollPhysics: BouncingScrollPhysics(),
                        enableInfiniteScroll: false,
                        enlargeCenterPage: true,
                        autoPlayCurve: Curves.easeInCubic,
                        aspectRatio: 1.0,
                        onPageChanged: (index, reason) {
                          setState(() {
                            _current = index;
                          });
                        }),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: imgList.map((url) {
                    int index = url['index'];
                    return Container(
                      width: 15.0,
                      height: 15.0,
                      margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 2.0),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: _current == index ? mPrimaryDarkColor : Color.fromRGBO(0, 0, 0, 0.4),
                      ),
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> buildWalkThrough(BuildContext context, size) {
    return imgList.map((e) {
      return Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        child: Container(
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(10)),
          height: size.height * 0.8,
          width: size.width,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 30.0),
                child: Container(
                  height: 140,
                  width: 140,
                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(70)),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(70),
                    child: Image.network(
                      e['image'],
                      fit: BoxFit.fill,
                    ),
                  ),
                ),
              ),
              Spacer(),
              Padding(
                padding: const EdgeInsets.only(bottom: 30.0),
                child: Text(
                  e['title'],
                  style: splashTextStyle22,
                ),
              ),
            ],
          ),
        ),
      );
    }).toList();
  }
}
