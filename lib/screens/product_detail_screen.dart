import 'package:flutter/material.dart';
import 'package:purana_bazzar/utils/constants.dart';

class ProductDetailScreen extends StatefulWidget {
  final int id;

  ProductDetailScreen({this.id});

  @override
  _ProductDetailScreenState createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        title: Text(
          "Product Detail",
          style: googleBtnTextStyle,
        ),
      ),
      body: Container(
        height: size.height,
        width: size.width,
        child: Hero(
          tag: "Product${widget.id}",
          child: Image.asset(
            "assets/png/testing.png",
            height: size.height * 0.5,
            width: size.width,
          ),
        ),
      ),
    );
  }
}
