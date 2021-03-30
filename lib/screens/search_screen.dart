import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:purana_bazzar/helper/favourites_helper.dart';
import 'package:purana_bazzar/models/ad_model.dart';
import 'package:purana_bazzar/utils/ad_view_block.dart';
import 'package:purana_bazzar/utils/constants.dart';

class SearchScreen extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final _searchTextController = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  final AdsFavorites fav = AdsFavorites();
  List<AdModel> favAds = [], searchAds = [];
  bool isFavProductLoading = true;


  @override
  void initState() {
    super.initState();
    _readFavs();
  }

  _readFavs() {
    fav.readAllFavorites().then((value) {
      favAds = value;
      isFavProductLoading = false;
      setState(() {});
    });
  }

  Future<List<AdModel>> _getSearchProduct() async{
    searchAds = [];
    String url = "${baseUrl}get_search_product.php?query=${_searchTextController.text.trim()}";
    final Dio dio = Dio();
    Response response = await dio.get(url);
    var reply = response.data;
    bool st = reply['status'];
    if(!st){
      return searchAds;
    }
    for(Map m in reply['data']){
      searchAds.add(AdModel.fromJson(m));
    }
    return searchAds;
  }

  @override
  void dispose() {
    _searchTextController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return GestureDetector(
      onTap: () {
        if (_focusNode.hasFocus && _searchTextController.text.isNotEmpty) {
          _focusNode.unfocus();
        }
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: Colors.white,
          elevation: 0,
          title: Row(
            mainAxisSize: MainAxisSize.max,
            children: [
              IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: Icon(
                  Icons.arrow_back,
                  color: mPrimaryDarkColor,
                ),
              ),
              Expanded(
                child: Text(
                  "Search",
                  textAlign: TextAlign.center,
                  style: googleBtnTextStyle.copyWith(fontSize: 20),
                ),
              )
            ],
          ),
        ),
        body: Container(
          height: size.height,
          width: size.width,
          child: ListView(
            shrinkWrap: true,
            physics: BouncingScrollPhysics(),
            children: [
              _focusNode.hasFocus || _searchTextController.text.isNotEmpty
                  ? AnimatedContainer(
                      duration: Duration(milliseconds: 800),
                    )
                  : AnimatedContainer(
                      duration: Duration(milliseconds: 800),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                        child: Text(
                          "Hello, Welcome to Purana Bazzar.\nWhat you want to search?",
                          textAlign: TextAlign.left,
                          style: googleBtnTextStyle.copyWith(fontSize: 30),
                        ),
                      ),
                    ),
              SizedBox(
                height: 20,
              ),
              Hero(
                tag: "search_hero_tag",
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(7),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 15.0,
                        ),
                      ],
                    ),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(7),
                        color: Colors.white,
                      ),
                      child: Material(
                        child: TextFormField(
                          focusNode: _focusNode,
                          autofocus: false,
                          textInputAction: TextInputAction.search,
                          controller: _searchTextController,
                          style: googleBtnRegularTextStyle.copyWith(color: googleTextColor, fontSize: 20),
                          decoration: InputDecoration(
                            border: OutlineInputBorder(borderSide: BorderSide.none),
                            prefixIcon: Icon(
                              Icons.search,
                              color: mPrimaryDarkColor,
                              size: 30,
                            ),
                            hintText: "Search Purana Bazzar",
                            hintStyle: googleBtnRegularTextStyle.copyWith(color: googleTextColor, fontSize: 20),
                            fillColor: Colors.white,
                          ),
                          onFieldSubmitted: (text) {
                            if (text.isEmpty) {
                              Fluttertoast.showToast(msg: "Search tag empty");
                              return;
                            }
                            print(text);
                          },
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  "Favourites",
                  style: googleBtnRegularTextStyle.copyWith(color: googleTextColor, fontSize: 20),
                ),
              ),
              _buildFavourite(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFavourite() {
    return Container(
      height: 250,
      child: isFavProductLoading
          ? CupertinoActivityIndicator()
          : (favAds.length <= 0
              ? Center(
                  child: Text(
                    "No Favourite",
                    style: googleBtnTextStyle,
                  ),
                )
              : ListView.builder(
                  scrollDirection: Axis.horizontal,
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
    );
  }



}
