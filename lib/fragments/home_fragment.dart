import 'dart:convert';
import 'dart:math';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:purana_bazzar/models/slider_model.dart';
import 'package:purana_bazzar/utils/service_block.dart';
import 'package:shimmer/shimmer.dart';
import '../helper/favourites_helper.dart';
import '../helper/shared_pref.dart';
import '../models/ad_model.dart';
import '../models/category_model.dart';
import '../screens/choose_location_screen.dart';
import '../utils/ad_slider.dart';
import '../utils/ad_view_block.dart';
import '../utils/category_block.dart';
import '../utils/constants.dart';
import '../utils/my_separator.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeFragment extends StatefulWidget {
  @override
  _HomeFragmentState createState() => _HomeFragmentState();
}

class _HomeFragmentState extends State<HomeFragment> {
  List<CategoryModel> parentCategory = [], childCategory = [];
  bool isCatLoading = true, isAddressLoading = true, isProductLoading = true, isAdLoading = true;
  String area, city, pincode;
  LatLng l;
  List<AdModel> trending = [], latest = [], electronic = [], properties = [], services = [];
  List<List<AdModel>> allList = [];
  final AdsFavorites fav = AdsFavorites();
  List<AdModel> favAds = [];
  final List<String> headings = ["Trending", "All Latest", "Latest Electronics", "Latest Properties"];

  RefreshController _refreshController = RefreshController(initialRefresh: false);


  void _onRefresh() async{
    // monitor network fetch
    await Future.delayed(Duration(milliseconds: 1000));
    setState(() {
      isCatLoading = true; isAddressLoading = true; isProductLoading = true;
    });
    _getAddress();
    await _getCategories();
    await _getAllProducts();
    _refreshController.refreshCompleted();
  }

  @override
  void initState() {
    super.initState();
    _getAdSlider();
    _getAddress();
    _getCategories();
    _getAllProducts();
  }

  Future<void> _getCategories() async {
    childCategory = [];
    parentCategory = [];
    final Dio dio = Dio();
    String url = "${baseUrl}get_category.php";
    Response response = await dio.get(url);
    var data = jsonDecode(response.data);
    bool status = data['status'];
    if (!status) {
      if (this.mounted) {
        setState(() {
          isCatLoading = false;
        });
      }
      Fluttertoast.showToast(msg: "Error in loading categories! Pull to refresh");
      return;
    }
    for (Map<String, dynamic> map in data['data']) {
      parentCategory.add(CategoryModel.fromJson(map));
    }
    for (int i = 0; i < parentCategory.length; i++) {
      for (Map childCat in data['data'][i]["sub"]) childCategory.add(CategoryModel.fromJson(childCat));
    }

    if (this.mounted) {
      setState(() {
        isCatLoading = false;
      });
    }
  }

  Future<void> _getAllProducts() async {
    trending = [];
    latest = [];
    electronic = [];
    properties = [];
    services = [];
    allList = [];
    List<AdModel> tempList = [];
    final Dio dio = Dio();
    String url = "${baseUrl}fetch_all_product.php";
    Response response = await dio.get(url);
    var data = response.data;
    bool status = data['status'];
    if (!status) {
      if (this.mounted) {
        setState(() {
          isProductLoading = false;
        });
      }
      Fluttertoast.showToast(msg: "Error in loading products! Pull to refresh");
      return;
    }
    for (Map<String, dynamic> map in data['data']) {
      tempList.add(AdModel.fromJson(map));
    }

    tempList.forEach((element) {
      if (element.parent == "5") {
        electronic.add(element);
      } else if (element.parent == "6")
        properties.add(element);
      else if (element.parent == "4") services.add(element);
    });
    getRandomElement(tempList);
    allList.add(trending);
    allList.add(tempList);
    allList.add(electronic);
    allList.add(properties);
    allList.add(services);

    if (this.mounted) {
      setState(() {
        isProductLoading = false;
      });
    }
  }

  getRandomElement(List<AdModel> list) {

    list.forEach((element) {
      final random = new Random();
      var i = random.nextInt(list.length);
      if (trending.length < (list.length < 10 ? list.length : 10)) {
        if (trending.length <= 0) {
          trending.add(list[i]);
        } else {
          if (trending.any((element) => element.id != list[i].id)) {
            trending.add(list[i]);

          }
        }
      } else {
        return;
      }
    });
  }

  void _getAddress() async{
    favAds = await fav.readAllFavorites();
    SharedPreferences preferences;
    SharedPreferences.getInstance().then((value) {
      preferences = value;
      pincode = preferences.getString(SharedPref.PIN);
      area = preferences.getString(SharedPref.AREA) ?? preferences.getString(SharedPref.CITY);
      city = preferences.getString(SharedPref.CITY);
      String latlng = preferences.getString(SharedPref.LATLNG);
      double lat = double.parse(latlng.split(",")[0].trim());
      double lng = double.parse(latlng.split(",")[1].trim());
      l = LatLng(lat, lng);
      isAddressLoading = false;
      if (this.mounted) {
        setState(() {});
      }
    });
  }
  List<AdSliderModel> ads = [];
  Future<void> _getAdSlider() async {
    ads = [];
    final url = "${baseUrl}get_slider.php";
    final dio = Dio();
    Response response = await dio.get(url);
    var data = jsonDecode(response.data);
    bool status = data['status'];
    if (!status) {
      Fluttertoast.showToast(msg: "Error");
      return;
    }
    for (Map<String, dynamic> map in data['data']) {
      ads.add(AdSliderModel.fromJson(map));
    }
    if (this.mounted) {
      setState(() {
        isAdLoading = false;
      });
    }
  }



