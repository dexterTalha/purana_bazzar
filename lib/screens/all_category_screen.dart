import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../models/category_model.dart';
import '../utils/category_block.dart';
import '../utils/constants.dart';

class AllCategoryScreen extends StatefulWidget {

  final bool isPostAd;

  AllCategoryScreen({this.isPostAd = false});

  @override
  _AllCategoryScreenState createState() => _AllCategoryScreenState();
}

class _AllCategoryScreenState extends State<AllCategoryScreen> {

  List<CategoryModel> parentCategory = [], childCategory = [];
  bool isCatLoading = true;


  @override
  void initState() {
    super.initState();
    _getCategories();
  }

  Future<void> _getCategories() async {
    childCategory = [];
    parentCategory = [];
    final Dio dio = Dio();
    String url = "${baseUrl}get_category.php";
    Response response = await dio.get(url);
    var data = jsonDecode(response.data);
    bool status = data['status'];
    if(!status){
      if (this.mounted) {
        setState(() {
          isCatLoading = false;
        });
      }
      Fluttertoast.showToast(msg: "Error in loading categories! Pull to refresh");
      return;
    }
    for(Map<String, dynamic> map in data['data']){
      parentCategory.add(CategoryModel.fromJson(map));
    }
    for (int i = 0; i < parentCategory.length; i++) {
      for (Map childCat in data['data'][i]["sub"])
        childCategory.add(CategoryModel.fromJson(childCat));
    }

    if (this.mounted) {
      setState(() {
        isCatLoading = false;
      });
    }

  }

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
        child: isCatLoading
            ? CupertinoActivityIndicator()
            : GridView.builder(
          shrinkWrap: true,
          scrollDirection: Axis.vertical,
          physics: BouncingScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
          ),
          itemCount: parentCategory.length,
          itemBuilder: (_, index) {
            if (parentCategory.length <= 0) {
              print("no data");
              return Center(
                child: Text(
                  "No Categories",
                  style: googleBtnTextStyle,
                ),
              );
            }
            List<CategoryModel> tempChild = [];
            for (CategoryModel cc in childCategory) {
              if (cc.parent == parentCategory[index].id) tempChild.add(cc);
            }
            return CategoryBlock(
              childrenCat: tempChild,
              parent: parentCategory[index],
              isPostAd: widget.isPostAd,
            );
          },
        ),
      ),
    );
  }
}
