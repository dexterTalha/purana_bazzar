import 'package:flutter/material.dart';
import 'package:purana_bazzar/utils/ad_view_block.dart';

class FavouriteAds extends StatefulWidget {
  @override
  _FavouriteAdsState createState() => _FavouriteAdsState();
}

class _FavouriteAdsState extends State<FavouriteAds> with AutomaticKeepAliveClientMixin{
  @override
  Widget build(BuildContext context) {
    super.build(context);
    final size = MediaQuery.of(context).size;
    return Container(
      width: size.width,
      height: size.height,
      padding: const EdgeInsets.only(top: 10),
      child: GridView.count(
crossAxisCount: 2,
        children: [

        ],
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
