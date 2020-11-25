import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import '../../helper/favourites_helper.dart';
import '../../models/ad_model.dart';
import '../../utils/ad_view_block.dart';
import '../../utils/constants.dart';

class FavouriteAds extends StatefulWidget {
  @override
  _FavouriteAdsState createState() => _FavouriteAdsState();
}

class _FavouriteAdsState extends State<FavouriteAds> with AutomaticKeepAliveClientMixin {

  final AdsFavorites fav = AdsFavorites();
  List<AdModel> favAds = [];
  bool isProductLoading = true;

  RefreshController _refreshController = RefreshController(initialRefresh: false);

  void _onRefresh() async {
    // monitor network fetch
    await Future.delayed(Duration(milliseconds: 1000));
    setState(() {
      isProductLoading = true;
    });
    _readFavs();
    _refreshController.refreshCompleted();
  }

  @override
  void initState() {
    super.initState();
    _readFavs();
  }

  _readFavs() {
    fav.readAllFavorites().then((value) {
      favAds = value;
      //print(favAds[0].images);
      isProductLoading = false;
      setState(() {

      });
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final size = MediaQuery.of(context).size;
    return SmartRefresher(
      controller: _refreshController,
      onRefresh: _onRefresh,
      enablePullDown: true,
      header: WaterDropHeader(),
      child: Container(
        width: size.width,
        padding: const EdgeInsets.only(top: 10),
        child: isProductLoading
            ? CupertinoActivityIndicator()
            : (favAds.length <= 0
            ? Center(
          child: Text(
            "No Favourite",
            style: googleBtnTextStyle,
          ),)
            : GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, childAspectRatio: 0.8),
          physics: BouncingScrollPhysics(),
          itemCount: favAds.length,
          itemBuilder: (_c, i) {
            return AdViewBlock(
              ad: favAds[i],
              type: "favAds",
              isFav: fav.isFavorite(favAds[i]),
            );
          },
        )),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
