import 'package:flutter/material.dart';

class NoDataScreen extends StatelessWidget {
  final String assetName;

  NoDataScreen({this.assetName});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Container(
      width: size.width,
      height: size.height,
      child: Image.asset(
        assetName,
        height: size.height,
        width: size.width,
        fit: BoxFit.cover,
      ),
    );
  }
}
