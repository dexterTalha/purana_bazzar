import 'package:flutter/material.dart';
import 'package:purana_bazzar/utils/category_block.dart';
import 'package:purana_bazzar/utils/constants.dart';

class AllCategoryScreen extends StatefulWidget {

  final bool isPostAd;


  AllCategoryScreen({this.isPostAd = false});

  @override
  _AllCategoryScreenState createState() => _AllCategoryScreenState();
}

class _AllCategoryScreenState extends State<AllCategoryScreen> {
  @override
  Widget build(BuildContext context) {

    final size = MediaQuery.of(context).size;

    return  Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          "CHOOSE CATEGORY",
          textAlign: TextAlign.center,
          style: googleBtnTextStyle.copyWith(color: Colors.white),
        ),
        centerTitle: true,
        elevation: 0,
        //Todo:change the color according to the theme
        backgroundColor: mPrimaryColor,
      ),
      body: Container(
        height: size.height,
        width: size.width,
        padding: const EdgeInsets.all(10),
        child: GridView.count(
          shrinkWrap: false,
          scrollDirection: Axis.vertical,
          physics: BouncingScrollPhysics(),
          crossAxisCount: 2,
          children: List.generate(10, (index) {
            return CategoryBlock(isPostAd: true,);
          }),
        ),
      ),
    );
  }
}
