import 'package:flutter/material.dart';
import '../utils/constants.dart';

class TopSearchBar extends StatelessWidget {

  final Function onSearchTap;


  TopSearchBar({this.onSearchTap});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return GestureDetector(
      onTap: onSearchTap,
      child: Container(
        height: 60,
        width: size.width,
        padding: const EdgeInsets.only(top: 10, right: 5, left: 10, bottom: 10),
        decoration: BoxDecoration(color: mPrimaryColor),
        child: Container(
          height: double.infinity,
          padding: const EdgeInsets.only(left: 15),
          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(6)),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Row(
              children: [
                Icon(Icons.search, color: googleTextColor,),
                SizedBox(width: 5,),
                Text(
                  "Purana Bazzar",
                  style: googleBtnTextStyle,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