  @override
  Widget build(BuildContext context) {
    return Container(
      child: SmartRefresher(
        controller: _refreshController,
        onRefresh: _onRefresh,

        enablePullDown: true,
        header: WaterDropMaterialHeader(),
        child: ListView(

          children: [
            isAdLoading? Shimmer.fromColors(
              period: Duration(milliseconds: 600),
              baseColor: mPrimaryColor,
              highlightColor: mPrimaryColor.withAlpha(20),
              child: Container(
                height: 200,
                width: MediaQuery.of(context).size.width,
                color: mPrimaryColor,
              ),
            ) : AdSliderBlock(ads: ads,),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
                    child: Image.asset(
                      "assets/png/map_icon.png",
                      height: 30,
                      width: 30,
                    ),
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  Expanded(
                    child: Container(
                      height: 70,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            isAddressLoading ? "Loading..." : area,
                            style: googleBtnTextStyle.copyWith(color: Colors.black, fontWeight: FontWeight.bold),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Text(isAddressLoading ? "Loading..." : "$city, $pincode"),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 5.0),
                    child: Center(
                      child: InkWell(
                        splashColor: mPrimaryColor.withOpacity(0.3),
                        onTap: () {
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (_) => ChooseLocationScreen(
                                        latLng: l,
                                      )));
                        },
                        onLongPress: () {
                          Fluttertoast.showToast(msg: "Change your location");
                        },
                        child: Container(
                          height: 30,
                          width: 70,
                          decoration: BoxDecoration(border: Border.all(color: mPrimaryColor)),
                          child: Center(
                              child: Text(
                            "Change",
                            style: TextStyle(color: mPrimaryColor, fontSize: 10),
                          )),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 8.0, left: 30),
              child: MySeparator(),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 10, left: 20),
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
                  ],
                ),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    stops: [0.015, 0.015],
                    colors: [Color.fromRGBO(209, 2, 99, 1), Colors.white],
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 10.0, left: 5),
              child: isCatLoading
                  ? CupertinoActivityIndicator()
                  : GridView.builder(
                      shrinkWrap: true,
                      scrollDirection: Axis.vertical,
                      physics: NeverScrollableScrollPhysics(),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 4, ),
                      itemCount: parentCategory.length,
                      itemBuilder: (_, index) {
                        if (parentCategory.length <= 0) {
                          print("no data");
                          return Center(
                            child: Text(
                              "No Categories",
                              style: googleBtnTextStyle,
                            ),
                          );
                        }
                        List<CategoryModel> tempChild = [];
                        for (CategoryModel cc in childCategory) {
                          if (cc.parent == parentCategory[index].id) tempChild.add(cc);
                        }
                        return CategoryBlock(
                          childrenCat: tempChild,
                          parent: parentCategory[index],
                        );
                      },
                    ),
            ),
            isProductLoading ? CupertinoActivityIndicator() : buildProducts(),
            Padding(
              padding: const EdgeInsets.only(top: 10, left: 20),
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Expanded(
                      child: Text(
                        "Services Near You",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    stops: [0.015, 0.015],
                    colors: [Color.fromRGBO(209, 2, 99, 1), Colors.white],
                  ),
                ),
              ),
            ),
            isProductLoading ? CupertinoActivityIndicator() : Container(
              height: 250,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                physics: BouncingScrollPhysics(),
                itemCount: serviceListFixed.length,
                itemBuilder: (_, index) {
                  String id = serviceListFixed[index]['id'];
                  String title = serviceListFixed[index]['title'];
                  String url = serviceListFixed[index]['url'];
                  return ServiceBlock(id: id, title: title, url: url);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildProducts() {


    return ListView.builder(
      itemCount: headings.length,
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemBuilder: (_, index) {
        if (allList[index].length <= 0) {
          return Container();
        }
        return ListView(
          physics: NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 30, left: 20),
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Expanded(
                      child: Text(
                        headings[index],
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () {},
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
                    colors: [Color.fromRGBO(209, 2, 99, 1), Colors.white],
                  ),
                ),
              ),
            ),
            index == 1
                ? Container(
                    height: 250 * 3.0,
                    child: GridView.builder(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, childAspectRatio: 0.8),
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: allList[index].length < 7 ? allList[index].length : 6,
                      itemBuilder: (_c, i) {

                        return AdViewBlock(
                          ad: allList[index][i],
                          type: headings[index],
                          isFav: fav.isFavorite(allList[index][i]),
                        );
                      },
                    ),
                  )
                : Container(
                    height: 250,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      physics: BouncingScrollPhysics(),
                      itemCount: allList[index].length < 16 ? allList[index].length : 15,
                      itemBuilder: (_c, i) {
                        return AdViewBlock(
                          ad: allList[index][i],
                          type: headings[index],
                          isFav: fav.isFavorite(allList[index][i]),
                        );
                      },
                    ),
                  ),
          ],
        );
      },
    );
  }
}
