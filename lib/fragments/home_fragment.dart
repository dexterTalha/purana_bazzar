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
          padding: const EdgeInsets.only(top: 30.0, left: 20),
          child: Text(
            "Menu",
            style: splashTextStyle22.copyWith(color: Colors.black, fontSize: 20),
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
          padding: const EdgeInsets.only(top: 30.0, left: 20),
          child: Text(
            "Trending Ads",
            style: splashTextStyle22.copyWith(color: Colors.black, fontSize: 20),
          ),
        ),
        Container(
          height: 250,
          child: ListView(
            scrollDirection: Axis.horizontal,
            physics: BouncingScrollPhysics(),
            children: [
              AdViewBlock(),
              AdViewBlock(),
              AdViewBlock(),
              AdViewBlock(),
            ],
          ),
        )
      ],
    );
  }
}
