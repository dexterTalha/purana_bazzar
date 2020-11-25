import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:permission_handler/permission_handler.dart';
import '../fragments/home_fragment.dart';
import '../fragments/message_fragment.dart';
import '../fragments/my_ads_fragment.dart';
import '../fragments/profile_fragment.dart';
import '../screens/all_category_screen.dart';
import '../utils/ad_slider.dart';
import '../utils/category_block.dart';
import '../utils/constants.dart';
import '../utils/top_search_bar.dart';

import 'ad_post_screen.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentPage = 0;
  final Permission perm = Permission.storage;
  PermissionStatus _permissionStatus = PermissionStatus.undetermined;
  final FirebaseMessaging firebaseMessaging = FirebaseMessaging();
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
  final User user = FirebaseAuth.instance.currentUser;

  final pages = [
    HomeFragment(),
    MessageFragment(),
    HomeFragment(),
    MyAdsFragment(),
    ProfileFragment(),
  ];
  final titles = ["Home", "Messages", "", "My Ads", "My Profile"];

  @override
  void initState() {
    super.initState();
    _listenForPermissionStatus().then((value) async => await requestPermission(perm));
    registerNotification();
    configLocalNotification();
  }

  void registerNotification() async{
    await firebaseMessaging.requestNotificationPermissions();

    firebaseMessaging.configure(onMessage: (Map<String, dynamic> message) {
      print('onMessage: $message');
      Platform.isAndroid
          ? showNotification(message['notification'])
          : showNotification(message['aps']['alert']);
      return;
    }, onResume: (Map<String, dynamic> message) {
      print('onResume: $message');
      return;
    }, onLaunch: (Map<String, dynamic> message) {
      print('onLaunch: $message');
      return;
    });

    firebaseMessaging.getToken().then((token) {
      print('token: $token');
      FirebaseFirestore.instance
          .collection('Users')
          .doc(user.uid)
          .update({'token': token});
    }).catchError((err) {
      Fluttertoast.showToast(msg: err.message.toString());
    });
  }

  void configLocalNotification() {
    var initializationSettingsAndroid = AndroidInitializationSettings('app_icon');
    var initializationSettingsIOS = IOSInitializationSettings();
    var initializationSettings = InitializationSettings(android: initializationSettingsAndroid, iOS: initializationSettingsIOS);
    flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  void showNotification(message) async {
    var androidPlatformChannelSpecifics = new AndroidNotificationDetails(
      Platform.isAndroid
          ? 'com.cyl18f.puranabazzar'
          : 'com.cyl18fios.puranabazzar',
      'Purana Bazzar',
      'Message notification for purana bazzar',
      playSound: true,
      enableVibration: true,
      importance: Importance.max,
      priority: Priority.high,
    );
    var iOSPlatformChannelSpecifics = new IOSNotificationDetails();
    var platformChannelSpecifics = new NotificationDetails(
        iOS: iOSPlatformChannelSpecifics, android: androidPlatformChannelSpecifics);

    await flutterLocalNotificationsPlugin.show(0, message['title'].toString(),
        message['body'].toString(), platformChannelSpecifics,
        payload: json.encode(message));

  }

  Future<void> _listenForPermissionStatus() async {
    final status = await perm.status;
    setState(() => _permissionStatus = status);
  }

  Future<void> requestPermission(Permission permission) async {
    final status = await permission.request();

    setState(() {
      print(status);
      _permissionStatus = status;
      print(_permissionStatus);
    });
  }

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
              CupertinoPageRoute<Null>(builder: (_) => AllCategoryScreen(isPostAd: true,)));
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
