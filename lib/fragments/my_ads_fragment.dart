import 'package:flutter/material.dart';
import '../fragments/ads/favourite_ads.dart';
import '../fragments/ads/posted_ads.dart';
import '../utils/constants.dart';

class MyAdsFragment extends StatefulWidget {
  @override
  _MyAdsFragmentState createState() => _MyAdsFragmentState();
}

class _MyAdsFragmentState extends State<MyAdsFragment> with SingleTickerProviderStateMixin{

  final _adsPages = [PostedAds(), FavouriteAds()];

  int _currentPage = 0;
  TabController _tabController;

  final _pageController = PageController(initialPage: 0, keepPage: true);

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _adsPages.length, vsync: this);
  }
  @override
  void dispose() {
    _tabController.dispose();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Container(
      width: size.width,
      height: size.height,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: tabBuilder((index) {
              setState(() {
                _currentPage = index;
                _pageController.animateToPage(
                  _currentPage,
                  duration: Duration(milliseconds: 200),
                  curve: Curves.easeIn,
                );
              });
            }),
          ),

          ListTile(
            onTap: () {

            },
            title: Text(
              "View Packages",
              textAlign: TextAlign.center,
              style: googleBtnTextStyle.copyWith(color: mPrimaryDarkColor),
            ),
          ),

          Expanded(
            child: PageView.builder(
              physics: NeverScrollableScrollPhysics(),
              scrollDirection: Axis.horizontal,
              controller: _pageController,
              onPageChanged: (index) {
                setState(() {
                  _currentPage = index;
                  _tabController.animateTo(_currentPage);
                });
              },
              itemBuilder: (_, index) {
                return  _adsPages[index];
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget tabBuilder(Function(int) _onTap) {
    return TabBar(
      onTap: _onTap,
      controller: _tabController,
      unselectedLabelColor: mPrimaryDarkColor,
      indicatorSize: TabBarIndicatorSize.label,
      indicator: BoxDecoration(
        borderRadius: BorderRadius.circular(50),
        color: mPrimaryDarkColor,
      ),
      tabs: [
        Tab(
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(50),
              border: Border.all(color: mPrimaryDarkColor, width: 1),
            ),
            child: Align(
              alignment: Alignment.center,
              child: Text("Selling"),
            ),
          ),
        ),
        Tab(
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(50),
              border: Border.all(color: mPrimaryDarkColor, width: 1),
            ),
            child: Align(
              alignment: Alignment.center,
              child: Text("Favourite"),
            ),
          ),
        ),

      ],
    );
  }
}
