import 'package:flutter/material.dart';
import 'package:purana_bazzar/utils/ad_slider.dart';
import 'package:purana_bazzar/utils/ad_view_block.dart';
import 'package:purana_bazzar/utils/category_block.dart';
import 'package:purana_bazzar/utils/constants.dart';

class HomeFragment extends StatefulWidget {
  @override
  _HomeFragmentState createState() => _HomeFragmentState();
}

class _HomeFragmentState extends State<HomeFragment> {
  @override
  Widget build(BuildContext context) {
    return ListView(
      physics: BouncingScrollPhysics(),
      children: [
        AdSliderBlock(),
        Padding(
          padding: const EdgeInsets.only(top: 30, left: 20),
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Expanded(
                  child: Text(
                    "Menu",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                /*InkWell(
                  onTap: (){},
                  child: Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: Text(
                      "View All >",
                      textAlign: TextAlign.end,
                      style: TextStyle(
                        fontSize: 15,
                        color: Color.fromRGBO(209, 2, 99, 1),
                      ),
                    ),
                  ),
                ),*/
              ],
            ),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                stops: [0.015, 0.015],
                colors: [
                  Color.fromRGBO(209, 2, 99, 1),
                  Colors.white
                ],
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 20.0, left: 5),
          child: GridView.count(
            shrinkWrap: true,
            scrollDirection: Axis.vertical,
            physics: NeverScrollableScrollPhysics(),
            crossAxisCount: 4,
            children: List.generate(10, (index) => CategoryBlock()),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 30, left: 20),
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Expanded(
                  child: Text(
                    "Trending!",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                InkWell(
                  onTap: (){},
                  child: Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: Text(
                      "View All >",
                      textAlign: TextAlign.end,
                      style: TextStyle(
                        fontSize: 15,
                        color: Color.fromRGBO(209, 2, 99, 1),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                stops: [0.015, 0.015],
                colors: [
                  Color.fromRGBO(209, 2, 99, 1),
                  Colors.white
                ],
              ),
            ),
          ),
        ),
        Container(
          height: 250,
          child: ListView(
            scrollDirection: Axis.horizontal,
            physics: BouncingScrollPhysics(),
            children: [
              AdViewBlock(id: 1),
              AdViewBlock(id: 2),
              AdViewBlock(id: 3),
              AdViewBlock(id: 4),
            ],
          ),
        )
      ],
    );
  }
}
