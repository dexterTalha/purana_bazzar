import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import '../../firebase_helper/firebase_login.dart';
import '../../models/ad_model.dart';
import '../../utils/ad_view_block.dart';
import '../../utils/constants.dart';

class PostedAds extends StatefulWidget {
  @override
  _PostedAdsState createState() => _PostedAdsState();
}

class _PostedAdsState extends State<PostedAds> with AutomaticKeepAliveClientMixin {
  bool isProductLoading = true;
  List<AdModel> myAds = [];
  User user;

  RefreshController _refreshController = RefreshController(initialRefresh: false);

  void _onRefresh() async {
    // monitor network fetch
    await Future.delayed(Duration(milliseconds: 1000));
    setState(() {
      isProductLoading = true;
    });
    await _getAllProducts();
    _refreshController.refreshCompleted();
  }

  @override
  void initState() {
    super.initState();
    _getAllProducts();
  }

  Future<void> _getAllProducts() async {
    user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      FirebaseLogin().onAuthStateChanged(context);
      return;
    }

    List<AdModel> tempList = [];
    final Dio dio = Dio();
    String url = "${baseUrl}list_my_ads.php?uid=${user.uid}";
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
    myAds = tempList;

    if (this.mounted) {
      setState(() {
        myAds = tempList;
        isProductLoading = false;
      });
    }
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
            ? Center(child: CupertinoActivityIndicator())
            : (myAds.length <= 0
                ? Center(
                    child: Text(
                      "No Ads Uploaded",
                      style: googleBtnTextStyle,
                    ),
                  )
                : GridView.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, childAspectRatio: 0.8),
                    physics: BouncingScrollPhysics(),
                    itemCount: myAds.length,
                    itemBuilder: (_c, i) {
                      return AdViewBlock(
                        ad: myAds[i],
                        type: "myad",
                        isMyAdd: true,
                      );
                    },
                  )),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
