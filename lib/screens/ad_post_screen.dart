import 'dart:io';

import 'package:carousel_slider/carousel_options.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:purana_bazzar/utils/constants.dart';

class AdPostScreen extends StatefulWidget {
  @override
  _AdPostScreenState createState() => _AdPostScreenState();
}

class _AdPostScreenState extends State<AdPostScreen> {
  final _titleController = TextEditingController();
  final _descpController = TextEditingController();
  final _yearController = TextEditingController();
  int imageLength = 0, frameLength = 1;
  List<String> images = [];
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Form(
      key: _formKey,
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          //Todo:change the color according to the theme
          backgroundColor: Colors.white,
        ),
        bottomNavigationBar: BottomAppBar(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: InkWell(
              onTap: () {
                if (_formKey.currentState.validate()) {
                  //Todo: Perform the upload ad operation
                }
              },
              child: Container(
                height: 50,
                color: mPrimaryDarkColor,
                child: Center(
                  child: Text(
                    "Post Ad".toUpperCase(),
                    style: googleBtnTextStyle.copyWith(
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
        body: SafeArea(
          child: Container(
            height: size.height,
            width: size.width,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Text(
                      "POST YOUR AD",
                      textAlign: TextAlign.center,
                      style: googleBtnTextStyle,
                    ),
                  ),
                  CarouselSlider.builder(
                    itemCount: 4,
                    itemBuilder: (c, index) {
                      return Container(
                        height: 120,
                        width: 120,
                        child: _imageUploadBlock(index),
                      );
                    },
                    options: CarouselOptions(
                        scrollPhysics: BouncingScrollPhysics(),
                        pageSnapping: false,
                        viewportFraction: 1,
                        enableInfiniteScroll: false,
                        enlargeCenterPage: true,
                        autoPlay: false,
                        autoPlayCurve: Curves.easeInCubic,
                        aspectRatio: 16 / 9,
                        onPageChanged: (index, reason) {}),
                  ),
                  _buildFormBlock(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _imageUploadBlock(int index) {
    if (images.length == 0) {
      return Center(child: Icon(Icons.add));
    } else if (images[index] == null) {
      return Center(child: Icon(Icons.add));
    } else {
      return Image.asset(
        "assets/png/testing.png",
      );
    }
  }

  Widget _buildFormBlock() {
    return Expanded(
      child: Column(
        children: [
          TextFormField(
            decoration: InputDecoration(
              border: OutlineInputBorder(),
            ),
          ),
        ],
      ),
    );
  }
}
