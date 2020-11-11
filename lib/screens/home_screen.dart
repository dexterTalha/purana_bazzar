import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:purana_bazzar/fragments/home_fragment.dart';
import 'package:purana_bazzar/fragments/message_fragment.dart';
import 'package:purana_bazzar/fragments/my_ads_fragment.dart';
import 'package:purana_bazzar/fragments/profile_fragment.dart';
import 'package:purana_bazzar/utils/ad_slider.dart';
import 'package:purana_bazzar/utils/category_block.dart';
import 'package:purana_bazzar/utils/constants.dart';
import 'package:purana_bazzar/utils/top_search_bar.dart';

import 'ad_post_screen.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentPage = 0;
  final pages = [
    HomeFragment(),
    MessageFragment(),
    HomeFragment(),
    MyAdsFragment(),
    ProfileFragment(),
  ];
  final titles = ["Home", "Messages", "", "My Ads", "My Profile"];

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: _currentPage == 0 ? mPrimaryColor : Colors.white,
        title: _currentPage != 0
            ? Text(
                titles[_currentPage],
                style: googleBtnTextStyle,
              )
            : TopSearchBar(
                onSearchTap: () {
                  Fluttertoast.showToast(msg: "search");
                },
              ),
        centerTitle: _currentPage != 0,
        actions: _currentPage == 0
            ? [
                /* IconButton(
              icon: Icon(
                Icons.messenger,
                color: Colors.white,
              ),
              onPressed: () {}),*/
                IconButton(
                    icon: Icon(
                      Icons.notifications,
                      color: Colors.white,
                    ),
                    onPressed: () {})
              ]
            : [],
      ),
      bottomNavigationBar: BottomAppBar(
        shape: CircularNotchedRectangle(),
        color: mPrimaryColor,
        child: BottomNavigationBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          iconSize: 30,
          selectedItemColor: Colors.white,
          unselectedItemColor: googleTextColor,
          showUnselectedLabels: false,
          showSelectedLabels: false,
          type: BottomNavigationBarType.fixed,
          currentIndex: _currentPage,
          onTap: (index) {
            if (index != 2) {
              setState(() {
                _currentPage = index;
              });
            }
          },
          items: [
            BottomNavigationBarItem(
              label: "Home",
              icon: Icon(
                Icons.home,
              ),
            ),
            BottomNavigationBarItem(
              label: "Messages",
              icon: Icon(
                Icons.message,
              ),
            ),
            BottomNavigationBarItem(label: "", icon: Container()),
            BottomNavigationBarItem(
              label: "Ads",
              icon: Icon(
                Icons.list_alt_sharp,
              ),
            ),
            BottomNavigationBarItem(
              label: "Profile",
              icon: Icon(
                Icons.emoji_people_sharp,
              ),
            ),
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context,
              CupertinoPageRoute<Null>(builder: (_) => AdPostScreen()));
        },
        backgroundColor: mPrimaryColor,
        child: Icon(Icons.add),
      ),
      body: Container(
        height: size.height,
        width: size.width,
        child: pages[_currentPage],
      ),
    );
  }
}
