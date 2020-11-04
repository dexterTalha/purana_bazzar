import 'package:flutter/material.dart';
import 'package:purana_bazzar/utils/ad_view_block.dart';
import 'package:purana_bazzar/utils/constants.dart';

class PostedAds extends StatefulWidget {
  @override
  _PostedAdsState createState() => _PostedAdsState();
}

class _PostedAdsState extends State<PostedAds> with AutomaticKeepAliveClientMixin{
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
          AdViewBlock(isMyAdd: true,id: 1,),
          AdViewBlock(isMyAdd: true,id: 2,),
        ],
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;


}
