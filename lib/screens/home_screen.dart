import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:purana_bazzar/fragments/home_fragment.dart';
import 'package:purana_bazzar/utils/ad_slider.dart';
import 'package:purana_bazzar/utils/category_block.dart';
import 'package:purana_bazzar/utils/constants.dart';
import 'package:purana_bazzar/utils/top_search_bar.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: TopSearchBar(
          onSearchTap: () {
            Fluttertoast.showToast(msg: "search");
          },
        ),
        actions: [
          IconButton(
              icon: Icon(
                Icons.messenger,
                color: Colors.white,
              ),
              onPressed: () {}),
          IconButton(
              icon: Icon(
                Icons.notifications,
                color: Colors.white,
              ),
              onPressed: () {})
        ],
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
            BottomNavigationBarItem(label: "Messages", icon: Container()),
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
          Fluttertoast.showToast(msg: "Sell");
        },
        backgroundColor: mPrimaryColor,
        child: Icon(Icons.add),
      ),
      body: Container(
        height: size.height,
        width: size.width,
        child: HomeFragment(),
      ),
    );
  }
}
